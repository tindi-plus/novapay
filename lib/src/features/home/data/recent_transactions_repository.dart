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
/// - Works in conjunction with FirestoreSyncService to keep cache in sync with Firestore
/// - Supports manual refresh for pull-to-refresh
class RecentTransactionsRepository {
  final Ref ref;

  RecentTransactionsRepository(this.ref);

  /// Returns a stream of recent transactions from Drift (cached).
  /// The cache is automatically kept in sync with Firestore by FirestoreSyncService.
  Stream<List<TransactionModel>> watchRecentTransactions() {
    // Ensure the Firestore sync listener is active
    // This keeps the Drift cache in sync with Firestore
    ref.watch(firestoreSyncServiceProvider);

    // Get current user state
    final authState = ref.watch(authStateProvider);
    final database = ref.watch(databaseProvider);

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
@riverpod
Stream<List<TransactionModel>> recentTransactionsProvider(Ref ref) {
  final repository = ref.watch(recentTransactionsRepositoryProvider);
  return repository.watchRecentTransactions();
}
