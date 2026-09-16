// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  accountNumber: json['accountNumber'] as String,
  bvn: json['bvn'] as String,
  nin: json['nin'] as String,
  walletBalanceInKobo: (json['walletBalanceInKobo'] as num).toInt(),
  kycTier: (json['kycTier'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'accountNumber': instance.accountNumber,
      'bvn': instance.bvn,
      'nin': instance.nin,
      'walletBalanceInKobo': instance.walletBalanceInKobo,
      'kycTier': instance.kycTier,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
