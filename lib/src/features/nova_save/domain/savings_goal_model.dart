import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'savings_goal_model.freezed.dart';
part 'savings_goal_model.g.dart';

@freezed
abstract class SavingsGoalModel with _$SavingsGoalModel {
  const factory SavingsGoalModel({
    required String id,
    required String userId,
    required String name,
    required int targetAmountInKobo,
    required int currentAmountInKobo,
    required DateTime targetDate,
    required DateTime createdAt,
  }) = _SavingsGoalModel;

  const SavingsGoalModel._();

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalModelFromJson(json);

  /// Factory to create from a Map (useful for Firestore or local database).
  /// Handles DateTime conversion from String (ISO 8601) or DateTime objects.
  factory SavingsGoalModel.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map);

    return SavingsGoalModel.fromJson({
      ...data,
      if (data['targetDate'] is String)
        'targetDate': data['targetDate']
      else if (data['targetDate'] is DateTime)
        'targetDate': (data['targetDate'] as DateTime).toIso8601String(),
      if (data['createdAt'] is String)
        'createdAt': data['createdAt']
      else if (data['createdAt'] is DateTime)
        'createdAt': (data['createdAt'] as DateTime).toIso8601String(),
    });
  }

  /// Converts the model to a JSON-serializable Map (ISO 8601 datetime strings).
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'targetAmountInKobo': targetAmountInKobo,
      'currentAmountInKobo': currentAmountInKobo,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Converts the model to a Map suitable for local database storage.
  /// DateTime objects are preserved as DateTime for Drift.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'targetAmountInKobo': targetAmountInKobo,
      'currentAmountInKobo': currentAmountInKobo,
      'targetDate': targetDate,
      'createdAt': createdAt,
    };
  }

  /// Converts targetAmountInKobo to formatted Naira string.
  /// E.g., 5000000 -> "₦50,000.00"
  String get formattedTargetNaira {
    final naira = targetAmountInKobo / 100.0;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  /// Converts currentAmountInKobo to formatted Naira string.
  /// E.g., 1250000 -> "₦12,500.00"
  String get formattedCurrentNaira {
    final naira = currentAmountInKobo / 100.0;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  /// Returns the progress ratio as a double between 0.0 and 1.0.
  /// E.g., if currentAmountInKobo = 2500000 and targetAmountInKobo = 5000000,
  /// progressRatio = 0.5 (50% progress)
  double get progressRatio {
    if (targetAmountInKobo <= 0) return 0.0;
    return (currentAmountInKobo / targetAmountInKobo).clamp(0.0, 1.0);
  }

  /// Returns the progress as a formatted percentage string.
  /// E.g., progressRatio = 0.25 -> "25%"
  String get progressPercentage {
    final percentage = (progressRatio * 100).toInt();
    return '$percentage%';
  }
}
