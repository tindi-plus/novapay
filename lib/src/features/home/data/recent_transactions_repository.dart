import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/models/transaction_model.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/firestore_sync_service.dart';
import '../../authentication/providers/auth_providers.dart';

part 'recent_transactions_repository.g.dart';

/// Repository for managing recent transaction history.
/// 
/// Responsibilities:
/// - Provides stream of cached transactions from Drift for offline viewing
/// - Merges pending transactions from the offline queue with recent transactions
/// - Works in conjunction with FirestoreSyncService to keep cache in sync with Firestore
/// - Supports manual refresh for pull-to-refresh
class RecentTransactionsRepository {
  final Ref ref;

  RecentTransactionsRepository(this.ref);

  /// Returns a stream of recent transactions from Drift (cached).
  /// The cache is automatically kept in sync with Firestore by FirestoreSyncService.
  /// 
  /// NOTE: This method does not watch providers. All provider watching is done
  /// at the Riverpod provider level to prevent re-evaluation cycles that cause
  /// multiple database instances.
  Stream<List<TransactionModel>> watchRecentTransactions({
    required AppDatabase database,
    required AsyncValue<User?> authState,
  }) {
    // If no authenticated user, return empty stream
    if (authState.value == null) {
      return Stream.value([]);
    }

    // Return stream from Drift cache
    return database.watchRecentTransactions().map((recentTxs) {
      return recentTxs
          .map((tx) => TransactionModel(
                id: tx.id,
                amountInKobo: tx.amountInKobo.toInt(),
                type: tx.type,
                title: tx.title,
                status: tx.status,
                createdAt: tx.createdAt,
              ))
          .toList();
    });
  }

  /// Returns a stream of pending transactions from the offline queue.
  Stream<List<TransactionModel>> watchPendingTransactions({
    required AppDatabase database,
    required AsyncValue<User?> authState,
  }) {
    // If no authenticated user, return empty stream
    if (authState.value == null) {
      return Stream.value([]);
    }

    // Get pending queue items and convert them to transaction models
    return database.watchPendingQueueItems().map((queueItems) {
      final pendingTxModels = queueItems
          .map((queueItem) {
            // Determine transaction type from actionType
            final txType = _getTransactionTypeFromAction(queueItem.actionType);
            
            return TransactionModel(
              id: queueItem.id,
              amountInKobo: _extractAmountFromPayload(queueItem.payloadJson),
              type: txType,
              title: _extractTitleFromPayload(queueItem.payloadJson, queueItem.actionType),
              status: 'pending', // Queue items are always pending
              createdAt: queueItem.createdAt,
            );
          })
          .toList();

      return pendingTxModels;
    });
  }

  /// Extracts the transaction type from the queue action type
  String _getTransactionTypeFromAction(String actionType) {
    if (actionType.contains('Send_Money') || actionType.contains('send_money')) {
      return 'debit';
    } else if (actionType.contains('Save_Contribution') || actionType.contains('save_contribution')) {
      return 'savingsContribution';
    }
    return 'debit';
  }

  /// Extracts the amount in Kobo from the payload JSON
  int _extractAmountFromPayload(String payloadJson) {
    try {
      // Basic JSON parsing to extract amount
      if (payloadJson.contains('amountInKobo')) {
        final start = payloadJson.indexOf('"amountInKobo":') + '"amountInKobo":'.length;
        final end = payloadJson.indexOf(',', start);
        final amountStr = payloadJson.substring(start, end > 0 ? end : payloadJson.length).trim();
        return int.tryParse(amountStr) ?? 0;
      } else if (payloadJson.contains('amount')) {
        final start = payloadJson.indexOf('"amount":') + '"amount":'.length;
        final end = payloadJson.indexOf(',', start);
        final amountStr = payloadJson.substring(start, end > 0 ? end : payloadJson.length).trim();
        // Multiply by 100 if it's in naira
        final amount = double.tryParse(amountStr) ?? 0;
        return (amount * 100).toInt();
      }
    } catch (e) {
      // If parsing fails, return 0
    }
    return 0;
  }

