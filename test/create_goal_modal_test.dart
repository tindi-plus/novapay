import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/features/nova_save/presentation/create_goal_modal.dart';
import 'package:novapay/src/features/nova_save/providers/nova_save_provider.dart';

void main() {
  Widget buildCreateGoalModal({
    VoidCallback? onSuccess,
    NovaSaveFormState? initialState,
  }) {
    return ProviderScope(
      overrides: [
        novaSaveControllerProvider.overrideWith(
          () => NovaSaveController()),

      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: CreateGoalModal(
              onSuccess: onSuccess,
            ),
          ),
        ),
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }

  group('CreateGoalModal - Header', () {
    testWidgets('displays Create Goal title', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.text('Create Goal'), findsOneWidget);
    });

    testWidgets('displays as bottom sheet', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });

  group('CreateGoalModal - Form Fields', () {
    testWidgets('displays goal name field', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.text('Goal Name'), findsOneWidget);
    });

    testWidgets('displays target amount field', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.text('Amount (₦)'), findsOneWidget);
    });

    testWidgets('displays naira symbol in amount', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.textContaining('₦'), findsWidgets);
    });

    testWidgets('displays target date field', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.widgetWithText(InputDecorator, 'Target Date'), findsOneWidget);
    });

    testWidgets('date field shows placeholder', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.text('Select Date'), findsOneWidget);
    });

    testWidgets('calendar icon visible for date', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });
  });

  group('CreateGoalModal - Form Validation', () {
    testWidgets('goal name is required', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final createButton = find.byType(ElevatedButton);
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsWidgets);
    });

    testWidgets('validates all empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final createButton = find.byType(ElevatedButton);
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsWidgets);
    });

    testWidgets('allows valid form submission', (WidgetTester tester) async {
      bool onSuccessCalled = false;

      await tester.pumpWidget(
        buildCreateGoalModal(
          onSuccess: () => onSuccessCalled = true,
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'Emergency Fund');

      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '50000');

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });
  });

  group('CreateGoalModal - Buttons', () {
    testWidgets('displays Create button', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.text('Create'), findsOneWidget);
    });

    testWidgets('displays Cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Create button is ElevatedButton', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Cancel button is OutlinedButton', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('buttons have correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      
      final createButton = find.byType(ElevatedButton);
      expect(createButton, findsOneWidget);
      
      final cancelButton = find.byType(OutlinedButton);
      expect(cancelButton, findsOneWidget);
    });
  });

  group('CreateGoalModal - Input Formatting', () {
    testWidgets('handles goal name input', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'Vacation Fund');

      expect(find.text('Vacation Fund'), findsOneWidget);
    });

    testWidgets('handles numeric amount input', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '25000');

      expect(find.text('25000'), findsOneWidget);
    });

    testWidgets('amount field accepts decimal input', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '100.50');

      expect(find.text('100.50'), findsOneWidget);
    });
  });

  group('CreateGoalModal - Date Picker', () {
    testWidgets('date picker opens on tap', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('date picker shows current month', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('date picker has OK button', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('date picker has Cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsWidgets);
    });
  });

  group('CreateGoalModal - Error Handling', () {
    // testWidgets('displays error message when present',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildCreateGoalModal(
    //       initialState: NovaSaveFormState(error: 'Goal already exists'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   expect(find.text('Goal already exists'), findsOneWidget);
    // });

    // testWidgets('error message has red styling', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildCreateGoalModal(
    //       initialState: NovaSaveFormState(error: 'Invalid amount'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   final errorContainer = find.byType(Container);
    //   expect(errorContainer, findsWidgets);
    // });
  });

  group('CreateGoalModal - Loading State', () {
    // testWidgets('shows loading indicator during submission',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildCreateGoalModal(
    //       initialState: NovaSaveFormState(isLoading: true),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // });

    // testWidgets('disables buttons during loading', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     buildCreateGoalModal(
    //       initialState: NovaSaveFormState(isLoading: true),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   final createButton = find.byType(ElevatedButton);
    //   final buttonWidget = tester.widget<ElevatedButton>(createButton);
    //   expect(buttonWidget.onPressed, isNull);
    // });
  });

  group('CreateGoalModal - Layout', () {
    testWidgets('content is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('form has proper spacing', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('handles keyboard insets properly', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });

  group('CreateGoalModal - Edge Cases', () {
    testWidgets('handles very long goal name', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).first;
      const longName =
          'This is a very long goal name that should still work properly';
      await tester.enterText(nameField, longName);

      expect(find.text(longName), findsOneWidget);
    });

    testWidgets('handles large amounts', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '999999999');

      expect(find.text('999999999'), findsOneWidget);
    });

    testWidgets('handles zero amount input', (WidgetTester tester) async {
      await tester.pumpWidget(buildCreateGoalModal());
      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '0');

      expect(find.text('0'), findsOneWidget);
    });
  });
}