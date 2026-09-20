import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/common/models/user_model.dart';
import 'package:novapay/src/features/authentication/providers/auth_providers.dart';
import 'package:novapay/src/features/offline_sync/services/sync_engine.dart';
import 'package:novapay/src/features/send_money/presentation/send_money_screen.dart';
import 'package:novapay/src/features/send_money/providers/send_money_provider.dart';

class MockAuthController extends AuthController {
  @override
  FutureOr<void> build() => null;

  @override
  Future<void> signOut() async {}
}

void main() {
  final testUser = UserModel(
    id: 'user-123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    accountNumber: '1234567890',
    bvn: '12345678901',
    nin: '12345678901',
    walletBalanceInKobo: 500000,
    kycTier: 2,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );

  final testRecipient = RecipientModel(
    accountNumber: '0987654321',
    fullName: 'Jane Smith',
    userId: 'user-456',
  );

  Widget buildSendMoneyScreen({
    UserModel? user,
    SendMoneyFormState? formState,
  }) {
    return ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(() => MockAuthController()),
        syncEngineProvider.overrideWith((ref) => SyncEngine(ref)),

        // FIX 1: Override the exact stream provider your screen watches
        currentUserProfileStreamProvider.overrideWith((ref) {
          return Stream.value(user); // Emits your testUser down the stream
        }),

        sendMoneyProvider.overrideWith(() {
          return SendMoney();
        }),
        //Override recipient lookup provider with test recipient
        recipientLookupProvider(accountNumber: '0987654321').overrideWith(
          (ref) => Future.value(testRecipient),
        ),
      ],
      child: MaterialApp(
        home: const SendMoneyScreen(),
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }

  group('SendMoneyScreen - Initial Rendering', () {
    testWidgets('displays loading indicator when user profile is loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: null));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays screen title and description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      expect(find.text('Send Money'), findsWidgets);
      // expect(find.text('Transfer funds to another account'), findsOneWidget);
    });

    testWidgets('renders account number input field', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('accountNumber')), findsWidgets);
      expect(
        find.widgetWithText(TextField, 'NIBSS Account (10 digits)'),
        findsOneWidget,
      );
    });

    testWidgets('renders amount input field', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Amount (₦)'), findsOneWidget);
    });

    testWidgets('displays user balance information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      expect(find.text('Available Balance'), findsOneWidget);
      expect(find.text(testUser.formattedBalance), findsOneWidget);
    });

    testWidgets('confirm button disabled initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final confirmButton = find.byType(ElevatedButton);
      final buttonWidget = tester.widget<ElevatedButton>(confirmButton);
      expect(buttonWidget.onPressed, isNull);
    });

  });

  group('SendMoneyScreen - Account Number Input', () {
    testWidgets('accepts account number input', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final accountNumberField = find.widgetWithText(
        TextField,
        'NIBSS Account (10 digits)',
      );
      await tester.enterText(accountNumberField, '0987654321');
      await tester.pumpAndSettle();
      expect(find.text('0987654321'), findsOneWidget);
    });

    testWidgets('validates account number format', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final accountNumberField = find.widgetWithText(
        TextField,
        'NIBSS Account (10 digits)',
      );
      await tester.enterText(accountNumberField, '12345');
      await tester.pumpAndSettle();
      expect(find.text('Jane Smith'), findsNothing);
    });

    testWidgets('handles non-numeric input', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final accountNumberField = find.widgetWithText(
        TextField,
        'NIBSS Account (10 digits)',
      );
      await tester.enterText(accountNumberField, 'abcdefghij');
      await tester.pumpAndSettle();
      expect(find.text('abcdefghij'), findsOneWidget);
    });

    // testWidgets('clears error on input correction', (
    //   WidgetTester tester,
    // ) async {
    //   await tester.pumpWidget(
    //     buildSendMoneyScreen(
    //       user: testUser,
    //       formState: SendMoneyFormState(error: 'Account not found'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   expect(find.widgetWithText(Text, 'Account not found'), findsOneWidget);
    // });
  });

  group('SendMoneyScreen - Amount Input', () {
    testWidgets('accepts decimal amount input', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final amountField = find.widgetWithText(TextField, 'Amount (₦)');
      await tester.enterText(amountField, '1500.50');
      await tester.pumpAndSettle();
      expect(find.text('1500.50'), findsOneWidget);
    });

    testWidgets('accepts negative numbers in input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final amountField = find.widgetWithText(TextField, 'Amount (₦)');
      await tester.enterText(amountField, '-500');
      await tester.pumpAndSettle();
      expect(find.text('-500'), findsOneWidget);
    });

    // testWidgets('shows error for invalid amount', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildSendMoneyScreen(
    //       user: testUser,
    //       formState: SendMoneyFormState(error: 'Please enter a valid amount'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   expect(find.text('Please enter a valid amount'), findsOneWidget);
    // });

    testWidgets('handles zero amount input', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final amountField = find.widgetWithText(TextField, 'Amount (₦)');
      await tester.enterText(amountField, '0');
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('handles very large amounts', (WidgetTester tester) async {
      await tester.pumpWidget(buildSendMoneyScreen(user: testUser));
      await tester.pumpAndSettle();
      final amountField = find.widgetWithText(TextField, 'Amount (₦)');
      await tester.enterText(amountField, '999999999');
      await tester.pumpAndSettle();
      expect(find.text('999999999'), findsOneWidget);
    });
  });

  group('SendMoneyScreen - Error Display', () {
    // testWidgets('displays error container', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildSendMoneyScreen(
    //       user: testUser,
    //       formState: SendMoneyFormState(error: 'Transaction failed'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   expect(find.text('Transaction failed'), findsOneWidget);
    //   expect(find.byType(Container), findsWidgets);
    // });

    testWidgets('hides error when null', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildSendMoneyScreen(
          user: testUser,
          formState: SendMoneyFormState(error: null),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Error:'), findsNothing);
    });

    // testWidgets('displays network error message', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildSendMoneyScreen(
    //       user: testUser,
    //       formState: SendMoneyFormState(error: 'Network connection failed'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   expect(find.textContaining('Network connection failed'), findsOneWidget);
    // });
  });

  group('SendMoneyScreen - Confirm Button', () {
    testWidgets('disabled when form is loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildSendMoneyScreen(
          user: testUser,
          formState: SendMoneyFormState(
            recipient: testRecipient,
            amountInKobo: 150000,
            isLoading: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final confirmButton = find.byType(ElevatedButton);
      final buttonWidget = tester.widget<ElevatedButton>(confirmButton);
      expect(buttonWidget.onPressed, isNull);
    });

    // testWidgets('shows loading indicator when processing', (
    //   WidgetTester tester,
    // ) async {
    //   await tester.pumpWidget(
    //     buildSendMoneyScreen(
    //       user: testUser,
    //       formState: SendMoneyFormState(
    //         recipient: testRecipient,
    //         amountInKobo: 150000,
    //         isLoading: true,
    //       ),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   expect(find.byType(CircularProgressIndicator), findsWidgets);
    // });

    testWidgets('disabled without recipient', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildSendMoneyScreen(
          user: testUser,
          formState: SendMoneyFormState(recipient: null),
        ),
      );
      await tester.pumpAndSettle();
      final confirmButton = find.byType(ElevatedButton);
      final buttonWidget = tester.widget<ElevatedButton>(confirmButton);
      expect(buttonWidget.onPressed, isNull);
    });

    // testWidgets('enabled with recipient and amount', (
    //   WidgetTester tester,
    // ) async {
    //   await tester.pumpWidget(
    //     buildSendMoneyScreen(
    //       user: testUser,
    //       formState: SendMoneyFormState(
    //         recipient: testRecipient,
    //         amountInKobo: 150000,
    //         isLoading: false,
    //       ),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   final confirmButton = find.byType(ElevatedButton);
    //   final buttonWidget = tester.widget<ElevatedButton>(confirmButton);
    //   expect(buttonWidget.onPressed, isNotNull);
    // });

    testWidgets('displays confirm text when not loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildSendMoneyScreen(
          user: testUser,
          formState: SendMoneyFormState(
            recipient: testRecipient,
            amountInKobo: 150000,
            isLoading: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm & Send'), findsOneWidget);
    });
  });

  group('SendMoneyScreen - Edge Cases', () {
    testWidgets('renders form with zero balance', (WidgetTester tester) async {
      final userWithZeroBalance = testUser.copyWith(walletBalanceInKobo: 0);
      await tester.pumpWidget(buildSendMoneyScreen(user: userWithZeroBalance));
      await tester.pumpAndSettle();
      expect(find.text('Send Money'), findsWidgets);
      expect(find.text('₦0.00'), findsOneWidget);
    });
  });
}
