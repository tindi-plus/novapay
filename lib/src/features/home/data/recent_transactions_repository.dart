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

  // Now call the repository method with dependencies as parameters
  // No additional ref.watch() calls happen inside the method
  return repository.watchRecentTransactions(
    database: database,
    authState: authState,
  );
}
