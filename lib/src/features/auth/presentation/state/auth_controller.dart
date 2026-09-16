import 'package:riverpod/riverpod.dart';
import 'package:novapay/src/core/errors/auth_exceptions.dart';
import 'package:novapay/src/features/auth/data/repositories/auth_repository.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_state.dart';

import '../../providers/auth_repository_provider.dart';

/// Riverpod AsyncNotifier for managing authentication state
class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _repository;

  @override
  Future<AuthState> build() async {
    _repository = ref.watch(authRepositoryProvider);

    // Try to restore user from cache on app startup
    final cachedUser = await _repository.restoreSessionFromCache();
    if (cachedUser != null) {
      return AuthAuthenticated(user: cachedUser);
    }

    return const AuthUnauthenticated();
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    required String phoneNumber,
    required String bvn,
    required String nin,
  }) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() async {
      final user = await _repository.signUp(
        email: email,
        password: password,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        bvn: bvn,
        nin: nin,
      );
      return AuthAuthenticated(user: user);
    });

    state = newState.when(
      data: (authState) => AsyncValue.data(authState),
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) {
        final message = _getErrorMessage(error);
        return AsyncValue.data(
          AuthError(
            message: message,
            cause: error is Exception ? error : null,
          ),
        );
      },
    );
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() async {
      final user = await _repository.login(
        email: email,
        password: password,
      );
      return AuthAuthenticated(user: user);
    });

    state = newState.when(
      data: (authState) => AsyncValue.data(authState),
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) {
        final message = _getErrorMessage(error);
        return AsyncValue.data(
          AuthError(
            message: message,
            cause: error is Exception ? error : null,
          ),
        );
      },
    );
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _repository.logout();
      state = const AsyncValue.data(AuthUnauthenticated());
    } catch (e) {
      final message = _getErrorMessage(e);
      state = AsyncValue.data(
        AuthError(message: message, cause: e as Exception?),
      );
    }
  }

  /// Refresh current user from Firestore
  Future<void> refreshUser() async {
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AsyncValue.data(AuthAuthenticated(user: user));
      }
    } catch (e) {
      final message = _getErrorMessage(e);
      state = AsyncValue.data(
        AuthError(message: message, cause: e as Exception?),
      );
    }
  }

  /// Maps exceptions to user-friendly messages
  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString();
    } else {
      return 'An unexpected error occurred';
    }
  }
}

/// Riverpod provider for auth controller
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(
  () => AuthController(),
);
