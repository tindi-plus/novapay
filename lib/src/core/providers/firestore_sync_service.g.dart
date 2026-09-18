// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for FirestoreSyncService.
/// This provider manages the lifecycle of Firestore listeners.
/// When the provider is disposed, all listeners are automatically cancelled.

@ProviderFor(firestoreSyncService)
final firestoreSyncServiceProvider = FirestoreSyncServiceProvider._();

/// Provider for FirestoreSyncService.
/// This provider manages the lifecycle of Firestore listeners.
/// When the provider is disposed, all listeners are automatically cancelled.

final class FirestoreSyncServiceProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for FirestoreSyncService.
  /// This provider manages the lifecycle of Firestore listeners.
  /// When the provider is disposed, all listeners are automatically cancelled.
  FirestoreSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreSyncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreSyncServiceHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return firestoreSyncService(ref);
  }
}

String _$firestoreSyncServiceHash() =>
    r'9e5586da9c8ef1af5a92f3c0fcd4db88df5a4a68';
