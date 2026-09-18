import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_engine.dart';

/// A global overlay widget that listens to [syncNotificationProvider]
/// and displays notifications as a banner at the top of the screen.
///
/// Place this widget high in the widget tree (e.g., in MyApp or as the root
/// of your app) to ensure it's visible across all screens.
class SyncNotificationOverlay extends ConsumerWidget {
  final Widget child;

  const SyncNotificationOverlay({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(syncNotificationProvider);

    return Stack(
      children: [
        child,
        // Animated notification banner at the top
        if (notification != null && notification.isNotEmpty)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              child: Semantics(
                // liveRegion: true forces screen readers to announce the banner as soon as it appears
                liveRegion: true,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            // Explicitly flags this text as a status message
                            container: true,
                            child: Text(
                              notification,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              semanticsLabel: 'Notification: $notification',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Semantics(
                          button: true,
                          enabled: true,
                          label: 'Dismiss notification',
                          child: GestureDetector(
                            onTap: () {
                              // Dismiss notification
                              ref.read(syncNotificationProvider.notifier).show('');
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
