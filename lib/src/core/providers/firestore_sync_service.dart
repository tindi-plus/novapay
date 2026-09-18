import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/app_database.dart';
import '../../common/models/transaction_model.dart';
import '../../features/authentication/providers/auth_providers.dart' as auth;
import 'firebase_providers.dart';

part 'firestore_sync_service.g.dart';

/// Service for managing Firestore listeners and syncing data to the local Drift database.
/// 
/// This service is responsible for:
/// - Setting up Firestore listeners with proper lifecycle management
/// - Syncing incoming data to the Drift database
/// - Handling connection issues gracefully
/// - Cleaning up resources when the listener is no longer needed
class FirestoreSyncService {
  final Ref ref;

  FirestoreSyncService(this.ref);

  /// Sets up a Firestore listener for recent transactions that syncs to Drift.
  /// The listener is kept alive for the duration of this provider's lifecycle.
  /// When the provider is disposed, the listener is automatically cancelled.
  /// 
  /// All dependencies are passed as parameters to avoid calling ref.watch()
  /// inside async methods, which can cause provider re-evaluation issues.
  Future<void> setupRecentTransactionsSyncListener({
    required AsyncValue<User?> authState,
    required FirebaseFirestore firestore,
    required AppDatabase database,
  }) async {
    // If no authenticated user, skip setup
    if (authState.value == null) {
      return;
    }

    final userId = authState.value!.uid;

    // Create the listener subscription
    final subscription = firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(100) // Limit to recent 100 transactions
        .snapshots()
        .listen(
          (snapshot) async {
            // Process each document and save to Drift with proper error handling
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
                // If database connection is closed, the error will be caught here
              }
            }

            // Clean up old transactions (older than 90 days)
            try {
              final ninetyDaysAgo =
                  DateTime.now().subtract(const Duration(days: 90));
              await database.deleteOldRecentTransactions(ninetyDaysAgo);
            } catch (e) {
              if (kDebugMode) {
                debugPrint('Error cleaning old transactions: $e');
              }
              // Silently continue - cache cleanup is non-critical
            }
          },
          onError: (e) {
            if (kDebugMode) {
              debugPrint('Error listening to Firestore transactions: $e');
            }
            // UI will still show cached data from Drift
          },
        );

    // Register the subscription for cleanup when the provider is disposed
    ref.onDispose(() {
      subscription.cancel();
    });
  }
}

/// Provider for FirestoreSyncService.
/// This provider manages the lifecycle of Firestore listeners.
/// When the provider is disposed, all listeners are automatically cancelled.
/// 
/// IMPORTANT: All ref.watch() calls are done at this provider level (not inside the service),
/// so that Riverpod correctly tracks dependencies and caches the database instance.
/// This prevents multiple AppDatabase instances from being created.
@riverpod
Future<void> firestoreSyncService(Ref ref) async {
  // Watch all dependencies at the provider level, BEFORE passing to the service
  // This ensures Riverpod's caching and re-evaluation logic works correctly
  final authState = ref.watch(auth.authStateProvider);
  final firestore = ref.watch(firestoreProvider);
  final database = ref.watch(databaseProvider);
  
  final service = FirestoreSyncService(ref);
  
  // Set up the listener and keep it alive for the duration of this provider
  // Dependencies are passed as parameters, not watched inside the async method
  await service.setupRecentTransactionsSyncListener(
    authState: authState,
    firestore: firestore,
    database: database,
  );
  
  // The listener will be cancelled when this provider is disposed
  // due to the ref.onDispose() call inside setupRecentTransactionsSyncListener()
}
