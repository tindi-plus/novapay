import 'package:novapay/src/features/auth/domain/models/nova_user.dart';

/// Sealed auth state union for comprehensive type safety
sealed class AuthState {
  const AuthState();
}

/// Initial state before any auth operation
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during auth operation
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Successfully authenticated with user data
class AuthAuthenticated extends AuthState {
  final NovaUser user;

  const AuthAuthenticated({required this.user});
}

/// User logged out successfully
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Authentication error state
class AuthError extends AuthState {
  final String message;
  final Exception? cause;

  const AuthError({
    required this.message,
    this.cause,
  });
}

/// Extension methods for convenient state checking
extension AuthStateExtension on AuthState {
  bool get isLoading => this is AuthLoading;

  bool get isAuthenticated => this is AuthAuthenticated;

  bool get isUnauthenticated => this is AuthUnauthenticated;

  bool get isError => this is AuthError;

  NovaUser? get userOrNull {
    return switch (this) {
      AuthAuthenticated state => state.user,
      _ => null,
    };
  }

  String? get errorMessage {
    return switch (this) {
      AuthError state => state.message,
      _ => null,
    };
  }
}
