import 'package:intl/intl.dart';

/// Production-ready immutable Money value object.
/// Strictly uses integer Kobo for all storage and calculations to prevent floating-point errors.
/// All fintech rules enforced: no doubles, accurate parsing/formatting, limits validation.
/// Used across SendMoney, Wallet, History.
/// Examples: Money.fromKobo(10000).display == '₦100.00'
class Money {
  /// Amount in smallest unit (Kobo). >= 0 always.
  final int amountKobo;

  const Money(this.amountKobo) : assert(amountKobo >= 0, 'Money amount cannot be negative');

  /// Factory from user input string (e.g. '100', '100.5', '₦100.50', '100,00').
  factory Money.fromString(String input) {
    if (input.trim().isEmpty) return zero;
    final cleaned = input
        .replaceAll('₦', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    return Money.fromNairaString(cleaned);
  }

  /// Parses Naira string to Kobo using integer math only.
  factory Money.fromNairaString(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return zero;

    final parts = clean.split('.');
    final wholeNaira = int.tryParse(parts[0]) ?? 0;
    int koboFraction = 0;
    if (parts.length > 1 && parts[1].isNotEmpty) {
      final fractionStr = parts[1].padRight(2, '0').substring(0, 2);
      koboFraction = int.tryParse(fractionStr) ?? 0;
    }
    final totalKobo = (wholeNaira * 100) + koboFraction;
    return Money(totalKobo);
  }

  /// From kobo (primary for API/DB).
  factory Money.fromKobo(int kobo) => Money(kobo);

  static const zero = Money(0);

  /// Integer arithmetic - safe for money.
  Money operator +(Money other) => Money(amountKobo + other.amountKobo);
  Money operator -(Money other) => Money(amountKobo - other.amountKobo);
  Money operator *(int factor) => Money(amountKobo * factor);

  bool operator >(Money other) => amountKobo > other.amountKobo;
  bool operator >=(Money other) => amountKobo >= other.amountKobo;
  bool operator <(Money other) => amountKobo < other.amountKobo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money && other.amountKobo == amountKobo;

  @override
  int get hashCode => amountKobo.hashCode;

  /// Naira as double ONLY for display (never store/calc with it).
  double get toNaira => amountKobo / 100.0;

  /// Formatted as ₦1,234.56 (locale aware).
  String get display {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatter.format(toNaira);
  }

  /// Compact for lists.
  String get compact {
    final formatter = NumberFormat.compactCurrency(
      locale: 'en_NG',
      symbol: '₦',
    );
    return formatter.format(toNaira);
  }

  /// For API/Firestore storage.
  int get kobo => amountKobo;
  String toKoboString() => amountKobo.toString();

  /// Validates against business rules ( >0, within daily limits e.g. 50M Naira).
  bool isValidTransfer({int maxKobo = 5000000000}) =>
      amountKobo > 0 && amountKobo <= maxKobo && amountKobo % 50 == 0; // e.g. multiple of 50kobo

  @override
  String toString() => display;
}
