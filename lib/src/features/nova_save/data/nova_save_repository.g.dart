// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nova_save_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for NovaSaveRepository.

@ProviderFor(novaSaveRepository)
final novaSaveRepositoryProvider = NovaSaveRepositoryProvider._();

/// Riverpod provider for NovaSaveRepository.

final class NovaSaveRepositoryProvider
    extends
        $FunctionalProvider<
          NovaSaveRepository,
          NovaSaveRepository,
          NovaSaveRepository
        >
    with $Provider<NovaSaveRepository> {
  /// Riverpod provider for NovaSaveRepository.
  NovaSaveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'novaSaveRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$novaSaveRepositoryHash();

  @$internal
  @override
  $ProviderElement<NovaSaveRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NovaSaveRepository create(Ref ref) {
    return novaSaveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NovaSaveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NovaSaveRepository>(value),
    );
  }
}

String _$novaSaveRepositoryHash() =>
    r'c304496a65e7bab40bc7094ac767a9df30227155';
