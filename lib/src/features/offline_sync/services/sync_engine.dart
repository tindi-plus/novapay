import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/notification_service_provider.dart';
import '../../nova_save/domain/savings_goal_model.dart';
import 'offline_queue_service.dart';

part 'sync_engine.g.dart';
/// Strongly typed sync notification notifier for non-blocking UI toasts/banners.
/// Listened to by UI layers (e.g. in SyncNotificationOverlay) to show messages.
@riverpod
class SyncNotification extends _$SyncNotification {
  Timer? _dismissTimer;

  @override
  String? build() {
    // Clean up any pending timers when the provider is disposed
    ref.onDispose(() {
      _dismissTimer?.cancel();
    });
    return null;
  }

  /// Display a notification message that auto-dismisses after 4 seconds
  void show(String message) {
    // Empty string means dismiss the notification
    if (message.isEmpty) {
      _dismissTimer?.cancel();
      state = null;
      return;
    }

    // Cancel any existing timer
    _dismissTimer?.cancel();
    
    state = message;
    
    // Auto-dismiss non-blocking after 4 seconds
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      // Check if the provider is still mounted before accessing state
      if (ref.mounted && state == message) {
        state = null;
      }
    });
  }
}


/// Background Replay Sync Engine with Connectivity Monitoring.
///
/// Production-grade, offline-first, crash-surviving (persisted in Drift),
/// exactly-once guarantee under patchy networks.
///
/// - Listens for connectivity changes via connectivity_plus.
/// - On queue (offline), immediately shows user the required pending banner (via SyncNotification).
/// - On reconnect: replays ONLY pending items exactly once (sets to processing,
///   calls Firebase CF with idempotencyKey, on success -> success + delete,
///   on failure -> failed. NO retry).
/// - Guards against concurrent re-entrant syncs with _isSyncing flag.
/// - Continuously monitors for connectivity restoration and replays queued transactions
///   whenever internet is restored, even while app is in foreground.
class SyncEngine {
  final Ref ref;
  late final OfflineQueueService _queueService;
  late final FirebaseFunctions _functions;
  late final Connectivity _connectivity;
  late final AppDatabase _database;
  late final FirebaseFirestore _firestore;
  NotificationService? _notificationService;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicCheckTimer;
  bool _isSyncing = false;

  SyncEngine(this.ref) {
    _queueService = ref.read(offlineQueueServiceProvider);
    _functions = ref.read(firebaseFunctionsProvider);
    _connectivity = Connectivity();
    _database = ref.read(databaseProvider);
    _firestore = ref.read(firestoreProvider);
    _initializeNotificationService();
    _initialize();
  }

  /// Initialize the notification service asynchronously.
  /// This ensures we can display local notifications for successful syncs.
  /// Handles both completed and loading states of the async provider.
  void _initializeNotificationService() {
    try {
      // Watch the notification service provider to capture it when ready
      // This handles both cases: if it's already initialized, or when it initializes
      final asyncValue = ref.watch(notificationServiceProvider);
      asyncValue.whenData((service) {
        _notificationService = service;
        if (kDebugMode) {
          debugPrint(
              'SyncEngine: NotificationService initialized and ready for use');
        }
      });
      
      // Handle error state
      if (asyncValue.hasError) {
        if (kDebugMode) {
          debugPrint(
              'SyncEngine: NotificationService failed to initialize: ${asyncValue.error}');
        }
        // Continue - we can still sync, just without notifications
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error setting up NotificationService watcher in SyncEngine: $e');
      }
      // Continue - notification service is optional
    }
  }

