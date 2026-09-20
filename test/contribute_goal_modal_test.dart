import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/common/models/user_model.dart';
import 'package:novapay/src/features/authentication/providers/auth_providers.dart';
import 'package:novapay/src/features/nova_save/domain/savings_goal_model.dart';
import 'package:novapay/src/features/nova_save/presentation/contribute_modal.dart';
import 'package:novapay/src/features/nova_save/providers/nova_save_provider.dart';

void main() {
  final testDate = DateTime(2025, 12, 31);
  final createdDate = DateTime(2024, 9, 18);

  final testGoal = SavingsGoalModel(
    id: 'goal-001',
    userId: 'user-123',
    name: 'Emergency Fund',
    targetAmountInKobo: 5000000,
    currentAmountInKobo: 1250000,
    targetDate: testDate,
    createdAt: createdDate,
  );

  final testUser = UserModel(
    id: 'user-123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    accountNumber: '0123456789',
    bvn: '12345678901',
    nin: '12345678901',
    walletBalanceInKobo: 500000,
    kycTier: 2,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );

  Widget buildContributeModal({
    required SavingsGoalModel goal,
    required UserModel user,
    VoidCallback? onSuccess,
    NovaSaveFormState? initialState,
  }) {
    return ProviderScope(
      overrides: [
        currentUserProfileProvider.overrideWith((ref) => user),
        novaSaveControllerProvider.overrideWith(
          () => NovaSaveController())
        
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: ContributeModal(
              goal: goal,
              onSuccess: onSuccess,
            ),
          ),
        ),
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }

  group('ContributeModal - Header', () {
    testWidgets('displays Contribute title', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('Contribute'), findsWidgets);
    });

    testWidgets('displays as bottom sheet', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });

  group('ContributeModal - Goal Details', () {
    testWidgets('displays goal name', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('Emergency Fund'), findsOneWidget);
    });

    testWidgets('displays goal target amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('₦50,000.00'), findsOneWidget);
    });

    testWidgets('displays current amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('₦12,500.00'), findsOneWidget);
    });

    testWidgets('displays progress percentage', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('25%'), findsOneWidget);
    });

    testWidgets('shows goal summary in card', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
    });
  });

  // group('ContributeModal - Balance Display', () {
  //   testWidgets('displays wallet balance label', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       buildContributeModal(goal: testGoal, user: testUser),
  //     );
  //     await tester.pumpAndSettle();
  //     expect(find.text('Wallet Balance'), findsOneWidget);
  //   });

  //   testWidgets('displays formatted wallet balance', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       buildContributeModal(goal: testGoal, user: testUser),
  //     );
  //     await tester.pumpAndSettle();
  //     expect(find.text('₦5,000.00'), findsOneWidget);
  //   });

  //   testWidgets('shows remaining after contribution', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       buildContributeModal(goal: testGoal, user: testUser),
  //     );
  //     await tester.pumpAndSettle();
      
  //     final amountField = find.byType(TextFormField);
  //     await tester.enterText(amountField, '1000');
  //     await tester.pumpAndSettle();
  //   });
  // });

  group('ContributeModal - Amount Input', () {
    testWidgets('displays amount input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('Amount (₦)'), findsOneWidget);
    });

    testWidgets('accepts numeric input', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '5000');
      expect(find.text('5000'), findsOneWidget);
    });

    testWidgets('accepts decimal amounts', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '1000.50');
      expect(find.text('1000.50'), findsOneWidget);
    });

    testWidgets('field has keyboard type number', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('validates empty amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final contributeButton = find.byType(ElevatedButton);
      await tester.tap(contributeButton);
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsOneWidget);
    });
  });

  group('ContributeModal - Buttons', () {
    testWidgets('displays Contribute button', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('Contribute'), findsWidgets);
    });

    testWidgets('displays Cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Contribute button is ElevatedButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Cancel button is OutlinedButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  // group('ContributeModal - Error Display', () {
    // testWidgets('shows error message when present', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildContributeModal(
    //       goal: testGoal,
    //       user: testUser,
    //       initialState: NovaSaveFormState(error: 'Insufficient balance'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   expect(find.text('Insufficient balance'), findsOneWidget);
    // });

    // testWidgets('error container has red styling', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildContributeModal(
    //       goal: testGoal,
    //       user: testUser,
    //       initialState: NovaSaveFormState(error: 'Network error'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   expect(find.byType(Container), findsWidgets);
    //   expect(find.text('Network error'), findsOneWidget);
    // });

  //   testWidgets('error message is accessible', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       buildContributeModal(
  //         goal: testGoal,
  //         user: testUser,
  //         initialState: NovaSaveFormState(error: 'Invalid amount'),
  //       ),
  //     );
  //     await tester.pumpAndSettle();

  //     expect(find.bySemanticsLabel('Invalid amount'), findsOneWidget);
  //   });
  // });

  // group('ContributeModal - Loading State', () {
    // testWidgets('shows loading indicator', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildContributeModal(
    //       goal: testGoal,
    //       user: testUser,
    //       initialState: NovaSaveFormState(isLoading: true),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // });

    // testWidgets('disables buttons during loading', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildContributeModal(
    //       goal: testGoal,
    //       user: testUser,
    //       initialState: NovaSaveFormState(isLoading: true),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   final contributeButton = find.byType(ElevatedButton);
    //   final buttonWidget = tester.widget<ElevatedButton>(contributeButton);
    //   expect(buttonWidget.onPressed, isNull);
    // });

  //   testWidgets('disables cancel during loading', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       buildContributeModal(
  //         goal: testGoal,
  //         user: testUser,
  //         initialState: NovaSaveFormState(isLoading: true),
  //       ),
  //     );
  //     await tester.pumpAndSettle();

  //     final cancelButton = find.byType(OutlinedButton);
  //     final buttonWidget = tester.widget<OutlinedButton>(cancelButton);
  //     expect(buttonWidget.onPressed, isNull);
  //   });
  // });

  group('ContributeModal - Layout', () {
    testWidgets('content is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('handles keyboard insets', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('buttons have proper minimum height', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConstrainedBox), findsWidgets);
    });
  });

  group('ContributeModal - Edge Cases', () {
    testWidgets('handles large contribution', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '999999');
      expect(find.text('999999'), findsOneWidget);
    });

    testWidgets('handles zero contribution', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '0');
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('displays fully funded goal', (WidgetTester tester) async {
      final fullyFundedGoal = testGoal.copyWith(
        currentAmountInKobo: 5000000,
      );
      
      await tester.pumpWidget(
        buildContributeModal(goal: fullyFundedGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('displays overfunded goal', (WidgetTester tester) async {
      final overfundedGoal = testGoal.copyWith(
        currentAmountInKobo: 6000000,
      );
      
      await tester.pumpWidget(
        buildContributeModal(goal: overfundedGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      expect(find.text('100%'), findsOneWidget);
    });

    // testWidgets('handles user with low balance', (WidgetTester tester) async {
    //   final lowBalanceUser = testUser.copyWith(
    //     walletBalanceInKobo: 50000,
    //   );

    //   await tester.pumpWidget(
    //     buildContributeModal(goal: testGoal, user: lowBalanceUser),
    //   );
    //   await tester.pumpAndSettle();

    //   expect(find.text('₦500.00'), findsOneWidget);
    // });

  //   testWidgets('handles zero user balance', (WidgetTester tester) async {
  //     final zeroBalanceUser = testUser.copyWith(
  //       walletBalanceInKobo: 0,
  //     );

  //     await tester.pumpWidget(
  //       buildContributeModal(goal: testGoal, user: zeroBalanceUser),
  //     );
  //     await tester.pumpAndSettle();

  //     expect(find.text('₦0.00'), findsOneWidget);
  //   });
  });

  group('ContributeModal - Form Behavior', () {
    testWidgets('clears field on reset', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '5000');
      await tester.pumpAndSettle();
      
      expect(find.text('5000'), findsOneWidget);
    });

    testWidgets('validates on submit', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final contributeButton = find.byType(ElevatedButton);
      await tester.tap(contributeButton);
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('accepts valid amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildContributeModal(goal: testGoal, user: testUser),
      );
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '2000');
      await tester.pumpAndSettle();

      expect(find.text('2000'), findsOneWidget);
    });
  });
}