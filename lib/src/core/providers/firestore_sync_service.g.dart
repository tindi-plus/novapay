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
///
/// IMPORTANT: All ref.watch() calls are done at this provider level (not inside the service),
/// so that Riverpod correctly tracks dependencies and caches the database instance.
/// This prevents multiple AppDatabase instances from being created.

@ProviderFor(firestoreSyncService)
final firestoreSyncServiceProvider = FirestoreSyncServiceProvider._();

/// Provider for FirestoreSyncService.
/// This provider manages the lifecycle of Firestore listeners.
/// When the provider is disposed, all listeners are automatically cancelled.
///
/// IMPORTANT: All ref.watch() calls are done at this provider level (not inside the service),
/// so that Riverpod correctly tracks dependencies and caches the database instance.
/// This prevents multiple AppDatabase instances from being created.

final class FirestoreSyncServiceProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for FirestoreSyncService.
  /// This provider manages the lifecycle of Firestore listeners.
  /// When the provider is disposed, all listeners are automatically cancelled.
  ///
  /// IMPORTANT: All ref.watch() calls are done at this provider level (not inside the service),
  /// so that Riverpod correctly tracks dependencies and caches the database instance.
  /// This prevents multiple AppDatabase instances from being created.
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
    r'd801fcfa5866ed5eebcbbb61d7a48d70b68aecad';
