// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nova_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NovaUser _$NovaUserFromJson(Map<String, dynamic> json) => _NovaUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  accountNumber: json['accountNumber'] as String,
  firstName: json['firstName'] as String,
  middleName: json['middleName'] as String?,
  lastName: json['lastName'] as String,
  bvn: json['bvn'] as String,
  nin: json['nin'] as String,
  phoneNumber: json['phoneNumber'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
);

Map<String, dynamic> _$NovaUserToJson(_NovaUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'accountNumber': instance.accountNumber,
  'firstName': instance.firstName,
  'middleName': instance.middleName,
  'lastName': instance.lastName,
  'bvn': instance.bvn,
  'nin': instance.nin,
  'phoneNumber': instance.phoneNumber,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'isEmailVerified': instance.isEmailVerified,
};
