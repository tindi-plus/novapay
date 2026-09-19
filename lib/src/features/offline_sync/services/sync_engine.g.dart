// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_engine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Strongly typed sync notification notifier for non-blocking UI toasts/banners.
/// Listened to by UI layers (e.g. in SyncNotificationOverlay) to show messages.

@ProviderFor(SyncNotification)
final syncNotificationProvider = SyncNotificationProvider._();

/// Strongly typed sync notification notifier for non-blocking UI toasts/banners.
/// Listened to by UI layers (e.g. in SyncNotificationOverlay) to show messages.
final class SyncNotificationProvider
    extends $NotifierProvider<SyncNotification, String?> {
  /// Strongly typed sync notification notifier for non-blocking UI toasts/banners.
  /// Listened to by UI layers (e.g. in SyncNotificationOverlay) to show messages.
  SyncNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncNotificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncNotificationHash();

  @$internal
  @override
  SyncNotification create() => SyncNotification();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$syncNotificationHash() => r'53149cd7ff61c54e1d903aab960cd2bd0afcc345';

/// Strongly typed sync notification notifier for non-blocking UI toasts/banners.
/// Listened to by UI layers (e.g. in SyncNotificationOverlay) to show messages.

abstract class _$SyncNotification extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Riverpod provider for the SyncEngine using code generation (keepAlive: true).
/// Initializes connectivity monitoring on app boot and safely guards against
/// concurrent re-entrant sync invocations if network state flickers.

@ProviderFor(syncEngine)
final syncEngineProvider = SyncEngineProvider._();

/// Riverpod provider for the SyncEngine using code generation (keepAlive: true).
/// Initializes connectivity monitoring on app boot and safely guards against
/// concurrent re-entrant sync invocations if network state flickers.

final class SyncEngineProvider
    extends $FunctionalProvider<SyncEngine, SyncEngine, SyncEngine>
    with $Provider<SyncEngine> {
  /// Riverpod provider for the SyncEngine using code generation (keepAlive: true).
  /// Initializes connectivity monitoring on app boot and safely guards against
  /// concurrent re-entrant sync invocations if network state flickers.
  SyncEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncEngineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncEngineHash();

  @$internal
  @override
  $ProviderElement<SyncEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncEngine create(Ref ref) {
    return syncEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncEngine>(value),
    );
  }
}

String _$syncEngineHash() => r'0f7562dc3498758521a7abb1bb7c06c39c829d46';
