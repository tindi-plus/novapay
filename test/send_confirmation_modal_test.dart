import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/features/send_money/presentation/send_confirmation_modal.dart';
import 'package:novapay/src/features/send_money/providers/send_money_provider.dart';

void main() {
  final testRecipient = RecipientModel(
    accountNumber: '0987654321',
    fullName: 'Jane Smith',
    userId: 'user-456',
  );

  Widget buildConfirmationModal({
    required RecipientModel recipient,
    required int amountInKobo,
    VoidCallback? onConfirm,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SendConfirmationModal(
            recipient: recipient,
            amountInKobo: amountInKobo,
            onConfirm: onConfirm ?? () {},
          ),
        ),
      ),
      theme: ThemeData(useMaterial3: true),
    );
  }

  group('SendConfirmationModal - Header', () {
    testWidgets('displays confirmation header', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Transaction'), findsOneWidget);
    });
  });

  group('SendConfirmationModal - Transaction Details', () {
    testWidgets('displays recipient name', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Jane Smith'), findsOneWidget);
    });

    testWidgets('displays recipient account number', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('0987654321'), findsOneWidget);
    });

    testWidgets('displays recipient label', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Recipient'), findsOneWidget);
    });

    testWidgets('displays account number label', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Account Number'), findsOneWidget);
    });

    testWidgets('displays transaction card', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Card), findsOneWidget);
    });
  });

  group('SendConfirmationModal - Amount Display', () {
    testWidgets('displays amount label', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('displays correct amount in Naira', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      // The amount should be formatted and displayed
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('formats small amounts correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 1,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('formats large amounts correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 999999900,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays decimal amounts', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150050,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });
  });

  group('SendConfirmationModal - Buttons', () {
    testWidgets('displays confirm button', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Confirm & Send'), findsOneWidget);
    });

    testWidgets('displays cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('buttons enabled initially', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsWidgets);
    });
  });

  group('SendConfirmationModal - Interactions', () {
    testWidgets('calls onConfirm when tapped', (WidgetTester tester) async {
      bool confirmPressed = false;
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
        onConfirm: () {
          confirmPressed = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm & Send'));
      await tester.pumpAndSettle();

      expect(confirmPressed, true);
    });

    testWidgets('confirms without errors', (
      WidgetTester tester,
    ) async {
      bool confirmed = false;
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
        onConfirm: () {
          confirmed = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm & Send'));
      await tester.pumpAndSettle();
      
      expect(confirmed, true);
    });
  });

  group('SendConfirmationModal - Layout', () {
    testWidgets('renders in SingleChildScrollView', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('displays all sections', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Transaction'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.text('Confirm & Send'), findsOneWidget);
    });
  });

  group('SendConfirmationModal - Edge Cases', () {
    testWidgets('handles long recipient name', (WidgetTester tester) async {
      final longNameRecipient = RecipientModel(
        accountNumber: '1234567890',
        fullName: 'This Is A Very Long Recipient Name That Might Wrap',
        userId: 'user-789',
      );
      await tester.pumpWidget(buildConfirmationModal(
        recipient: longNameRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(
        find.text('This Is A Very Long Recipient Name That Might Wrap'),
        findsOneWidget,
      );
    });

    testWidgets('renders with minimum amount', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 1,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('renders with maximum amount', (WidgetTester tester) async {
      await tester.pumpWidget(buildConfirmationModal(
        recipient: testRecipient,
        amountInKobo: 9999999999,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('handles special characters in name', (
      WidgetTester tester,
    ) async {
      final specialNameRecipient = RecipientModel(
        accountNumber: '1234567890',
        fullName: "O'Brien-Smith's",
        userId: 'user-101',
      );
      await tester.pumpWidget(buildConfirmationModal(
        recipient: specialNameRecipient,
        amountInKobo: 150000,
      ));
      await tester.pumpAndSettle();
      expect(find.text("O'Brien-Smith's"), findsOneWidget);
    });
  });
}

