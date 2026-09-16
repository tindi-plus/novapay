import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novapay/src/features/auth/domain/models/nova_user.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_controller.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_state.dart';

/// Provides the current authenticated user, or null if not authenticated
final currentUserProvider = Provider<NovaUser?>((ref) {
  final asyncState = ref.watch(authControllerProvider);

  return switch (asyncState) {
    AsyncData(:final value) => switch (value) {
      AuthAuthenticated state => state.user,
      _ => null,
    },
    _ => null,
  };
});

/// Provides a stream of auth state changes
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final authState = ref.watch(authControllerProvider).value;

  return authState == null ? const Stream.empty() : Stream.value(authState);
});

/// Provides whether the user is currently authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider).value;
  return authState is AuthAuthenticated;
});

/// Provides the current auth loading state
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.isLoading;
});

/// Provides the current auth error message, if any
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authControllerProvider).value;
  
  return switch (authState) {
    AuthError state => state.message,
    _ => null,
  };
});
