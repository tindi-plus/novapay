// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      amountInKobo: (json['amountInKobo'] as num).toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amountInKobo': instance.amountInKobo,
      'type': instance.type,
      'title': instance.title,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
