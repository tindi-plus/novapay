import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/features/offline_sync/presentation/sync_notification_overlay.dart';
import 'package:novapay/src/features/offline_sync/services/sync_engine.dart';

void main() {
  group('SyncNotificationOverlay', () {
    testWidgets('displays notification when syncNotificationProvider updates',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SyncNotificationOverlay(
              child: Scaffold(
                body: Center(
                  child: Consumer(
                    builder: (context, ref, _) {
                      return ElevatedButton(
                        onPressed: () {
                          ref.read(syncNotificationProvider.notifier).show(
                                'Test notification',
                              );
                        },
                        child: const Text('Show'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initially no notification
      expect(find.text('Test notification'), findsNothing);

      // Show notification
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Notification is displayed
      expect(find.text('Test notification'), findsOneWidget);
    });

    testWidgets('dismisses notification on close button tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SyncNotificationOverlay(
              child: Scaffold(
                body: Center(
                  child: Consumer(
                    builder: (context, ref, _) {
                      return ElevatedButton(
                        onPressed: () {
                          ref
                              .read(syncNotificationProvider.notifier)
                              .show('Dismiss me');
                        },
                        child: const Text('Show'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Show notification
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss me'), findsOneWidget);

      // Close it
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss me'), findsNothing);
    });
  });
}
