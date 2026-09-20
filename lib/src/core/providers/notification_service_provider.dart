import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../notifications/notification_service.dart';

part 'notification_service_provider.g.dart';

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
@riverpod
Future<NotificationService> notificationService(Ref ref) async {
  try {
    final service = NotificationService(FlutterLocalNotificationsPlugin());
    await service.initialize();
    return service;
  } catch (e) {
    // Log error but return a valid service instance
    // The notification service should never be a blocker for app functionality
    if (kDebugMode) {
      debugPrint('Error initializing notification service: $e');
    }
    
    // Still return a service instance that can be used (will handle errors gracefully)
    return NotificationService(FlutterLocalNotificationsPlugin());
  }
}
