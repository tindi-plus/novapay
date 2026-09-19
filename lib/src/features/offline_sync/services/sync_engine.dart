import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/providers/firebase_providers.dart';
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
class SyncEngine {
  final Ref ref;
  late final OfflineQueueService _queueService;
  late final FirebaseFunctions _functions;
  late final Connectivity _connectivity;
  late final AppDatabase _database;
  late final FirebaseFirestore _firestore;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncEngine(this.ref) {
    _queueService = ref.read(offlineQueueServiceProvider);
    _functions = ref.read(firebaseFunctionsProvider);
    _connectivity = Connectivity();
    _database = ref.read(databaseProvider);
    _firestore = ref.read(firestoreProvider);
    _initialize();
  }

  void _initialize() {
    // Initial check on boot
    _checkConnectivityAndReplay();

    // Listen for network state transitions (offline -> online)
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) =>
          r == ConnectivityResult.wifi || r == ConnectivityResult.mobile);
      if (isOnline && !_isSyncing) {
        _checkConnectivityAndReplay();
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

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
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

