// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// /// Production-grade local notification service for NovaPay.
// ///
// /// Manages platform-specific (Android/iOS) local notifications and runtime
// /// permission requests. Centralizes all notification logic for offline sync
// /// completion events.
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

//   NotificationService(this._flutterLocalNotificationsPlugin);

//   /// Initialize the notification service with platform-specific settings.
//   ///
//   /// Must be called once at app startup (typically in main() or app initialization).
//   /// Requests runtime permissions on iOS and Android 13+.
//   ///
//   /// This method:
//   /// 1. Sets up platform-specific notification channels
//   /// 2. Explicitly requests notification permissions from the user
//   /// 3. Handles permission requests gracefully even if denied
//   /// 4. Logs all initialization steps for debugging
//   Future<void> initialize() async {
//     try {
//       if (kDebugMode) {
//         debugPrint('NotificationService: Starting initialization...');
//       }

//       // Android initialization settings
//       const AndroidInitializationSettings androidSettings =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       // iOS initialization settings
//       final DarwinInitializationSettings iosSettings =
//           DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
//       );

//       // Combine initialization settings for both platforms
//       final InitializationSettings initSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       // Initialize the plugin
//       if (kDebugMode) {
//         debugPrint('NotificationService: Initializing Flutter Local Notifications plugin...');
//       }
//       await _flutterLocalNotificationsPlugin.initialize(settings: initSettings);

//       if (kDebugMode) {
//         debugPrint('NotificationService: Plugin initialized successfully');
//       }

//       // Request notification permissions (iOS 10+, Android 13+)
//       // This is critical and must complete before notifications can be shown
//       if (kDebugMode) {
//         debugPrint('NotificationService: Requesting notification permissions...');
//       }
//       await _requestNotificationPermissions();

//       if (kDebugMode) {
//         debugPrint('NotificationService: Initialization completed successfully');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('Error initializing notification service: $e');
//       }
//       rethrow; // Re-throw to allow provider to handle gracefully
//     }
//   }

//   /// Request runtime notification permissions from the user.
//   ///
//   /// On Android 13+, this will prompt for POST_NOTIFICATIONS permission.
//   /// On iOS 10+, permissions are requested for alert, badge, and sound.
//   ///
//   /// This method handles both platforms gracefully and doesn't block
//   /// the app if permission requests fail.
//   // Future<void> _requestNotificationPermissions() async {
//   //   try {
//   //     if (kDebugMode) {
//   //       debugPrint('NotificationService: Requesting iOS notification permissions...');
//   //     }

//   //     // Request iOS notification permissions
//   //     final iosPlugin = _flutterLocalNotificationsPlugin
//   //         .resolvePlatformSpecificImplementation<
//   //             IOSFlutterLocalNotificationsPlugin>();

//   //     if (iosPlugin != null) {
//   //       await iosPlugin.requestPermissions(
//   //         alert: true,
//   //         badge: true,
//   //         sound: true,
//   //       );

//   //       if (kDebugMode) {
//   //         debugPrint('iOS notification permissions requested successfully');
//   //       }
//   //     } else if (kDebugMode) {
//   //       debugPrint('NotificationService: iOS plugin not available');
//   //     }

//   //     if (kDebugMode) {
//   //       debugPrint(
//   //           'NotificationService: Requesting Android notification permissions...');
//   //     }

//   //     // Request Android notification permissions (Android 13+)
//   //     final androidPlugin = _flutterLocalNotificationsPlugin
//   //         .resolvePlatformSpecificImplementation<
//   //             AndroidFlutterLocalNotificationsPlugin>();

//   //     if (androidPlugin != null) {
//   //       final androidPermissionResult =
//   //           await androidPlugin.requestNotificationsPermission();

//   //       if (kDebugMode) {
//   //         debugPrint(
//   //             'Android notification permission granted: $androidPermissionResult');
//   //       }
//   //     } else if (kDebugMode) {
//   //       debugPrint('NotificationService: Android plugin not available');
//   //     }

//   //     if (kDebugMode) {
//   //       debugPrint('NotificationService: Notification permissions request completed');
//   //     }
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       debugPrint('Error requesting notification permissions: $e');
//   //     }
//   //     // Continue gracefully if permission request fails - the app should still work
//   //     // even if notifications are disabled
//   //   }
//   // }

// Future<void> _requestNotificationPermissions() async {
//   try {
//     // Universal Darwin implementation (iOS & macOS)
//     final darwinPlugin = _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             DarwinFlutterLocalNotificationsPlugin>();

//     if (darwinPlugin != null) {
//       await darwinPlugin.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }

