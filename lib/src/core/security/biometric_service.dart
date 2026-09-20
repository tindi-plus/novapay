import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Service for handling biometric authentication (fingerprint/Face ID)
///
/// Provides unified platform APIs for biometric verification with
/// automatic fallback to system PIN/passkey when biometric authentication
/// fails or is cancelled.
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Check if the device supports biometric authentication and has
  /// at least one biometric enrolled.
  ///
  /// Returns [true] if biometrics are available and enrolled,
  /// [false] otherwise or if an error occurs.
  Future<bool> checkBiometricsAvailable() async {
    try {
      // Check if device supports biometric hardware
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        if (kDebugMode) {
          print('[BiometricService] Device does not support biometrics');
        }
        return false;
      }

      // Check for enrolled biometrics
      final availableBiometrics = await _auth.getAvailableBiometrics();
      final isAvailable = availableBiometrics.isNotEmpty;

      if (kDebugMode) {
        print(
          '[BiometricService] Biometrics available: $isAvailable, '
          'types: $availableBiometrics',
        );
      }

      return isAvailable;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[BiometricService] Error checking biometrics availability: $e');
      }
      return false;
    }
  }

  /// Authenticate the user for a transaction using biometric or system authentication.
  ///
  /// Shows the native authentication dialog with the provided [localizedReason].
  /// If biometric authentication fails or is cancelled, automatically falls back
  /// to system PIN/passkey verification (via [biometricOnly] = false).
  ///
  /// Parameters:
  ///   - [localizedReason]: A user-facing explanation for why authentication is needed.
  ///     Example: "Please verify your fingerprint to approve transfer of ₦5,000.00"
  ///
  /// Returns [true] if authentication succeeds, [false] if cancelled or failed.
  ///
  /// Throws [PlatformException] if an error occurs during authentication.
  Future<bool> authenticateForTransaction({
    required String localizedReason,
  }) async {
    try {
      if (kDebugMode) {
        print('[BiometricService] Starting biometric authentication...');
        print('[BiometricService] Reason: $localizedReason');
      }

      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          // Allow biometric OR system PIN/passkey as fallback
          biometricOnly: false,
          // Persist authenticated state for security checks
          sensitiveTransaction: true,
          // Don't use stickyAuth on most platforms for security
          stickyAuth: false,
        ),
      );

      if (kDebugMode) {
        print('[BiometricService] Authentication result: $authenticated');
      }

      return authenticated;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[BiometricService] Authentication error: $e');
      }
      // Return false for authentication failure/cancellation
      // The UI layer will handle user feedback
      return false;
    }
  }
}
