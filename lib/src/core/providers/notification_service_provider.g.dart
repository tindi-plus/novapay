// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for NotificationService using code generation.
///
/// Initializes the service on first access and keeps it alive throughout
/// the app lifecycle (keepAlive: true).

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

/// Riverpod provider for NotificationService using code generation.
///
/// Initializes the service on first access and keeps it alive throughout
/// the app lifecycle (keepAlive: true).

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationService>,
          NotificationService,
          FutureOr<NotificationService>
        >
    with
        $FutureModifier<NotificationService>,
        $FutureProvider<NotificationService> {
  /// Riverpod provider for NotificationService using code generation.
  ///
  /// Initializes the service on first access and keeps it alive throughout
  /// the app lifecycle (keepAlive: true).
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationService> create(Ref ref) {
    return notificationService(ref);
  }
}

String _$notificationServiceHash() =>
    r'61d1172d23639206f3f76863e46ca6eec194e0b0';
