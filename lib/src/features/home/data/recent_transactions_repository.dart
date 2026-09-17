import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/models/transaction_model.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../authentication/providers/auth_providers.dart';

part 'recent_transactions_repository.g.dart';

/// Repository for managing recent transaction history.
/// 
/// Responsibilities:
/// - Listens to Firestore `users/{uid}/transactions` sub-collection
/// - Caches incoming transactions in Drift `RecentTransactions` table
/// - Provides stream of cached transactions for offline viewing
/// - Supports manual refresh for pull-to-refresh
class RecentTransactionsRepository {
  final Ref ref;

  RecentTransactionsRepository(this.ref);

  /// Returns a stream of recent transactions from Drift (cached).
  /// Simultaneously listens to Firestore to update the cache.
  Stream<List<TransactionModel>> watchRecentTransactions() {
    // Get current user's UID
    final authState = ref.watch(authStateProvider);
    final firestore = ref.watch(firestoreProvider);
    final database = ref.watch(databaseProvider);

    // If no authenticated user, return empty stream
    if (authState.value == null) {
      return Stream.value([]);
    }

    final userId = authState.value!.uid;

    // Start listening to Firestore in the background
    _setupFirestoreListener(firestore, database, userId);

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

  /// Sets up a background Firestore listener to sync transactions to Drift.
  /// This listener runs independently and updates the cache as new data arrives.
  void _setupFirestoreListener(
    FirebaseFirestore firestore,
    AppDatabase database,
    String userId,
  ) {
    firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(100) // Limit to recent 100 transactions
        .snapshots()
        .listen(
          (snapshot) async {
            // Process each document and save to Drift
            for (final doc in snapshot.docs) {
              try {
                final txModel = TransactionModel.fromFirestoreDoc(doc);
                await database.saveRecentTransaction(
                  id: txModel.id,
                  amountInKobo: txModel.amountInKobo,
                  type: txModel.type,
                  title: txModel.title,
                  status: txModel.status,
                  firebaseId: doc.id, // Use Firestore doc ID for deduplication
                  createdAt: txModel.createdAt,
                );
              } catch (e) {
                if (kDebugMode) {
                  debugPrint('Error saving transaction from Firestore: $e');
                }
                // Continue processing other documents
              }
            }

            // Clean up old transactions (older than 90 days)
            final ninetyDaysAgo =
                DateTime.now().subtract(const Duration(days: 90));
            await database.deleteOldRecentTransactions(ninetyDaysAgo);
          },
          onError: (e) {
            if (kDebugMode) {
              debugPrint('Error listening to Firestore transactions: $e');
            }
            // UI will still show cached data from Drift
          },
        );
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

    // The Firestore listener will automatically sync new data to Drift
    // This method is mainly for triggering the listener to fetch fresh data
    // In practice, the listener should already be active from watchRecentTransactions()
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
