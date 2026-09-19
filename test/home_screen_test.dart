import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/common/models/transaction_model.dart';
import 'package:novapay/src/common/models/user_model.dart';
import 'package:novapay/src/features/authentication/providers/auth_providers.dart';
import 'package:novapay/src/features/home/data/recent_transactions_repository.dart';
import 'package:novapay/src/features/home/presentation/home_screen.dart';
import 'package:novapay/src/features/offline_sync/services/sync_engine.dart';

class MockAuthController extends AuthController {
  @override
  FutureOr<void> build() => null;

  @override
  Future<void> signOut() async {}
}

void main() {
  final testUser = UserModel(
    id: 'user-123',
    firstName: 'Jane',
    lastName: 'Doe',
    email: 'jane@example.com',
    accountNumber: '0123456789',
    bvn: '12345678901',
    nin: '12345678901',
    walletBalanceInKobo: 150000,
    kycTier: 2,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );

  final testTransactions = [
    TransactionModel(
      id: 'tx-1',
      amountInKobo: 20000,
      type: 'debit',
      title: 'Groceries',
      status: 'completed',
      createdAt: DateTime(2024, 9, 17, 18, 30),
    ),
    TransactionModel(
      id: 'tx-2',
      amountInKobo: 35000,
      type: 'credit',
      title: 'Salary',
      status: 'completed',
      createdAt: DateTime(2024, 9, 18, 9, 0),
    ),
  ];

  Widget buildHomeScreen({
    UserModel? user,
    List<TransactionModel>? transactions,
    bool isLoading = false,
  }) {
    return ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(() => MockAuthController()),
        syncEngineProvider.overrideWith((ref) => SyncEngine(ref)),
        currentUserProfileStreamProvider.overrideWith((ref) {
          if (isLoading) {
            return Stream<UserModel?>.fromFuture(
              Future.delayed(const Duration(milliseconds: 100), () => user),
            );
          }
          return Stream<UserModel?>.value(user);
        }),
        recentTransactionsProviderProvider.overrideWith((ref) {
          if (transactions == null) {
            return const Stream<List<TransactionModel>>.empty();
          }
          return Stream<List<TransactionModel>>.value(transactions);
        }),
      ],
      child: MaterialApp(home: const HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets('shows a loading indicator while the user profile is loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHomeScreen(user: testUser, isLoading: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows a fallback message when no profile is available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildHomeScreen(user: null));
      await tester.pumpAndSettle();

      expect(find.text('No profile found'), findsOneWidget);
    });

    testWidgets('renders the home dashboard for a valid user profile', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildHomeScreen(user: testUser, transactions: testTransactions),
      );
      await tester.pumpAndSettle();

      expect(find.text('NovaPay'), findsOneWidget);
      expect(find.text('Welcome, Jane Doe'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text(testUser.formattedBalance), findsOneWidget);
      expect(find.text('NIBSS Account'), findsOneWidget);
      expect(find.text('Tier 2'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Send Money'), findsNWidgets(2));
      expect(find.text('Nova Save'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);
    });

    testWidgets('displays a no-transactions state when the list is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildHomeScreen(user: testUser, transactions: const []),
      );
      await tester.pumpAndSettle();

      expect(find.text('No transactions yet'), findsOneWidget);
      expect(find.text('No transactions'), findsOneWidget);
    });

    testWidgets('renders recent transactions with amounts and dates', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildHomeScreen(user: testUser, transactions: testTransactions),
      );
      await tester.pumpAndSettle();

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('-₦200.00'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('+₦350.00'), findsOneWidget);
    });
  });
}
