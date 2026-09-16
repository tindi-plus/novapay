// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_queue_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for OfflineQueueService using code generation.

@ProviderFor(offlineQueueService)
final offlineQueueServiceProvider = OfflineQueueServiceProvider._();

/// Riverpod provider for OfflineQueueService using code generation.

final class OfflineQueueServiceProvider
    extends
        $FunctionalProvider<
          OfflineQueueService,
          OfflineQueueService,
          OfflineQueueService
        >
    with $Provider<OfflineQueueService> {
  /// Riverpod provider for OfflineQueueService using code generation.
  OfflineQueueServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineQueueServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineQueueServiceHash();

  @$internal
  @override
  $ProviderElement<OfflineQueueService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OfflineQueueService create(Ref ref) {
    return offlineQueueService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineQueueService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineQueueService>(value),
    );
  }
}

String _$offlineQueueServiceHash() =>
    r'ac82944bb23d87a77edeba2ab1ae12a944dcbd34';
