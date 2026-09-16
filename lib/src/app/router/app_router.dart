import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novapay/src/features/auth/presentation/screens/login_screen.dart';
import 'package:novapay/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:novapay/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:novapay/src/features/home/presentation/screens/home_screen.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_controller.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_state.dart';

// Create a notifier to convert Riverpod state changes into a Listenable for GoRouter
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    // Listen to the auth state provider and trigger a router refresh whenever it updates
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authControllerState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    // Fix 1: Tell GoRouter to re-run the redirect logic whenever the auth state changes
    refreshListenable: RouterRefreshNotifier(ref), 
    redirect: (context, state) {
      final authState = authControllerState.value;
      final isLoading = authControllerState.isLoading;
      final currentPath = state.matchedLocation;

      // 1. Show splash while loading
      if (isLoading) {
        return '/splash';
      }

      final isAuthenticated = authState is AuthAuthenticated;

      // 2. If we just finished loading and we are on the splash screen, move away
      if (currentPath == '/splash') {
        return isAuthenticated ? '/home' : '/login';
      }

      // 3. If authenticated, prevent access to login/signup
      if (isAuthenticated && (currentPath == '/login' || currentPath == '/signup')) {
        return '/home';
      }

      // 4. If not authenticated, prevent access to protected routes (like /home)
      if (!isAuthenticated && currentPath == '/home') {
        return '/login';
      }

      // 5. Default root path handling
      if (currentPath == '/') {
        return isAuthenticated ? '/home' : '/login';
      }

      return null; // Return null to stay on the requested route
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Fix 2: Changed to standard route mapping to let the top-level redirect handle it safely
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Route not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
