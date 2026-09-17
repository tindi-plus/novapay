import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/signup_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/send_money/presentation/send_money_screen.dart';
import '../features/authentication/providers/auth_providers.dart';


/// Route path constants
const String loginPath = '/login';
const String registerPath = '/register';
const String homePath = '/home';
const String sendMoneyPath = '/send-money';

/// A ChangeNotifier that listens to authStateProvider changes and notifies
/// GoRouter to re-evaluate the redirect logic. This prevents redirect loops
/// and ensures dynamic updates when auth state changes (e.g. login/logout).
class RouterNotifier extends ChangeNotifier {
  final Ref ref;
  late final ProviderSubscription<AsyncValue<User?>> _subscription;

  RouterNotifier(this.ref) {
    // Listen to auth state changes and trigger GoRouter refresh
    _subscription = ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (_, _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

/// Provider for the RouterNotifier (used by refreshListenable)
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  final notifier = RouterNotifier(ref);
  // Clean up on provider disposal
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Riverpod provider that exposes a configured GoRouter instance.
/// This is consumed in main.dart via MaterialApp.router.
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: loginPath,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (BuildContext context, GoRouterState state) {
      // Read the current auth state (AsyncValue<User?>)
      final authState = ref.read(authStateProvider);
      final isLoading = authState.isLoading;
      final user = authState.value;
      final isAuthenticated = user != null;

      final location = state.matchedLocation;

      // During initial auth loading (Firebase authStateChanges), do not redirect
      // This prevents redirect loops and flashing between screens
      if (isLoading) {
        return null;
      }

      final isAuthRoute =
          location == loginPath || location == registerPath;

      // Unauthenticated user trying to access protected route -> login
      if (!isAuthenticated && !isAuthRoute) {
        return loginPath;
      }

      // Authenticated user trying to access login/register -> home
      if (isAuthenticated && isAuthRoute) {
        return homePath;
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) => const SignupScreen(),
      ),
      // Protected home route
      GoRoute(
        path: homePath,
        builder: (context, state) => const HomeScreen(),
      ),
      // Send money route
      GoRoute(
        path: sendMoneyPath,
        builder: (context, state) => const SendMoneyScreen(),
      ),
    ],
  );
});

/// The screens are now implemented in:
/// - lib/src/features/authentication/presentation/login_screen.dart
/// - lib/src/features/authentication/presentation/signup_screen.dart  
/// - lib/src/features/home/presentation/home_screen.dart
/// 
/// All screens meet accessibility requirements:
/// - SingleChildScrollView for font scaling support
/// - Explicit Semantics for screen readers
/// - Minimum 48dp/56dp touch targets
/// - No fixed height constraints on text elements
