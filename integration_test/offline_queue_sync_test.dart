import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:novapay/src/common/models/user_model.dart';
import 'package:novapay/src/core/database/app_database.dart';
import 'package:novapay/src/core/database/tables.dart';
import 'package:novapay/src/core/providers/firebase_providers.dart';
import 'package:novapay/src/features/authentication/data/auth_repository.dart';
import 'package:novapay/src/features/offline_sync/services/offline_queue_service.dart';
import 'package:novapay/src/features/send_money/providers/send_money_provider.dart';

import '../test/mockito_mocks.mocks.dart';

/// ---------------------------------------------------------------------------
/// Fake FirebaseAuth
/// ---------------------------------------------------------------------------
///
/// This is retained for tests that need FirebaseAuth directly.
///
/// For currentUserProfileProvider, however, the test overrides
/// authRepositoryProvider with MockAuthRepository. Therefore the provider
/// ultimately uses MockAuthRepository.authStateChanges rather than this fake.
///
class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  FakeFirebaseAuth(this._user);

  final User? _user;

  @override
  User? get currentUser => _user;

  @override
  Stream<User?> authStateChanges() {
    return Stream<User?>.value(_user);
  }
}

/// ---------------------------------------------------------------------------
/// Test Data
/// ---------------------------------------------------------------------------

class TestData {
  static const String testIdempotencyKey =
      '550e8400-e29b-41d4-a716-446655440000';

  static const int initialBalanceKobo = 2500000;
  static const int sendAmountKobo = 500000;
  static const int expectedFinalBalanceKobo = 2000000;

  static const String senderUserId = 'test-user-123';
  static const String senderEmail = 'sender@test.com';
  static const String senderFirstName = 'Test';
  static const String senderLastName = 'Sender';
  static const String senderAccountNumber = '1234567890';
  static const String senderBvn = '11223344556';
  static const String senderNin = '12345678901';

  static const String recipientEmail = 'recipient@test.com';
  static const String recipientFirstName = 'Test';
  static const String recipientLastName = 'Recipient';
  static const String recipientAccountNumber = '0987654321';
  static const String recipientBvn = '66554433221';
  static const String recipientNin = '10987654321';
  static const String recipientUserId = 'recipient-user-456';