//     // Android implementation
//     final androidPlugin = _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     if (androidPlugin != null) {
//       await androidPlugin.requestNotificationsPermission();
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       debugPrint('Error requesting notification permissions: $e');
//     }
//   }
// }
//   /// Callback for iOS notifications received while app is in foreground.
//   ///
//   /// This ensures notifications are visible to the user even when the app
//   /// is actively being used.
//   Future<void> _onDidReceiveLocalNotification(
//     int id,
//     String? title,
//     String? body,
//     String? payload,
//   ) async {
//     if (kDebugMode) {
//       debugPrint(
//           'iOS local notification received: id=$id, title=$title, body=$body');
//     }
//   }

//   /// Display a local notification for successful sync completion.
//   ///
//   /// Shows a notification with sound and vibration (platform dependent).
//   /// Used exclusively for notifying users when offline-queued transactions have
//   /// successfully synced to the backend.
//   ///
//   /// Parameters:
//   /// - [title]: The notification title (e.g., "Transfer Completed")
//   /// - [body]: The notification body with transaction details
//   Future<void> showSyncSuccessNotification({
//     required String title,
//     required String body,
//   }) async {
//     try {
//       // Android-specific notification details with sound and vibration
//       const AndroidNotificationDetails androidNotificationDetails =
//           AndroidNotificationDetails(
//         'offline_sync_channel',
//         'Offline Sync Notifications',
//         channelDescription:
//             'Notifications for offline queued transactions that have successfully synced',
//         importance: Importance.high,
//         priority: Priority.high,
//         enableVibration: true,
//         playSound: true,
//       );

//       // iOS-specific notification details
//       const DarwinNotificationDetails iosNotificationDetails =
//           DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );

//       // Combine platform-specific details
//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails,
//         iOS: iosNotificationDetails,
//       );

//       // Display the notification with a unique ID (timestamp)
//       await _flutterLocalNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         title,
//         body,
//         notificationDetails,
//       );

//       if (kDebugMode) {
//         debugPrint(
//             'Sync success notification displayed: title=$title, body=$body');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('Error displaying sync success notification: $e');
//       }
//       // Continue gracefully - notification failure should not crash the app
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Production-grade local notification service for NovaPay.
///
/// Manages platform-specific (Android/iOS) local notifications and runtime
/// permission requests. Centralizes all notification logic for offline sync
/// completion events.
class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService(this._flutterLocalNotificationsPlugin);

  /// Initialize the notification service.
  ///
  /// Must be called once at app startup.
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        debugPrint('NotificationService: Starting initialization...');
      }

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS/macOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      // Combined initialization settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      if (kDebugMode) {
        debugPrint(
          'NotificationService: Initializing Flutter Local Notifications plugin...',
        );
      }

      await _flutterLocalNotificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      if (kDebugMode) {
        debugPrint('NotificationService: Plugin initialized successfully');
      }

      // Request notification permissions after initialization
      await _requestNotificationPermissions();

      if (kDebugMode) {
        debugPrint(
          'NotificationService: Initialization completed successfully',
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'NotificationService: Error initializing notification service: '
          '$e\n$stackTrace',
        );
      }
      rethrow;
    }
  }

  /// Request runtime notification permissions.
  ///
  /// Android 13+ requires POST_NOTIFICATIONS permission.
  /// iOS requires explicit notification permissions.
  Future<void> _requestNotificationPermissions() async {
    try {
      if (kDebugMode) {
        debugPrint(
          'NotificationService: Requesting notification permissions...',
        );
      }

      // iOS permissions
      final IOSFlutterLocalNotificationsPlugin? iosPlugin =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();

      if (iosPlugin != null) {
        final bool? granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        if (kDebugMode) {
          debugPrint('NotificationService: iOS permission granted: $granted');
        }
      }

      // Android 13+ permissions
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidPlugin != null) {
        final bool? granted = await androidPlugin
            .requestNotificationsPermission();

        if (kDebugMode) {
          debugPrint(
            'NotificationService: Android permission granted: $granted',
          );
        }
      }

      if (kDebugMode) {
        debugPrint(
          'NotificationService: Notification permissions request completed',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'NotificationService: Error requesting notification permissions: $e',
        );
      }
      // Continue gracefully. Notification permission failure should not
      // prevent the app from functioning.
    }
  }

  /// Handles notification tap events.
  void _onNotificationResponse(NotificationResponse notificationResponse) {
    if (kDebugMode) {
      debugPrint(
        'NotificationService: Notification tapped. '
        'Payload: ${notificationResponse.payload}',
      );
    }

    // TODO: Add navigation logic here if needed.
  }

  /// Display a local notification for successful sync completion.
  ///
  /// Parameters:
  /// - [title]: Notification title.
  /// - [body]: Notification body.
  Future<void> showSyncSuccessNotification({
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'offline_sync_channel',
            'Offline Sync Notifications',
            channelDescription: 'Notifications for offline queued transactions that have successfully synced',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
       body:  body,
        notificationDetails:notificationDetails,
      );

      if (kDebugMode) {
        debugPrint(
          'NotificationService: Notification displayed. '
          'Title: $title',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService: Error displaying notification: $e');
      }
      // Notification failures should not crash the app.
    }
  }
}
