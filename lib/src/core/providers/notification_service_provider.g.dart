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
///
/// This provider ensures that:
/// 1. The notification service is initialized exactly once
/// 2. Permissions are requested immediately upon initialization
/// 3. The service remains available for the entire app lifecycle
/// 4. Any initialization errors are logged but don't crash the app

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

/// Riverpod provider for NotificationService using code generation.
///
/// Initializes the service on first access and keeps it alive throughout
/// the app lifecycle (keepAlive: true).
///
/// This provider ensures that:
/// 1. The notification service is initialized exactly once
/// 2. Permissions are requested immediately upon initialization
/// 3. The service remains available for the entire app lifecycle
/// 4. Any initialization errors are logged but don't crash the app

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
  ///
  /// This provider ensures that:
  /// 1. The notification service is initialized exactly once
  /// 2. Permissions are requested immediately upon initialization
  /// 3. The service remains available for the entire app lifecycle
  /// 4. Any initialization errors are logged but don't crash the app
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
    r'112af5d051e5dc059ad0832a44c3abbfeb0181de';
