import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/features/nova_save/domain/savings_goal_model.dart';
import 'package:novapay/src/features/nova_save/presentation/nova_save_screen.dart';
import 'package:novapay/src/features/nova_save/providers/nova_save_provider.dart';

void main() {
  final testDate = DateTime(2025, 12, 31);
  final createdDate = DateTime(2024, 9, 18);

  final testGoals = [
    SavingsGoalModel(
      id: 'goal-001',
      userId: 'user-123',
      name: 'Emergency Fund',
      targetAmountInKobo: 5000000,
      currentAmountInKobo: 1250000,
      targetDate: testDate,
      createdAt: createdDate,
    ),
    SavingsGoalModel(
      id: 'goal-002',
      userId: 'user-123',
      name: 'Vacation Fund',
      targetAmountInKobo: 2000000,
      currentAmountInKobo: 2000000,
      targetDate: testDate.add(const Duration(days: 30)),
      createdAt: createdDate.add(const Duration(days: 5)),
    ),
  ];

  Widget buildNovaSaveScreen({
    List<SavingsGoalModel>? goals,
    int? totalKobo,
    bool isLoading = false,
  }) {
    return ProviderScope(
      overrides: [
        savingsGoalsStreamProvider.overrideWith((ref) {
          if (isLoading) {
            return Stream<List<SavingsGoalModel>>.fromFuture(
              Future.delayed(
                const Duration(milliseconds: 100),
                () => goals ?? [],
              ),
            );
          }
          return Stream<List<SavingsGoalModel>>.value(goals ?? []);
        }),
        totalSavedKoboProvider.overrideWith((ref) {
          if (isLoading) {
            return Stream<int>.fromFuture(
              Future.delayed(
                const Duration(milliseconds: 100),
                () => totalKobo ?? 0,
              ),
            );
          }
          return Stream<int>.value(totalKobo ?? 0);
        }),
      ],
      child: MaterialApp(
        home: const NovaSaveScreen(),
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }

  group('NovaSaveScreen - Header', () {
    testWidgets('displays Nova Save title', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen());
      await tester.pumpAndSettle();
      expect(find.text('Nova Save'), findsOneWidget);
    });

    testWidgets('displays back button', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('NovaSaveScreen - Total Saved Card', () {
    testWidgets('shows total saved label', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNovaSaveScreen(goals: testGoals, totalKobo: 3250000),
      );
      await tester.pumpAndSettle();
      expect(find.text('Total Saved'), findsOneWidget);
    });

    testWidgets('displays formatted amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildNovaSaveScreen(goals: testGoals, totalKobo: 3250000),
      );
      await tester.pumpAndSettle();
      expect(find.text('₦32,500.00'), findsOneWidget);
    });

    testWidgets('shows zero amount', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: [], totalKobo: 0));
      await tester.pumpAndSettle();
      expect(find.text('₦0.00'), findsOneWidget);
    });

    testWidgets('displays loading state', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(isLoading: true));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      await tester.pump(const Duration(milliseconds: 100));
    });
  });

  group('NovaSaveScreen - Savings Goals', () {
    testWidgets('displays all goals', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.text('Emergency Fund'), findsOneWidget);
      expect(find.text('Vacation Fund'), findsOneWidget);
    });

    testWidgets('shows progress percentages', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.text('25%'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('displays amounts', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.text('₦12,500.00 / ₦50,000.00'), findsOneWidget);
    });

    testWidgets('shows progress bars', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });
  });

  group('NovaSaveScreen - Empty State', () {
    testWidgets('shows empty state', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: []));
      await tester.pumpAndSettle();
      expect(find.text('No savings goals yet'), findsOneWidget);
    });

    testWidgets('shows savings icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: []));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.savings), findsOneWidget);
    });

    testWidgets('shows guidance text', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: []));
      await tester.pumpAndSettle();
      expect(
        find.text('Create your first goal to start saving'),
        findsOneWidget,
      );
    });
  });

  group('NovaSaveScreen - FAB', () {
    testWidgets('displays FAB', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('FAB has New Goal label', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.text('New Goal'), findsOneWidget);
    });

    testWidgets('FAB has add icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: testGoals));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('NovaSaveScreen - Edge Cases', () {
    testWidgets('handles single goal', (WidgetTester tester) async {
      await tester.pumpWidget(buildNovaSaveScreen(goals: [testGoals[0]]));
      await tester.pumpAndSettle();
      expect(find.text('Emergency Fund'), findsOneWidget);
    });

    testWidgets('shows 0% for unfunded', (WidgetTester tester) async {
      final zeroGoal = testGoals[0].copyWith(currentAmountInKobo: 0);
      await tester.pumpWidget(buildNovaSaveScreen(goals: [zeroGoal]));
      await tester.pumpAndSettle();
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('clamps at 100%', (WidgetTester tester) async {
      final overGoal = testGoals[0].copyWith(currentAmountInKobo: 6000000);
      await tester.pumpWidget(buildNovaSaveScreen(goals: [overGoal]));
      await tester.pumpAndSettle();
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('handles large amounts', (WidgetTester tester) async {
      final largeGoal = testGoals[0].copyWith(
        targetAmountInKobo: 100000000,
        currentAmountInKobo: 50000000,
      );
      await tester.pumpWidget(buildNovaSaveScreen(goals: [largeGoal]));
      await tester.pumpAndSettle();
      expect(find.text('₦500,000.00 / ₦1,000,000.00'), findsOneWidget);
    });
  });
}