  /// Extracts the title from the payload JSON
  String _extractTitleFromPayload(String payloadJson, String actionType) {
    try {
      // Try to find recipient name first
      if (payloadJson.contains('recipientName')) {
        final start = payloadJson.indexOf('"recipientName":"') + '"recipientName":"'.length;
        final end = payloadJson.indexOf('"', start);
        final name = payloadJson.substring(start, end);
        return 'Payment to $name';
      } else if (payloadJson.contains('goalName')) {
        final start = payloadJson.indexOf('"goalName":"') + '"goalName":"'.length;
        final end = payloadJson.indexOf('"', start);
        final name = payloadJson.substring(start, end);
        return 'Saved to $name';
      }
    } catch (e) {
      // If parsing fails, use action type
    }
    
    if (actionType.contains('Send_Money')) {
      return 'Money Transfer';
    } else if (actionType.contains('Save_Contribution')) {
      return 'Savings Contribution';
    }
    return 'Pending Transaction';
  }

  /// Manually refresh transactions from Firestore.
  /// Optionally clears cache first for a full refresh.
  Future<void> refreshTransactions({bool clearCache = false}) async {
    final authState = ref.read(authStateProvider);
    if (authState.value == null) return;

    final database = ref.read(databaseProvider);
    if (clearCache) {
      await database.clearRecentTransactions();
    }

    // The Firestore listener (managed by FirestoreSyncService) will automatically
    // sync new data to Drift. This method is mainly for clearing the cache if needed.
  }
}

/// Riverpod provider for RecentTransactionsRepository.
@riverpod
RecentTransactionsRepository recentTransactionsRepository(Ref ref) {
  return RecentTransactionsRepository(ref);
}

/// StreamProvider that exposes recent transactions to the UI.
/// Automatically watches Drift cache and Firestore updates.
/// Also includes pending transactions from the offline queue.
/// 
/// IMPORTANT: All provider watching is done here at the Riverpod provider level
/// to ensure proper dependency tracking and prevent multiple database instances.
@riverpod
Stream<List<TransactionModel>> recentTransactionsProvider(Ref ref) {
  // Watch all dependencies FIRST, at the provider level
  // This ensures Riverpod's caching and dependency tracking works correctly
  final repository = ref.watch(recentTransactionsRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  final database = ref.watch(databaseProvider);
  
  // Ensure Firestore sync listener is active (important for cache sync)
  // This watches the provider, ensuring the listener is set up
  ref.watch(firestoreSyncServiceProvider);

  // Get both recent and pending transactions
  final recentStream = repository.watchRecentTransactions(
    database: database,
    authState: authState,
  );
  
  final pendingStream = repository.watchPendingTransactions(
    database: database,
    authState: authState,
  );

  // Combine both streams
  return _combineTransactionStreams(recentStream, pendingStream);
}



/// Helper function to combine recent and pending transaction streams
Stream<List<TransactionModel>> _combineTransactionStreams(
  Stream<List<TransactionModel>> recentStream,
  Stream<List<TransactionModel>> pendingStream,
) {
  final controller = StreamController<List<TransactionModel>>();
  
  List<TransactionModel>? lastRecent;
  List<TransactionModel>? lastPending;

  void emitCombined() {
    if (lastRecent != null && lastPending != null) {
      final allTransactions = [...lastRecent!, ...lastPending!];
      // Sort by date (newest first)
      allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      controller.add(allTransactions);
    }
  }

  final recentSubscription = recentStream.listen(
    (recent) {
      lastRecent = recent;
      emitCombined();
    },
    onError: controller.addError,
  );

  final pendingSubscription = pendingStream.listen(
    (pending) {
      lastPending = pending;
      emitCombined();
    },
    onError: controller.addError,
  );

  controller.onCancel = () {
    recentSubscription.cancel();
    pendingSubscription.cancel();
  };

  return controller.stream;
}
