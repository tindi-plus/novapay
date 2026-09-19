import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/features/nova_save/domain/savings_goal_model.dart';

void main() {
  group('SavingsGoalModel', () {
    final testDate = DateTime(2025, 12, 31);
    final createdDate = DateTime(2024, 9, 18);

    final testGoal = SavingsGoalModel(
      id: 'goal-001',
      userId: 'user-123',
      name: 'Emergency Fund',
      targetAmountInKobo: 5000000, // ₦50,000.00
      currentAmountInKobo: 1250000, // ₦12,500.00
      targetDate: testDate,
      createdAt: createdDate,
    );

    test('SavingsGoalModel can be created', () {
      expect(testGoal.id, 'goal-001');
      expect(testGoal.userId, 'user-123');
      expect(testGoal.name, 'Emergency Fund');
      expect(testGoal.targetAmountInKobo, 5000000);
      expect(testGoal.currentAmountInKobo, 1250000);
      expect(testGoal.targetDate, testDate);
      expect(testGoal.createdAt, createdDate);
    });

    test('formattedTargetNaira formats correctly', () {
      expect(testGoal.formattedTargetNaira, '₦50,000.00');
    });

    test('formattedCurrentNaira formats correctly', () {
      expect(testGoal.formattedCurrentNaira, '₦12,500.00');
    });

    test('progressRatio calculates correctly', () {
      expect(testGoal.progressRatio, 0.25); // 1250000 / 5000000 = 0.25
    });

    test('progressRatio clamps to 1.0 when current exceeds target', () {
      final overachievedGoal = testGoal.copyWith(
        currentAmountInKobo: 6000000,
      );
      expect(overachievedGoal.progressRatio, 1.0);
    });

    test('progressRatio returns 0.0 for invalid target', () {
      final invalidGoal = testGoal.copyWith(targetAmountInKobo: 0);
      expect(invalidGoal.progressRatio, 0.0);
    });

    test('progressPercentage formats correctly', () {
      expect(testGoal.progressPercentage, '25%');
    });

    test('progressPercentage returns 100% when achieved', () {
      final achievedGoal = testGoal.copyWith(
        currentAmountInKobo: 5000000,
      );
      expect(achievedGoal.progressPercentage, '100%');
    });

    test('toJson serializes correctly', () {
      final json = testGoal.toJson();
      expect(json['id'], 'goal-001');
      expect(json['userId'], 'user-123');
      expect(json['name'], 'Emergency Fund');
      expect(json['targetAmountInKobo'], 5000000);
      expect(json['currentAmountInKobo'], 1250000);
      expect(json['targetDate'], testDate.toIso8601String());
      expect(json['createdAt'], createdDate.toIso8601String());
    });

    test('fromJson deserializes correctly', () {
      final json = testGoal.toJson();
      final deserialized = SavingsGoalModel.fromJson(json);
      expect(deserialized.id, testGoal.id);
      expect(deserialized.userId, testGoal.userId);
      expect(deserialized.name, testGoal.name);
      expect(deserialized.targetAmountInKobo, testGoal.targetAmountInKobo);
      expect(deserialized.currentAmountInKobo, testGoal.currentAmountInKobo);
      expect(deserialized.targetDate, testGoal.targetDate);
      expect(deserialized.createdAt, testGoal.createdAt);
    });

    test('toMap preserves DateTime objects', () {
      final map = testGoal.toMap();
      expect(map['id'], 'goal-001');
      expect(map['targetDate'] is DateTime, true);
      expect(map['createdAt'] is DateTime, true);
    });

    test('fromMap handles DateTime objects', () {
      final map = testGoal.toMap();
      final fromMap = SavingsGoalModel.fromMap(map);
      expect(fromMap.id, testGoal.id);
      expect(fromMap.targetDate, testGoal.targetDate);
      expect(fromMap.createdAt, testGoal.createdAt);
    });

    test('fromMap handles DateTime strings', () {
      final map = {
        'id': 'goal-001',
        'userId': 'user-123',
        'name': 'Emergency Fund',
        'targetAmountInKobo': 5000000,
        'currentAmountInKobo': 1250000,
        'targetDate': testDate.toIso8601String(),
        'createdAt': createdDate.toIso8601String(),
      };
      final fromMap = SavingsGoalModel.fromMap(map);
      expect(fromMap.id, 'goal-001');
      expect(fromMap.targetDate, testDate);
      expect(fromMap.createdAt, createdDate);
    });

    test('copyWith creates new instance with updated fields', () {
      final updated = testGoal.copyWith(
        name: 'Vacation Fund',
        currentAmountInKobo: 2500000,
      );
      expect(updated.name, 'Vacation Fund');
      expect(updated.currentAmountInKobo, 2500000);
      expect(updated.id, testGoal.id); // Unchanged
      expect(updated.userId, testGoal.userId); // Unchanged
    });

    test('copyWith returns same instance when no updates', () {
      final copy = testGoal.copyWith();
      expect(copy.id, testGoal.id);
      expect(copy.userId, testGoal.userId);
      expect(copy.name, testGoal.name);
    });

    test('handles large Kobo amounts (64-bit)', () {
      final largeGoal = SavingsGoalModel(
        id: 'goal-large',
        userId: 'user-123',
        name: 'Retirement Fund',
        targetAmountInKobo: 9223372036854775807, // Max int64
        currentAmountInKobo: 4611686018427387903,
        targetDate: testDate,
        createdAt: createdDate,
      );
      expect(largeGoal.progressRatio, closeTo(0.5, 0.0001));
    });
  });
}
