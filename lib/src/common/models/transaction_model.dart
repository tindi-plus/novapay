import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Transaction type enum for type-safe handling.
enum TransactionType {
  debit,
  credit,
  savingsContribution;

  String get value => name;

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (t) => t.value == value,
      orElse: () => TransactionType.debit,
    );
  }

  String get displayName {
    switch (this) {
      case TransactionType.debit:
        return 'Sent';
      case TransactionType.credit:
        return 'Received';
      case TransactionType.savingsContribution:
        return 'Saved';
    }
  }
}

/// Transaction status enum for type-safe handling.
enum TransactionStatusType {
  completed,
  pending,
  failed;

  String get value => name;

  static TransactionStatusType fromString(String value) {
    return TransactionStatusType.values.firstWhere(
      (s) => s.value == value,
      orElse: () => TransactionStatusType.failed,
    );
  }

  String get displayName {
    switch (this) {
      case TransactionStatusType.completed:
        return 'Completed';
      case TransactionStatusType.pending:
        return 'Pending';
      case TransactionStatusType.failed:
        return 'Failed';
    }
  }
}

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required int amountInKobo,
    required String type, // 'debit', 'credit', 'savings_contribution'
    required String title,
    required String status, // 'completed', 'pending', 'failed'
    required DateTime createdAt,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Factory to create from Firestore document.
  /// Maps Firestore Timestamp to DateTime and handles nested objects.
  factory TransactionModel.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAt = data['createdAt'];

    return TransactionModel.fromJson({
      ...data,
      'id': doc.id,
      if (createdAt is Timestamp)
        'createdAt': createdAt.toDate().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountInKobo': amountInKobo,
      'type': type,
      'title': title,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'amountInKobo': amountInKobo,
      'type': type,
      'title': title,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Converts amountInKobo to formatted Naira string.
  /// E.g., 20000 -> "₦200.00"
  String get formattedAmount {
    final naira = amountInKobo / 100.0;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  /// Returns formatted amount with sign and color.
  /// Debits: "-₦200.00" (red)
  /// Credits: "+₦200.00" (green)
  String get formattedAmountWithSign {
    final typeEnum = TransactionType.fromString(type);
    final sign = typeEnum == TransactionType.debit ? '-' : '+';
    return '$sign$formattedAmount';
  }

  /// Returns the color for this transaction based on type.
  Color get displayColor {
    final typeEnum = TransactionType.fromString(type);
    switch (typeEnum) {
      case TransactionType.debit:
        return const Color(0xFFEF5350); // Material red
      case TransactionType.credit:
      case TransactionType.savingsContribution:
        return const Color(0xFF66BB6A); // Material green
    }
  }

  /// Returns the transaction type enum.
  TransactionType get typeEnum => TransactionType.fromString(type);

  /// Returns the transaction status enum.
  TransactionStatusType get statusEnum =>
      TransactionStatusType.fromString(status);

  /// Formatted display date (e.g., "Sep 17, 2024" or "2:30 PM today").
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (txDate == today) {
      return DateFormat('h:mm a').format(createdAt);
    } else if (txDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (now.difference(createdAt).inDays < 7) {
      return DateFormat('EEEE').format(createdAt); // e.g., "Monday"
    } else {
      return DateFormat('MMM d, y').format(createdAt); // e.g., "Sep 17, 2024"
    }
  }

  /// Screen reader label for accessibility.
  /// E.g., "Payment to John, Debited ₦200.00, Status: Completed"
  String get accessibilityLabel {
    final action =
        typeEnum == TransactionType.debit ? 'Debited' : 'Credited';
    return '$title, $action $formattedAmount, Status: ${statusEnum.displayName}';
  }
}
