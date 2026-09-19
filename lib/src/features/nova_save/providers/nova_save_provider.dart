import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/firestore_sync_service.dart';
import '../../authentication/providers/auth_providers.dart';
import '../../offline_sync/services/offline_queue_service.dart';
import '../../offline_sync/services/sync_engine.dart';
import '../data/nova_save_repository.dart';
import '../domain/savings_goal_model.dart';

part 'nova_save_provider.g.dart';

/// Form state for NovaSave operations (goal creation, contributions).
class NovaSaveFormState {
  final String? error;
  final bool isLoading;

  NovaSaveFormState({
    this.error,
    this.isLoading = false,
  });

  NovaSaveFormState copyWith({
    String? error,
    bool? isLoading,
  }) {
    return NovaSaveFormState(
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// StreamProvider for active savings goals for current user.
///
/// Watches: auth state, repository, firestore sync service
/// Returns: `Stream<List<SavingsGoalModel>>` of user's goals
@riverpod
Stream<List<SavingsGoalModel>> savingsGoalsStream(Ref ref) {
  // Watch all dependencies at the provider level FIRST
  final authState = ref.watch(authStateProvider);
  final repository = ref.watch(novaSaveRepositoryProvider);

  // Ensure Firestore sync listener is active
  ref.watch(firestoreSyncServiceProvider);

  // If no authenticated user, return empty stream
  if (authState.value == null) {
    return Stream.value([]);
  }

  final userId = authState.value!.uid;
  return repository.watchSavingsGoals(userId: userId);
}

/// StreamProvider calculating total saved Kobo across all active goals.
///
/// Watches: savingsGoalsStreamProvider (via its underlying repository stream)
/// Returns: `Stream<int>` - total saved amount in kobo
@riverpod
Stream<int> totalSavedKobo(Ref ref) {
  // Watch all dependencies at the provider level FIRST
  final authState = ref.watch(authStateProvider);
  final repository = ref.watch(novaSaveRepositoryProvider);

  // Ensure Firestore sync listener is active
  ref.watch(firestoreSyncServiceProvider);

  // If no authenticated user, return empty stream
  if (authState.value == null) {
    return Stream.value(0);
  }

  final userId = authState.value!.uid;

  // Get the stream of goals from repository and transform to total
  return repository.watchSavingsGoals(userId: userId).map((goals) {
    int total = 0;
    for (final goal in goals) {
      total += goal.currentAmountInKobo;
    }
    return total;
  });
}

/// AsyncNotifier for handling NovaSave form state during operations.
///
/// Manages:
/// - Creating new savings goals
/// - Making contributions to existing goals (online and offline)
/// - Loading/error states during operations
class NovaSaveController extends AsyncNotifier<NovaSaveFormState> {
  late final NovaSaveRepository _repository;
  late final OfflineQueueService _queueService;
  late final Connectivity _connectivity;

  @override
  FutureOr<NovaSaveFormState> build() {
    _repository = ref.watch(novaSaveRepositoryProvider);
    _queueService = ref.watch(offlineQueueServiceProvider);
    _connectivity = Connectivity();
    return NovaSaveFormState();
  }

  /// Creates a new savings goal.
  Future<void> createSavingsGoal({
    required String name,
    required int targetAmountInKobo,
    required DateTime targetDate,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final goal = await _repository.createSavingsGoal(
          name: name,
          targetAmountInKobo: targetAmountInKobo,
          targetDate: targetDate,
        );

        if (kDebugMode) {
          debugPrint('Goal created: ${goal.name}');
        }

        // Show success notification
        ref.read(syncNotificationProvider.notifier).show(
              'Savings goal "${goal.name}" created successfully!',
            );

        return NovaSaveFormState();
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('Error creating goal: $e\n$st');
        }

        final errorMessage = _parseErrorMessage(e);
        return NovaSaveFormState(error: errorMessage);
      }
    });
  }
   /// Adds a contribution to an existing savings goal with offline-first support.
   ///
   /// When online: Calls Firebase Cloud Function directly via repository.
   /// When offline: Optimistically updates local goal, enqueues for later sync.
   /// 
   /// Generates unique idempotencyKey and txId for exactly-once guarantee.
   Future<void> contributeToGoal({
     required String goalId,
     required int amountInKobo,
   }) async {
     state = const AsyncLoading();

     state = await AsyncValue.guard(() async {
       try {
         // Generate unique identifiers
         const uuid = Uuid();
         final idempotencyKey = uuid.v4();
         final txId = uuid.v4();

         // Check network connectivity
         final connectivityResults = await _connectivity.checkConnectivity();
         final isOnline = connectivityResults.any((result) =>
             result == ConnectivityResult.wifi ||
             result == ConnectivityResult.mobile);

         if (isOnline) {
           // Online: Call Firebase Cloud Function directly
           await _repository.contributeSavings(
             goalId: goalId,
             amountInKobo: amountInKobo,
           );

           if (kDebugMode) {
             debugPrint(
               'Contribution added online: $amountInKobo kobo (idempotencyKey: $idempotencyKey)',
             );
           }

           // Show success notification
           ref.read(syncNotificationProvider.notifier).show(
                 'Contribution saved successfully!',
               );
         } else {
           // Offline: Optimistically update local goal and enqueue
           if (kDebugMode) {
             debugPrint(
               'Network offline. Queuing contribution: $amountInKobo kobo',
             );
           }

           // 1. Optimistically update local goal amount
           await _repository.updateLocalGoalAmount(
             goalId: goalId,
             amountInKobo: amountInKobo,
           );

           // 2. Enqueue the transaction for later sync
           final userId = ref.read(authStateProvider).value?.uid;
           if (userId == null) {
             throw Exception('User not authenticated');
           }

           final payload = {
             'userId': userId,
             'goalId': goalId,
             'amountInKobo': amountInKobo,
             'txId': txId,
           };

           await _queueService.enqueueTransaction(
             actionType: 'save_contribute',
             payload: payload,
             idempotencyKey: idempotencyKey,
           );

           if (kDebugMode) {
             debugPrint(
               'Contribution queued: $amountInKobo kobo (idempotencyKey: $idempotencyKey)',
             );
           }

           // 3. Show non-blocking toast notification
           ref.read(syncNotificationProvider.notifier).show(
                 'Contribution queued: Will process automatically when back online.',
               );
         }

         return NovaSaveFormState();
       } catch (e, st) {
         if (kDebugMode) {
           debugPrint('Error adding contribution: $e\\n$st');
         }

         final errorMessage = _parseErrorMessage(e);
         return NovaSaveFormState(error: errorMessage);
       }
     });
   }



