import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../common/models/user_model.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../features/authentication/providers/auth_providers.dart';
import '../../../features/offline_sync/services/offline_queue_service.dart';
import '../../../features/offline_sync/services/sync_engine.dart';

part 'send_money_provider.g.dart';

/// Model representing recipient lookup result
class RecipientModel {
  final String accountNumber;
  final String fullName;
  final String userId;

  RecipientModel({
    required this.accountNumber,
    required this.fullName,
    required this.userId,
  });

  factory RecipientModel.fromUserModel(UserModel user) {
    return RecipientModel(
      accountNumber: user.accountNumber,
      fullName: user.fullName,
      userId: user.id,
    );
  }
}

/// Model for send money form state
class SendMoneyFormState {
  final RecipientModel? recipient;
  final int? amountInKobo; // Integer representation (naira * 100)
  final String? idempotencyKey;
  final String? error;
  final bool isLoading;

  SendMoneyFormState({
    this.recipient,
    this.amountInKobo,
    this.idempotencyKey,
    this.error,
    this.isLoading = false,
  });

  SendMoneyFormState copyWith({
    RecipientModel? recipient,
    int? amountInKobo,
    String? idempotencyKey,
    String? error,
    bool? isLoading,
  }) {
    return SendMoneyFormState(
      recipient: recipient ?? this.recipient,
      amountInKobo: amountInKobo ?? this.amountInKobo,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Recipient lookup from Firestore by 10-digit NIBSS account number
@riverpod
Future<RecipientModel?> recipientLookup(
  Ref ref, {
  required String accountNumber,
}) async {
  if (accountNumber.isEmpty || accountNumber.length != 10) {
    return null;
  }

  final firestore = ref.watch(firestoreProvider);

  try {
    final query = await firestore
        .collection('users')
        .where('accountNumber', isEqualTo: accountNumber)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final userData = query.docs.first.data();
    final user = UserModel.fromMap(userData);
    return RecipientModel.fromUserModel(user);
  } catch (e) {
    if (kDebugMode) {
      print('Recipient lookup error: $e');
    }
    return null;
  }
}

/// Validates amount in Kobo against user's wallet balance
@riverpod
Future<String?> validateAmountKobo(
  Ref ref, {
  required int amountInKobo,
}) async {
  final currentUser = await ref.watch(currentUserProfileProvider.future);

  if (currentUser == null) {
    return 'User profile not available';
  }

  if (amountInKobo <= 0) {
    return 'Amount must be greater than zero';
  }

  if (amountInKobo > currentUser.walletBalanceInKobo) {
    final availableNaira =
        (currentUser.walletBalanceInKobo / 100).toStringAsFixed(2);
    return 'Insufficient balance. Available: ₦$availableNaira';
  }

  return null;
}

/// Parse error message from exception
String _parseErrorMessage(dynamic error) {
  if (error is FirebaseFunctionsException) {
    return error.message ?? 'Transaction failed. Please try again.';
  }
  if (error is Exception) {
    return error.toString().replaceFirst('Exception: ', '');
  }
  return 'An error occurred. Please try again.';
}

/// Riverpod provider for SendMoney form state machine
@riverpod
class SendMoney extends _$SendMoney {
  @override
  SendMoneyFormState build() {
    return SendMoneyFormState();
  }

  void setRecipient(RecipientModel? recipient) {
    state = state.copyWith(recipient: recipient);
  }

  void setAmountKobo(int amountInKobo) {
    state = state.copyWith(amountInKobo: amountInKobo);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> processSendMoney({
    required RecipientModel recipient,
    required int amountInKobo,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Validate amount before proceeding
      final currentUser = await ref.read(currentUserProfileProvider.future);
      if (currentUser == null) {
        throw Exception('User profile not found');
      }

      if (amountInKobo <= 0) {
        throw Exception('Amount must be greater than zero');
      }

      if (amountInKobo > currentUser.walletBalanceInKobo) {
        throw Exception('Insufficient balance');
      }

      // Generate idempotency key
      final idempotencyKey = const Uuid().v4();

      // Check network connectivity
      final functions = ref.read(firebaseFunctionsProvider);
      final queueService = ref.read(offlineQueueServiceProvider);
      // final connectivity = Connectivity();
      final connectivityResults = await Connectivity().checkConnectivity();
      final isOnline = connectivityResults.any(
        (r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile,
      );

      // Prepare payload
      final payload = {
        'recipientAccountNumber': recipient.accountNumber,
        'recipientFullName': recipient.fullName,
        'recipientId': recipient.userId,
        'amountInKobo': amountInKobo,
        'senderId': currentUser.id,
        'senderFullName': currentUser.fullName,
      };

      if (isOnline) {
        // Online: Call Cloud Function directly
        final fullPayload = {
          ...payload,
          'idempotencyKey': idempotencyKey,
        };

        final callable = functions.httpsCallable('processSendMoney');
        final result = await callable.call(fullPayload);

        if (result.data == null || result.data['success'] != true) {
          throw Exception(
            result.data?['message'] ?? 'Cloud Function call failed',
          );
        }

        // Show success message
        ref.read(syncNotificationProvider.notifier).show(
              'Transfer successful! Balance updated.',
            );

        state = SendMoneyFormState(
          recipient: recipient,
          amountInKobo: amountInKobo,
          idempotencyKey: idempotencyKey,
          isLoading: false,
        );
      } else {
        // Offline: Queue transaction in Drift
        await queueService.enqueueTransaction(
          actionType: 'send_money',
          payload: payload,
          idempotencyKey: idempotencyKey,
          initialStatus: TransactionStatus.pending,
        );

        // Show pending banner
        ref.read(syncNotificationProvider.notifier).show(
              'Transaction queued: Will send automatically when back online.',
            );

        state = SendMoneyFormState(
          recipient: recipient,
          amountInKobo: amountInKobo,
          idempotencyKey: idempotencyKey,
          isLoading: false,
        );
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('Send money error: $e\n$st');
      }

      final errorMessage = _parseErrorMessage(e);
      state = SendMoneyFormState(
        recipient: recipient,
        amountInKobo: amountInKobo,
        error: errorMessage,
        isLoading: false,
      );
    }
  }

  void resetForm() {
    state = SendMoneyFormState();
  }
}

/// Watch pending transactions from Drift queue
final watchPendingTransactionsProvider = StreamProvider<List<PendingQueueItem>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchPendingQueueItems();
});

/// Watch local transactions history
final watchLocalTransactionsProvider = StreamProvider<List<LocalTransaction>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchLocalTransactions();
});

/// Get specific transaction by ID from local cache
final getLocalTransactionByIdProvider = FutureProvider.family<LocalTransaction?, String>((ref, id) {
  final database = ref.watch(databaseProvider);
  return database.getLocalTransactionById(id);
});
