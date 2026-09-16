import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/models/user_model.dart';
import '../../../core/providers/firebase_providers.dart';
import '../data/auth_repository.dart';

/// Provider for auth state changes (Firebase User)
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provider for current user's profile (UserModel)
/// Listens to auth state and fetches profile when user is authenticated
final currentUserProfileProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);

  // If there's no authenticated user, return null
  if (authState.value == null) {
    return null;
  }

  final user = authState.value!;
  final authRepository = ref.watch(authRepositoryProvider);

  try {
    return await authRepository.getUserProfile(user.uid);
  } catch (e) {
    // Return null on error - UI can handle this
    return null;
  }
});

/// Controller for authentication actions with loading/error state management
class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  /// Sign up with email, password and user details
  Future<void> signUp({
    required String email,
    required String password,
    required UserModel user,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        user: user,
      );
    });
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);

/// Alternative StreamProvider version for real-time user profile updates
final currentUserProfileStreamProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState.value == null) {
    return Stream.value(null);
  }

  final userId = authState.value!.uid;
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserModel.fromMap(snapshot.data()!);
  });
});
