import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../security/biometric_service.dart';

part 'biometric_provider.g.dart';

/// Provides singleton instance of [BiometricService]
@riverpod
BiometricService biometricService(Ref ref) {
  return BiometricService();
}

/// Checks if the device supports biometric authentication.
///
/// Returns [true] if:
/// - Device has biometric hardware (fingerprint sensor, Face ID, etc.)
/// - At least one biometric is enrolled on the device
/// - Device supports system PIN/passkey as fallback
///
/// Returns [false] otherwise or if an error occurs.
@riverpod
Future<bool> isBiometricsAvailable(Ref ref) async {
  final service = ref.watch(biometricServiceProvider);
  return service.checkBiometricsAvailable();
}
