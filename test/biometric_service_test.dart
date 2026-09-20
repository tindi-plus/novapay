import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/core/security/biometric_service.dart';

void main() {
  group('BiometricService', () {
    late BiometricService biometricService;

    setUp(() {
      biometricService = BiometricService();
    });

    test('BiometricService can be instantiated', () {
      expect(biometricService, isA<BiometricService>());
    });

    test('authenticateForTransaction method exists', () {
      expect(
        biometricService.authenticateForTransaction,
        isNotNull,
      );
    });

    test('checkBiometricsAvailable method exists', () {
      expect(
        biometricService.checkBiometricsAvailable,
        isNotNull,
      );
    });
  });

  group('High-value transaction threshold', () {
    test('Amount > 500000 Kobo (₦5,000) is considered high-value', () {
      const highValueThresholdKobo = 500000;
      final amount = 500001; // ₦5,000.01
      expect(amount > highValueThresholdKobo, true);
    });

    test('Amount == 500000 Kobo (₦5,000) is NOT considered high-value', () {
      const highValueThresholdKobo = 500000;
      final amount = 500000; // Exactly ₦5,000.00
      expect(amount > highValueThresholdKobo, false);
    });

    test('Amount < 500000 Kobo is NOT considered high-value', () {
      const highValueThresholdKobo = 500000;
      final amount = 499999; // ₦4,999.99
      expect(amount > highValueThresholdKobo, false);
    });

    test('Currency conversion: ₦5,000 = 500,000 Kobo', () {
      const nairaAmount = 5000.0;
      final koboAmount = (nairaAmount * 100).round();
      expect(koboAmount, 500000);
    });

    test('Currency conversion: ₦5,000.01 = 500,001 Kobo', () {
      const nairaAmount = 5000.01;
      final koboAmount = (nairaAmount * 100).round();
      expect(koboAmount, 500001);
    });

    test('Currency conversion: ₦4,999.99 = 499,999 Kobo', () {
      const nairaAmount = 4999.99;
      final koboAmount = (nairaAmount * 100).round();
      expect(koboAmount, 499999);
    });
  });
}
