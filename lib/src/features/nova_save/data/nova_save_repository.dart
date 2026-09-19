import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../authentication/providers/auth_providers.dart';
import '../domain/savings_goal_model.dart';

part 'nova_save_repository.g.dart';

/// Repository for managing savings goals in NovaSave feature.
///
/// Responsibilities:
/// - Provides methods to create and manage savings goals in Firestore
/// - Caches goals locally in Drift for offline viewing
/// - Provides streams of cached goals from Drift (populated from Firestore)
/// - Uses Cloud Functions for atomic idempotent operations (e.g., contributions)
class NovaSaveRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final AppDatabase _database;
  final Ref ref;

  NovaSaveRepository(
    this._firestore,
    this._functions,
    this._database,
    this.ref,
  );

  /// Creates a new savings goal and saves it to Firestore and local cache.
  ///
  /// When online: Creates document under `users/{userId}/savingsGoals/{goalId}` in Firestore.
  /// Always: Caches goal locally into Drift for offline access.
  ///
  /// Returns the created [SavingsGoalModel].
  ///
  /// Throws: Exception if user is not authenticated or validation fails.
  Future<SavingsGoalModel> createSavingsGoal({
    required String name,
    required int targetAmountInKobo,
    required DateTime targetDate,
  }) async {
    final authState = ref.read(authStateProvider);
    final currentUser = authState.value;

    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final userId = currentUser.uid;
    final goalId = const Uuid().v4();
    final now = DateTime.now();

    final goal = SavingsGoalModel(
      id: goalId,
      userId: userId,
      name: name,
      targetAmountInKobo: targetAmountInKobo,
      currentAmountInKobo: 0,
      targetDate: targetDate,
      createdAt: now,
    );

    try {
      // Save to Firestore (will succeed if online)
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('savingsGoals')
          .doc(goalId)
          .set(goal.toJson());

      if (kDebugMode) {
        debugPrint('Savings goal created in Firestore: $goalId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Warning: Could not save to Firestore (offline?): $e');
      }
      // Continue to save locally even if Firestore fails
    }

    // Cache locally in Drift
    await _database.saveSavingsGoal(
      id: goal.id,
      userId: goal.userId,
      name: goal.name,
      targetAmountInKobo: goal.targetAmountInKobo,
      currentAmountInKobo: goal.currentAmountInKobo,
      targetDate: goal.targetDate,
      createdAt: goal.createdAt,
    );

    if (kDebugMode) {
      debugPrint('Savings goal cached locally: $goalId');
    }

    return goal;
  }

  /// Returns a stream of savings goals for a specific user from Drift cache.
  ///
  /// The cache is kept in sync with Firestore by FirestoreSyncService.
  /// This method does not watch providers to avoid re-evaluation cycles.
  Stream<List<SavingsGoalModel>> watchSavingsGoals({required String userId}) {
    return _database.watchSavingsGoalsByUserId(userId).map((localGoals) {
      return localGoals
          .map(
            (goal) => SavingsGoalModel(
              id: goal.id,
              userId: goal.userId,
              name: goal.name,
              targetAmountInKobo: goal.targetAmountInKobo.toInt(),
              currentAmountInKobo: goal.currentAmountInKobo.toInt(),
              targetDate: goal.targetDate,
              createdAt: goal.createdAt,
            ),
          )
          .toList();
    });
  }

  /// Adds a contribution to an existing savings goal using an idempotent Cloud Function.
  ///
  /// Calls the `contributeToSave` Cloud Function which:
  /// - Atomically debits the user's balance
  /// - Credits the savings goal
  /// - Creates a transaction ledger entry
  /// - Handles idempotency via idempotency keys
  ///
  /// Throws: Exception if user is not authenticated, or if the Cloud Function call fails.
  Future<void> contributeSavings({
    required String goalId,
    required int amountInKobo,
    String? note,
  }) async {
    final authState = ref.read(authStateProvider);
    final currentUser = authState.value;

    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final userId = currentUser.uid;

    // Generate idempotency key and transaction ID
    final idempotencyKey = const Uuid().v4();
    final txId = 'tx_$idempotencyKey';

    try {
      // Call the idempotent Cloud Function
      final callable = _functions.httpsCallable('contributeToSave');
      final result = await callable.call({
        'idempotencyKey': idempotencyKey,
        'userId': userId,
        'goalId': goalId,
        'amountInKobo': amountInKobo,
        'txId': txId,
        if (note != null) 'note': note,
      });
      // verify that the function result is a success
      if (result.data['success'] != true) {
        throw Exception('Failed to save goal!');
      }
      if (kDebugMode) {
        debugPrint('Contribution successful via Cloud Function: $goalId');
        debugPrint('Response: ${result.data}');
      }
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        debugPrint('Cloud Function error: ${e.code} - ${e.message}');
      }
      throw Exception('Contribution failed: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected error during contribution: $e');
      }
      rethrow;
    }
  }

  /// Optimistically updates the local goal amount only (for offline queuing).
  ///
  /// This method is used during offline contribution to update the local
  /// cache immediately, providing instant UI feedback. The actual Firestore
  /// update will happen later when the queued transaction is replayed.
  ///
  /// Throws: Exception if goal not found.
  Future<void> updateLocalGoalAmount({
    required String goalId,
    required int amountInKobo,
  }) async {
    // Get current goal from local cache
    final localGoal = await _database.getSavingsGoalById(goalId);
    if (localGoal == null) {
      throw Exception('Savings goal not found');
    }

    final newAmount = localGoal.currentAmountInKobo.toInt() + amountInKobo;

    // Update locally in Drift
    await _database.updateSavingsGoalCurrentAmount(
      goalId,
      currentAmountInKobo: newAmount,
    );

    if (kDebugMode) {
      debugPrint('Savings goal updated locally (optimistic): $goalId');
    }
  }
}

/// Riverpod provider for NovaSaveRepository.
@riverpod
NovaSaveRepository novaSaveRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  final database = ref.watch(databaseProvider);
  return NovaSaveRepository(firestore, functions, database, ref);
}
