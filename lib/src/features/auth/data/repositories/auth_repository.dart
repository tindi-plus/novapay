import 'package:novapay/src/core/errors/auth_exceptions.dart';
import 'package:novapay/src/core/services/account_number_generator.dart';
import 'package:novapay/src/core/services/firebase_auth_service.dart';
import 'package:novapay/src/core/services/firestore_user_service.dart';
import 'package:novapay/src/features/auth/data/datasources/local_user_cache.dart';
import 'package:novapay/src/features/auth/domain/models/nova_user.dart';

/// Main authentication repository orchestrating auth flows
class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreUserService _firestoreUserService;
  final AccountNumberGenerator _accountNumberGenerator;
  final LocalUserCache _localUserCache;

  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
    required FirestoreUserService firestoreUserService,
    required AccountNumberGenerator accountNumberGenerator,
    required LocalUserCache localUserCache,
  })  : _firebaseAuthService = firebaseAuthService,
        _firestoreUserService = firestoreUserService,
        _accountNumberGenerator = accountNumberGenerator,
        _localUserCache = localUserCache;

  /// Sign up: Creates auth → generates account number → creates user doc
  Future<NovaUser> signUp({
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    required String phoneNumber,
    required String bvn,
    required String nin,
  }) async {
    try {
      final userCredential = await _firebaseAuthService.signUpWithEmail(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw UnknownAuthException(message: 'Failed to create account');
      }

      try {
        final accountNumber =
            await _accountNumberGenerator.generateUniqueAccountNumber();
        final now = DateTime.now();

        final novaUser = NovaUser(
          uid: uid,
          email: email,
          accountNumber: accountNumber,
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          bvn: bvn,
          nin: nin,
          phoneNumber: phoneNumber,
          createdAt: now,
          updatedAt: now,
        );

        await _firestoreUserService.createUserDocument(novaUser);
        await _localUserCache.cacheUserAfterLogin(novaUser);

        return novaUser;
      } catch (e) {
        await _firebaseAuthService.signOut();
        rethrow;
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Login: Authenticate → load user doc → cache locally
  Future<NovaUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuthService.signInWithEmail(
        email: email,
        password: password,
      );

      final uid = _firebaseAuthService.currentUser?.uid;
      if (uid == null) throw UnknownAuthException(message: 'Auth failed');

      final novaUser = await _firestoreUserService.getUserDocument(uid);
      await _localUserCache.cacheUserAfterLogin(novaUser);

      return novaUser;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Logout: Sign out and clear cache
  Future<void> logout() async {
    try {
      await _firebaseAuthService.signOut();
      await _localUserCache.clearUserCache();
    } catch (e) {
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Restore session from cache for app restart
  Future<NovaUser?> restoreSessionFromCache() async {
    try {
      final uid = await _localUserCache.getCurrentUserUid();
      if (uid == null) return null;

      final isCacheValid = await _localUserCache.isCacheValid();
      if (!isCacheValid) {
        await _localUserCache.clearUserCache();
        return null;
      }

      return await _localUserCache.getCachedUser(uid);
    } catch (e) {
      return null;
    }
  }

  /// Get current user from Firebase or cache
  Future<NovaUser?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuthService.currentUser;
      if (firebaseUser == null) return await restoreSessionFromCache();

      try {
        final firestoreUser =
            await _firestoreUserService.getUserDocument(firebaseUser.uid);
        await _localUserCache.syncCachedUser(firestoreUser);
        return firestoreUser;
      } catch (e) {
        return await _localUserCache.getCachedUser(firebaseUser.uid);
      }
    } catch (e) {
      return null;
    }
  }

  /// Listen to auth state changes
  Stream<NovaUser?> get authStateChanges {
    return _firebaseAuthService.authStateChanges.asyncMap((user) async {
      if (user == null) return null;
      try {
        return await _firestoreUserService.getUserDocument(user.uid);
      } catch (e) {
        return await _localUserCache.getCachedUser(user.uid);
      }
    });
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuthService.sendPasswordResetEmail(email);
  }

  /// Update user profile
  Future<void> updateUserProfile(NovaUser updatedUser) async {
    try {
      await _firestoreUserService.updateUserDocument(
        updatedUser.uid,
        {
          'firstName': updatedUser.firstName,
          'lastName': updatedUser.lastName,
          'middleName': updatedUser.middleName,
          'phoneNumber': updatedUser.phoneNumber,
          'updatedAt': updatedUser.updatedAt.toIso8601String(),
        },
      );
      await _localUserCache.updateCachedUser(updatedUser);
    } catch (e) {
      throw UnknownAuthException(cause: e as Exception?);
    }
  }
}
