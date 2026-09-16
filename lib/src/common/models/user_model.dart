import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    required String accountNumber,
    required String bvn,
    required String nin,
    required int walletBalanceInKobo,
    required int kycTier,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map);
    final createdAt = data['createdAt'];
    final updatedAt = data['updatedAt'];

    return UserModel.fromJson({
      ...data,
      if (createdAt is Timestamp)
        'createdAt': createdAt.toDate().toIso8601String(),
      if (updatedAt is Timestamp)
        'updatedAt': updatedAt.toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toMap() {
    final jsonMap = toJson();
    return {
      ...jsonMap,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  String get fullName => '$firstName $lastName';

  String get formattedBalance {
    final naira = walletBalanceInKobo / 100.0;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  @override
  String toString() =>
      'UserModel(id: $id, fullName: $fullName, email: $email, balance: $formattedBalance, kycTier: $kycTier)';
}