  static final UserModel senderUser = UserModel(
    id: senderUserId,
    email: senderEmail,
    firstName: senderFirstName,
    lastName: senderLastName,
    walletBalanceInKobo: initialBalanceKobo,
    kycTier: 2,
    accountNumber: senderAccountNumber,
    bvn: senderBvn,
    nin: senderNin,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  static final UserModel recipientUser = UserModel(
    id: recipientUserId,
    email: recipientEmail,
    firstName: recipientFirstName,
    lastName: recipientLastName,
    walletBalanceInKobo: 0,
    kycTier: 2,
    accountNumber: recipientAccountNumber,
    bvn: recipientBvn,
    nin: recipientNin,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  static final RecipientModel recipient = RecipientModel(
    userId: recipientUserId,
    fullName: '$recipientFirstName $recipientLastName',
    accountNumber: recipientAccountNumber,
  );
}

/// ---------------------------------------------------------------------------
/// Helpers
/// ---------------------------------------------------------------------------

MockUser _createMockUser(String uid) {
  final user = MockUser();

  when(user.uid).thenReturn(uid);
  when(user.email).thenReturn('$uid@test.com');

  return user;
}

/// ---------------------------------------------------------------------------
/// Integration Test
/// ---------------------------------------------------------------------------

Future<void> testOfflineQueueSyncIntegration() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFunctions mockFunctions;
  late MockHttpsCallable mockHttpsCallable;
  late MockConnectivity mockConnectivity;
  late MockAuthRepository mockAuthRepository;
  late MockFirebaseFirestore mockFirestore;

  late ProviderContainer testContainer;
  late AppDatabase database;
  late OfflineQueueService offlineQueueService;

  int cloudFunctionCallCount = 0;

  Map<String, dynamic>? lastCloudFunctionPayload;
  String? lastCloudFunctionPayloadIdempotencyKey;

  setUp(() async {
    mockFunctions = MockFirebaseFunctions();
    mockHttpsCallable = MockHttpsCallable();
    mockConnectivity = MockConnectivity();
    mockAuthRepository = MockAuthRepository();
    mockFirestore = MockFirebaseFirestore();

    cloudFunctionCallCount = 0;
    lastCloudFunctionPayload = null;
    lastCloudFunctionPayloadIdempotencyKey = null;

    database = AppDatabase();

    // IMPORTANT:
    // AppDatabase uses driftDatabase(name: 'nova_pay'), so the database
    // persists between test cases. Clear the queue before every test so
    // tests remain independent of one another.
    await database.delete(database.pendingQueueItems).go();

    offlineQueueService = OfflineQueueService(database);

    // -----------------------------------------------------------------------
    // Firebase Auth / User
    // -----------------------------------------------------------------------
    //
    // These mocks are retained for tests that may use authentication-related
    // providers in the future.
    //
    final mockUser = _createMockUser(TestData.senderUserId);

    when(mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream<User?>.value(mockUser));

    when(mockAuthRepository.getUserProfile(TestData.senderUserId))
        .thenAnswer((_) async => TestData.senderUser);

    // -----------------------------------------------------------------------
    // Firebase Functions
    // -----------------------------------------------------------------------

    when(mockFunctions.httpsCallable('processSendMoney'))
        .thenReturn(mockHttpsCallable);

    when(mockHttpsCallable.call(any)).thenAnswer((invocation) async {
      cloudFunctionCallCount++;

      final callPayload =
          invocation.positionalArguments[0] as Map<dynamic, dynamic>;

      lastCloudFunctionPayload = Map<String, dynamic>.from(callPayload);

      lastCloudFunctionPayloadIdempotencyKey =
          callPayload['idempotencyKey'] as String?;

      final result = MockHttpsCallableResult();

      when(result.data).thenReturn({
        'success': true,
        'message': 'Transaction processed',
        'transactionId':
            'tx-${DateTime.now().millisecondsSinceEpoch}',
      });

      return result;
    });

    // -----------------------------------------------------------------------
    // Connectivity
    // -----------------------------------------------------------------------

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.none]);

    // -----------------------------------------------------------------------
    // Provider Container
    // -----------------------------------------------------------------------

    testContainer = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        firestoreProvider.overrideWithValue(mockFirestore),
        firebaseFunctionsProvider.overrideWithValue(mockFunctions),
      ],
    );
  });

  tearDown(() async {
    testContainer.dispose();

    await database.close();
  });

  group('Offline Queue Synchronization', () {
    test(
      '1. Offline transaction is queued, persisted, and replayed exactly once after reconnect',
      () async {
        // -------------------------------------------------------------------
        // Enqueue transaction while offline
        // -------------------------------------------------------------------

        final queueItemId =
            await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: TestData.testIdempotencyKey,
          payload: {
            'senderUserId': TestData.senderUserId,
            'recipientUserId': TestData.recipientUserId,
            'amountInKobo': TestData.sendAmountKobo,
            'recipientEmail': TestData.recipientEmail,
          },
        );

        expect(queueItemId, isNotNull);

        // -------------------------------------------------------------------
        // Verify persistence
        // -------------------------------------------------------------------

        final queuedItems =
            await offlineQueueService.getPendingItems();

        expect(queuedItems.length, equals(1));

        final queuedItem = queuedItems.first;

        expect(
          queuedItem.idempotencyKey,
          equals(TestData.testIdempotencyKey),
        );

        expect(
          queuedItem.status,
          equals(TransactionStatus.pending.value),
        );

        // -------------------------------------------------------------------
        // Simulate reconnect and replay
        // -------------------------------------------------------------------

        final callable =
            mockFunctions.httpsCallable('processSendMoney');

        await offlineQueueService.updateItemStatus(
          queuedItem.id,
          TransactionStatus.processing,
        );

        final payload =
            jsonDecode(queuedItem.payloadJson)
                as Map<String, dynamic>;

        await callable.call({
          ...payload,
          'idempotencyKey': queuedItem.idempotencyKey,
        });

        await offlineQueueService.deleteQueuedItem(
          queuedItem.id,
        );

        // -------------------------------------------------------------------
        // Verify Cloud Function called exactly once
        // -------------------------------------------------------------------

        expect(
          cloudFunctionCallCount,
          equals(1),
        );

        expect(
          lastCloudFunctionPayloadIdempotencyKey,
          equals(TestData.testIdempotencyKey),
        );

        expect(
          lastCloudFunctionPayload!['amountInKobo'],
          equals(TestData.sendAmountKobo),
        );

        expect(
          lastCloudFunctionPayload!['senderUserId'],
          equals(TestData.senderUserId),
        );

        expect(
          lastCloudFunctionPayload!['recipientUserId'],
          equals(TestData.recipientUserId),
        );

        // -------------------------------------------------------------------
        // Queue should now be empty
        // -------------------------------------------------------------------

        final remainingItems =
            await offlineQueueService.getPendingItems();

        expect(
          remainingItems,
          isEmpty,
        );
      },
    );

    test(
      '2. Multiple offline transactions are enqueued and retrieved in order',
      () async {
        const firstIdempotencyKey =
            '550e8400-e29b-41d4-a716-446655440001';

        const secondIdempotencyKey =
            '550e8400-e29b-41d4-a716-446655440002';

        const thirdIdempotencyKey =
            '550e8400-e29b-41d4-a716-446655440003';

        await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: firstIdempotencyKey,
          payload: {
            'amountInKobo': 100000,
            'recipientUserId': 'recipient-1',
          },
        );

        await Future<void>.delayed(
          const Duration(milliseconds: 10),
        );

        await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: secondIdempotencyKey,
          payload: {
            'amountInKobo': 200000,
            'recipientUserId': 'recipient-2',
          },
        );

        await Future<void>.delayed(
          const Duration(milliseconds: 10),
        );

        await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: thirdIdempotencyKey,
          payload: {
            'amountInKobo': 300000,
            'recipientUserId': 'recipient-3',
          },
        );

        final items =
            await offlineQueueService.getPendingItems();

        expect(
          items.length,
          equals(3),
        );

        expect(
          items[0].idempotencyKey,
          equals(firstIdempotencyKey),
        );

        expect(
          items[1].idempotencyKey,
          equals(secondIdempotencyKey),
        );

        expect(
          items[2].idempotencyKey,
          equals(thirdIdempotencyKey),
        );
      },
    );

    test(
      '3. Duplicate idempotency keys are rejected',
      () async {
        await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: TestData.testIdempotencyKey,
          payload: {
            'amountInKobo': TestData.sendAmountKobo,
            'recipientUserId': TestData.recipientUserId,
          },
        );

        expect(
          () => offlineQueueService.enqueueTransaction(
            actionType: 'sendMoney',
            idempotencyKey: TestData.testIdempotencyKey,
            payload: {
              'amountInKobo': TestData.sendAmountKobo,
              'recipientUserId': TestData.recipientUserId,
            },
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      '4. Queue item status can be updated to processing',
      () async {
        final queueItemId =
            await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: TestData.testIdempotencyKey,
          payload: {
            'amountInKobo': TestData.sendAmountKobo,
          },
        );

        // The item should initially be visible because it is pending.
        var items =
            await offlineQueueService.getPendingItems();

        expect(
          items.length,
          equals(1),
        );

        expect(
          items.first.status,
          equals(TransactionStatus.pending.value),
        );

        // Change the item to processing.
        await offlineQueueService.updateItemStatus(
          queueItemId,
          TransactionStatus.processing,
        );

        // getPendingItems() deliberately filters for status == pending,
        // therefore a processing item must NOT be returned here.
        items =
            await offlineQueueService.getPendingItems();

        expect(
          items,
          isEmpty,
        );

        // Verify directly against the database that the item still exists
        // and its status is now processing.
        final processingItems =
            await (database.select(database.pendingQueueItems)
                  ..where(
                    (tbl) => tbl.id.equals(queueItemId),
                  ))
                .get();

        expect(
          processingItems.length,
          equals(1),
        );

        expect(
          processingItems.first.status,
          equals(TransactionStatus.processing.value),
        );
      },
    );

    test(
      '5. Queue item is deleted after successful synchronization',
      () async {
        final queueItemId =
            await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: TestData.testIdempotencyKey,
          payload: {
            'amountInKobo': TestData.sendAmountKobo,
          },
        );

        var items =
            await offlineQueueService.getPendingItems();

        expect(
          items.length,
          equals(1),
        );

        await offlineQueueService.deleteQueuedItem(
          queueItemId,
        );

        items =
            await offlineQueueService.getPendingItems();

        expect(
          items,
          isEmpty,
        );
      },
    );

    test(
      '6. Kobo amount precision is preserved',
      () async {
        final amount = TestData.sendAmountKobo;

        expect(
          amount,
          equals(500000),
        );

        expect(
          amount / 100,
          equals(5000),
        );

        final queueItemId =
            await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: TestData.testIdempotencyKey,
          payload: {
            'amountInKobo': amount,
          },
        );

        final items =
            await offlineQueueService.getPendingItems();

        expect(
          items.length,
          equals(1),
        );

        final payload =
            jsonDecode(items.first.payloadJson)
                as Map<String, dynamic>;

        expect(
          payload['amountInKobo'],
          equals(TestData.sendAmountKobo),
        );

        await offlineQueueService.deleteQueuedItem(
          queueItemId,
        );
      },
    );

    test(
      '7. Idempotency key persists across app restart',
      () async {
        await offlineQueueService.enqueueTransaction(
          actionType: 'sendMoney',
          idempotencyKey: TestData.testIdempotencyKey,
          payload: {
            'amountInKobo': TestData.sendAmountKobo,
            'recipientUserId': TestData.recipientUserId,
          },
        );

        final firstRead =
            await offlineQueueService.getPendingItems();

        expect(
          firstRead.length,
          equals(1),
        );

        expect(
          firstRead.first.idempotencyKey,
          equals(TestData.testIdempotencyKey),
        );

        // Close the first database instance to simulate an app restart.
        await database.close();

        // Open a new database instance against the same persistent
        // nova_pay database.
        database = AppDatabase();

        offlineQueueService =
            OfflineQueueService(database);

        final secondRead =
            await offlineQueueService.getPendingItems();

        expect(
          secondRead.length,
          equals(1),
        );

        expect(
          secondRead.first.idempotencyKey,
          equals(TestData.testIdempotencyKey),
        );

        expect(
          secondRead.first.idempotencyKey,
          isNotEmpty,
        );
      },
    );

    test(
      '8. Pending queue items are retrieved in insertion order',
      () async {
        final keys = [
          '550e8400-e29b-41d4-a716-446655440011',
          '550e8400-e29b-41d4-a716-446655440012',
          '550e8400-e29b-41d4-a716-446655440013',
        ];

        for (var i = 0; i < keys.length; i++) {
          await offlineQueueService.enqueueTransaction(
            actionType: 'sendMoney',
            idempotencyKey: keys[i],
            payload: {
              'amountInKobo': (i + 1) * 100000,
            },
          );

          if (i < keys.length - 1) {
            await Future<void>.delayed(
              const Duration(milliseconds: 10),
            );
          }
        }

        final items =
            await offlineQueueService.getPendingItems();

        expect(
          items.length,
          equals(3),
        );

        for (var i = 0; i < keys.length; i++) {
          expect(
            items[i].idempotencyKey,
            equals(keys[i]),
          );
        }
      },
    );
  });
}

/// ---------------------------------------------------------------------------
/// Entry point
/// ---------------------------------------------------------------------------

Future<void> main() async {
  await testOfflineQueueSyncIntegration();
}
