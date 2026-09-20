# Local Notifications Implementation for NovaPay

## Overview

This document describes the implementation of local notifications for alerting users when queued offline transactions successfully sync. The solution uses `flutter_local_notifications` to provide platform-native notifications on both Android and iOS.

## Architecture

### Components

1. **NotificationService** (`lib/src/core/notifications/notification_service.dart`)
   - Core service that manages local notifications
   - Handles platform-specific (Android/iOS) initialization
   - Requests runtime notification permissions
   - Provides `showSyncSuccessNotification()` method for displaying notifications

2. **Riverpod Provider** (`lib/src/core/providers/notification_service_provider.dart`)
   - `notificationServiceProvider`: Async provider that initializes and manages the NotificationService lifecycle
   - Ensures the service is initialized once and kept alive throughout the app lifecycle

3. **SyncEngine Integration** (`lib/src/features/offline_sync/services/sync_engine.dart`)
   - Added `_notificationService` field to store service reference
   - `_initializeNotificationService()`: Watches the provider and captures the service instance
   - `_formatNaira()`: Helper to format kobo amounts as Nigerian Naira (₦XX.XX)
   - `_buildNotificationContent()`: Extracts transaction details from payloads and builds notification messages
   - `_triggerSyncSuccessNotification()`: Called after successful sync to display notifications

4. **Main App Initialization** (`lib/main.dart`)
   - Added `ref.watch(notificationServiceProvider)` to initialize service on app startup

## Feature Details

### Notification Content Format

**Send Money Transactions**
```
Title: "Transfer Completed"
Body: "Your queued transfer of ₦{amount} has been processed."
```

**Savings Contribution Transactions**
```
Title: "Savings Updated"
Body: "Your queued contribution of ₦{amount} to {goal_name} was successful."
```

### Platform-Specific Configuration

**Android**
- Channel ID: `offline_sync_channel`
- Importance: High, Priority: High
- Features: Sound, vibration enabled
- Target: Android 5.0+ (API 21+)

**iOS**
- Sound, Alert, Badge: Enabled
- Target: iOS 10+

## Defensive Handling: Preventing Real-Time Transaction Notifications

The implementation ensures notifications fire **ONLY** for offline queued transactions that are replayed:

1. **Detection**: Only transactions in the `PendingQueueItems` table with status `pending` are considered queued
2. **Trigger Point**: `_triggerSyncSuccessNotification()` is called exclusively after successful replay
3. **Real-Time Bypass**: Online transactions never enter the queue, so never trigger notifications

## Implementation Details

### Initialization Flow

1. App startup calls `ref.watch(notificationServiceProvider)` in main.dart
2. NotificationService creates platform channels and requests permissions
3. SyncEngine captures service reference via `_initializeNotificationService()`
4. Service is ready to display notifications during sync operations

### Payload Parsing

Example payload for send_money:
```dart
{
  "amountInKobo": 20000,        // ₦200.00
  "userId": "user-123",
  "recipientId": "recipient-456"
}
```

Example payload for save_contribute:
```dart
{
  "amountInKobo": 50000,        // ₦500.00
  "goalName": "Emergency Fund",
  "userId": "user-123",
  "goalId": "goal-789"
}
```

### Error Handling

- Permission denials: App continues normally
- Notification display failures: Don't affect sync process
- Missing payload fields: Skipped with debug log
- Service initialization delays: Skipped gracefully
- All errors logged to debug console in development

## Files Created/Modified

### Created Files
- `lib/src/core/notifications/notification_service.dart` - Main notification service
- `lib/src/core/providers/notification_service_provider.dart` - Riverpod provider

### Modified Files
- `lib/src/features/offline_sync/services/sync_engine.dart` - Integration with sync engine
- `lib/main.dart` - Service initialization
- `pubspec.yaml` - Added flutter_local_notifications dependency

## Dependencies

```yaml
flutter_local_notifications: ^17.0.0
```

Also uses:
- `intl: ^0.20.3` - Currency formatting
- `riverpod_annotation` - Riverpod code generation
