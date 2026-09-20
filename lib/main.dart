import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novapay/src/core/database/app_database.dart';
import 'package:novapay/src/core/providers/firestore_sync_service.dart';
import 'package:novapay/src/core/providers/notification_service_provider.dart';
import 'package:novapay/src/features/offline_sync/services/sync_engine.dart';
import 'package:novapay/src/features/offline_sync/presentation/sync_notification_overlay.dart';
import 'package:novapay/src/router/app_router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();
  
  // Warm up and initialize NotificationService before UI builds
  await container.read(notificationServiceProvider.future);

  runApp( UncontrolledProviderScope(
    container: container,
    child: MyApp(),));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Initialize the database connection
    ref.read(databaseProvider);
    // Initialize the Background Replay Sync Engine on app boot
    ref.watch(syncEngineProvider);
    // Initialize Firestore sync listener at app startup to prevent multiple database instances
    ref.watch(firestoreSyncServiceProvider);
    // Initialize the notification service for offline sync completion alerts
    // ref.watch(notificationServiceProvider);

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'NovaPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: router,
      builder: (context, child) {
        return SyncNotificationOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