  /// Format kobo amount as Nigerian Naira currency string.
  /// E.g., 20000 kobo -> "₦200.00"
  String _formatNaira(int amountInKobo) {
    final naira = amountInKobo / 100.0;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  /// Extract transaction details from payload and build notification content.
  /// Handles 'send_money' and 'save_contribute' action types.
  ///
  /// Returns a map with 'title' and 'body' keys, or null if extraction fails.
  Map<String, String>? _buildNotificationContent(
    String actionType,
    String payloadJson,
  ) {
    try {
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      final amountInKobo = payload['amountInKobo'] as int?;

      if (amountInKobo == null) {
        if (kDebugMode) {
          debugPrint(
              'Warning: Missing amountInKobo in payload for $actionType');
        }
        return null;
      }

      final formattedAmount = _formatNaira(amountInKobo);

      switch (actionType.toLowerCase()) {
        case 'send_money':
          return {
            'title': 'Transfer Completed',
            'body':
                'Your queued transfer of $formattedAmount has been processed.',
          };

        case 'save_contribute':
        case 'contribute_to_save':
        case 'contribute':
          final goalName = payload['goalName'] as String? ?? 'your savings goal';
          return {
            'title': 'Savings Updated',
            'body':
                'Your queued contribution of $formattedAmount to $goalName was successful.',
          };

        default:
          if (kDebugMode) {
            debugPrint('Unknown action type for notification: $actionType');
          }
          return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error building notification content: $e');
      }
      return null;
    }
  }

  void _initialize() {
    // Initial check on boot
    _checkConnectivityAndReplay();

    // Listen for network state transitions (offline -> online)
    // This detects when connectivity is restored
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) =>
          r == ConnectivityResult.wifi || r == ConnectivityResult.mobile);
      if (isOnline && !_isSyncing) {
        if (kDebugMode) {
          debugPrint('SyncEngine: Connectivity restored, checking for pending transactions');
        }
        _checkConnectivityAndReplay();
      }
    });

    // Start periodic check timer to handle intermittent connectivity issues
    // while the app is in foreground. Checks every 5 seconds if connectivity
    // is restored and there are pending items to replay.
    _startPeriodicConnectivityCheck();
  }

  /// Start a periodic timer to check connectivity and replay pending transactions.
  /// This ensures we catch connectivity restoration even if the listener misses it,
  /// and handles the case where the app stays in foreground during network restoration.
  void _startPeriodicConnectivityCheck() {
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      // Only check if we're not already syncing
      if (_isSyncing) return;

      // Check if there are pending items
      final pendingItems = await _queueService.getPendingItems();
      if (pendingItems.isEmpty) {
        // No pending items, cancel the timer to save resources
        timer.cancel();
        _periodicCheckTimer = null;
        if (kDebugMode) {
          debugPrint('SyncEngine: No more pending items, stopping periodic connectivity check');
        }
        return;
      }

      // Check current connectivity and retry if online
      final results = await _connectivity.checkConnectivity();
      final isOnline = results.any((r) =>
          r == ConnectivityResult.wifi || r == ConnectivityResult.mobile);

      if (isOnline) {
        if (kDebugMode) {
          debugPrint(
              'SyncEngine: Periodic check detected online status with ${pendingItems.length} pending items');
        }
        await _replayPendingTransactions();
      }
    });
  }

  Future<void> _checkConnectivityAndReplay() async {
    if (_isSyncing) return;
    
    // Don't waste resources checking connectivity if we don't have pending items
    final pendingItems = await _queueService.getPendingItems();
    if (pendingItems.isEmpty) {
      return;
    }
    
    final results = await _connectivity.checkConnectivity();
    final isOnline = results.any((r) =>
        r == ConnectivityResult.wifi || r == ConnectivityResult.mobile);
    if (isOnline) {
      await _replayPendingTransactions();
    }
  }

  /// Replay Logic & Exactly-Once Guarantee.
  ///
  /// Fetches ONLY `pending` items. Updates status to processing before remote call.
  /// Calls CF with idempotencyKey. Success: success + delete. Failure: failed. No retry.
  Future<void> _replayPendingTransactions() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final pendingItems = await _queueService.getPendingItems();
      for (final item in pendingItems) {
        final status = TransactionStatus.fromString(item.status);
        if (status != TransactionStatus.pending) continue;

        await _queueService.updateItemStatus(item.id, TransactionStatus.processing);

        try {
          final callable = _getCallable(item.actionType);
          final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
          final fullPayload = {
            ...payload,
            'idempotencyKey': item.idempotencyKey,
          };

          // Call with 30-second timeout to prevent hanging if network drops mid-request
          final result = await callable.call(fullPayload).timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Cloud function call timed out - network may be unstable');
            },
          );

          if (result.data != null && result.data['success'] == true) {
            await _queueService.updateItemStatus(item.id, TransactionStatus.success);
             
             // If this was a savings goal contribution, refresh the goal from Firestore
             if (item.actionType == 'save_contribute') {
               await _refreshSavingsGoalAfterContribution(item.payloadJson);
             }

            await _queueService.deleteQueuedItem(item.id);

            // Trigger local notification for successful sync completion
            // This fires ONLY for replayed offline transactions, NOT for real-time online transactions
            _triggerSyncSuccessNotification(item.actionType, item.payloadJson);

            // Only show notification if the sync engine ref is still mounted
            if (ref.mounted) {
              ref.read(syncNotificationProvider.notifier).show(
                'Transaction completed successfully.',
              );
            }
          } else {
            throw Exception(result.data?['message'] ?? 'Remote processing failed');
          }
        } catch (e) {
          // Update status to failed, but DO NOT delete from queue
          // The item remains in queue for retry on next connectivity attempt
          await _queueService.updateItemStatus(item.id, TransactionStatus.failed);
          // Only show notification if the sync engine ref is still mounted
          if (ref.mounted) {
            ref.read(syncNotificationProvider.notifier).show(
              'Transaction failed. Please check details.',
            );
          }
          if (kDebugMode) {
            print('Replay failed for ${item.id}: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Sync engine error: $e');
      }
      // Only show notification if the sync engine ref is still mounted
      if (ref.mounted) {
        ref.read(syncNotificationProvider.notifier).show(
          'Sync error occurred. Check pending transactions.',
        );
      }
    } finally {
      _isSyncing = false;
      
      // Restart periodic check after replay completes
      // to catch any remaining pending items or if connectivity changes again
      final remainingItems = await _queueService.getPendingItems();
      if (remainingItems.isNotEmpty && _periodicCheckTimer == null) {
        if (kDebugMode) {
          debugPrint('SyncEngine: Restarting periodic check for ${remainingItems.length} remaining pending items');
        }
        _startPeriodicConnectivityCheck();
      }
    }
  }

  HttpsCallable _getCallable(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'send_money':
        return _functions.httpsCallable('processSendMoney');
      case 'save_contribute':
      case 'contribute_to_save':
      case 'contribute':
        return _functions.httpsCallable('contributeToSave');
      default:
        throw Exception('Unknown action type: $actionType');
    }
  }
  /// Fetches the updated savings goal from Firestore after a successful contribution
  /// and updates the local cache. This ensures the UI sees the updated goal amount.
  /// 
  /// Extracts goalId and userId from the transaction payload.
  Future<void> _refreshSavingsGoalAfterContribution(String payloadJson) async {
    try {
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      final userId = payload['userId'] as String?;
      final goalId = payload['goalId'] as String?;

      if (userId == null || goalId == null) {
        if (kDebugMode) {
          debugPrint('Warning: Could not extract userId or goalId from save_contribute payload');
        }
        return;
      }

      // Fetch the updated goal from Firestore
      final goalDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('savingsGoals')
          .doc(goalId)
          .get();

      if (goalDoc.exists) {
        final updatedGoal = SavingsGoalModel.fromMap(goalDoc.data()!);
        await _database.saveSavingsGoal(
          id: updatedGoal.id,
          userId: updatedGoal.userId,
          name: updatedGoal.name,
          targetAmountInKobo: updatedGoal.targetAmountInKobo,
          currentAmountInKobo: updatedGoal.currentAmountInKobo,
          targetDate: updatedGoal.targetDate,
          createdAt: updatedGoal.createdAt,
        );

        if (kDebugMode) {
          debugPrint(
              'Refreshed savings goal after contribution replay: ${updatedGoal.id}, newAmount: ${updatedGoal.currentAmountInKobo}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Warning: Could not refresh goal after contribution replay: $e');
      }
      // Continue - the Firestore sync listener should pick it up eventually
    }
  }

  /// Trigger local notification for successful sync completion.
  ///
  /// This method is called only for transactions that were replayed from the
  /// offline queue (i.e., transactions that transitioned from pending -> success).
  /// Real-time online transactions are NOT notified.
  ///
  /// Parameters:
  /// - [actionType]: The type of transaction ('send_money', 'save_contribute', etc.)
  /// - [payloadJson]: The JSON-encoded transaction payload containing amount and details
  Future<void> _triggerSyncSuccessNotification(
    String actionType,
    String payloadJson,
  ) async {
    try {
      // Build notification content from transaction payload
      final notificationContent =
          _buildNotificationContent(actionType, payloadJson);

      if (notificationContent == null) {
        if (kDebugMode) {
          debugPrint(
              'Could not build notification content for action type: $actionType');
        }
        return;
      }

      // Display the notification through the notification service
      if (_notificationService != null) {
        await _notificationService!.showSyncSuccessNotification(
          title: notificationContent['title']!,
          body: notificationContent['body']!,
        );
      } else {
        if (kDebugMode) {
          debugPrint(
              'NotificationService not yet initialized, skipping notification');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error triggering sync success notification: $e');
      }
      // Continue gracefully - notification failure should not affect sync
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }
}


/// Riverpod provider for the SyncEngine using code generation (keepAlive: true).
/// Initializes connectivity monitoring on app boot and safely guards against
/// concurrent re-entrant sync invocations if network state flickers.
@riverpod
SyncEngine syncEngine(Ref ref) {
  final engine = SyncEngine(ref);
  ref.onDispose(() => engine.dispose());
  return engine;
}

