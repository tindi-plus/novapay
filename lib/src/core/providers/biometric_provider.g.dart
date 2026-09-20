// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides singleton instance of [BiometricService]

@ProviderFor(biometricService)
final biometricServiceProvider = BiometricServiceProvider._();

/// Provides singleton instance of [BiometricService]

final class BiometricServiceProvider
    extends
        $FunctionalProvider<
          BiometricService,
          BiometricService,
          BiometricService
        >
    with $Provider<BiometricService> {
  /// Provides singleton instance of [BiometricService]
  BiometricServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricServiceHash();

  @$internal
  @override
  $ProviderElement<BiometricService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiometricService create(Ref ref) {
    return biometricService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricService>(value),
    );
  }
}

String _$biometricServiceHash() => r'd13b3194e57bb984c452857712b3300be3bc3346';

/// Checks if the device supports biometric authentication.
///
/// Returns [true] if:
/// - Device has biometric hardware (fingerprint sensor, Face ID, etc.)
/// - At least one biometric is enrolled on the device
/// - Device supports system PIN/passkey as fallback
///
/// Returns [false] otherwise or if an error occurs.

@ProviderFor(isBiometricsAvailable)
final isBiometricsAvailableProvider = IsBiometricsAvailableProvider._();

/// Checks if the device supports biometric authentication.
///
/// Returns [true] if:
/// - Device has biometric hardware (fingerprint sensor, Face ID, etc.)
/// - At least one biometric is enrolled on the device
/// - Device supports system PIN/passkey as fallback
///
/// Returns [false] otherwise or if an error occurs.

final class IsBiometricsAvailableProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Checks if the device supports biometric authentication.
  ///
  /// Returns [true] if:
  /// - Device has biometric hardware (fingerprint sensor, Face ID, etc.)
  /// - At least one biometric is enrolled on the device
  /// - Device supports system PIN/passkey as fallback
  ///
  /// Returns [false] otherwise or if an error occurs.
  IsBiometricsAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isBiometricsAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isBiometricsAvailableHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isBiometricsAvailable(ref);
  }
}

String _$isBiometricsAvailableHash() =>
    r'a2a82615656a7543821892de9dbb6c9d2c2fde9b';
