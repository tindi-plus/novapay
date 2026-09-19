// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsGoalModel _$SavingsGoalModelFromJson(Map<String, dynamic> json) =>
    _SavingsGoalModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      targetAmountInKobo: (json['targetAmountInKobo'] as num).toInt(),
      currentAmountInKobo: (json['currentAmountInKobo'] as num).toInt(),
      targetDate: DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SavingsGoalModelToJson(_SavingsGoalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'targetAmountInKobo': instance.targetAmountInKobo,
      'currentAmountInKobo': instance.currentAmountInKobo,
      'targetDate': instance.targetDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