  /// Adds a contribution to an existing savings goal.
  Future<void> contributeSavings({
    required String goalId,
    required int amountInKobo,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _repository.contributeSavings(
          goalId: goalId,
          amountInKobo: amountInKobo,
        );

        if (kDebugMode) {
          debugPrint('Contribution added: $amountInKobo kobo');
        }

        // Show success notification
        ref.read(syncNotificationProvider.notifier).show(
              'Contribution saved successfully!',
            );

        return NovaSaveFormState();
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('Error adding contribution: $e\n$st');
        }

        final errorMessage = _parseErrorMessage(e);
        return NovaSaveFormState(error: errorMessage);
      }
    });
  }

  /// Resets form state to initial state.
  void resetForm() {
    state = AsyncValue.data(NovaSaveFormState());
  }

  /// Parses error messages for user-friendly display.
  String _parseErrorMessage(Object error) {
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('User not authenticated')) {
        return 'Please sign in to manage savings goals.';
      }
      if (message.contains('Savings goal not found')) {
        return 'Savings goal not found.';
      }
      if (message.contains('FirebaseException')) {
        return 'Network error. Please try again.';
      }
      return message.replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

/// Riverpod provider for NovaSaveController.
final novaSaveControllerProvider =
    AsyncNotifierProvider<NovaSaveController, NovaSaveFormState>(
  NovaSaveController.new,
);
