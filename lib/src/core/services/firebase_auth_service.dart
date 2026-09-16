import 'package:firebase_auth/firebase_auth.dart';
import 'package:novapay/src/core/errors/auth_exceptions.dart';

/// Service layer for Firebase Authentication operations
/// Wraps FirebaseAuth to provide typed exceptions and consistent error handling
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Gets the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Listens to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Signs up a new user with email and password
  /// Throws [EmailAlreadyInUseException] if email exists
  /// Throws [WeakPasswordException] if password is weak
  /// Throws [NetworkException] on network errors
  /// Throws [UnknownAuthException] for other errors
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Signs in a user with email and password
  /// Throws [InvalidCredentialsException] if credentials are wrong
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [NetworkException] on network errors
  /// Throws [UnknownAuthException] for other errors
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw UnknownAuthException(
        message: 'Failed to sign out',
        cause: e as Exception?,
      );
    }
  }

  /// Sends a password reset email
  /// Throws [UserNotFoundException] if user email doesn't exist
  /// Throws [NetworkException] on network errors
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Verifies email for current user
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw UnknownAuthException(message: 'No user is currently signed in');
      }
      await user.sendEmailVerification();
    } catch (e) {
      throw UnknownAuthException(
        message: 'Failed to send verification email',
        cause: e as Exception?,
      );
    }
  }

  /// Checks if user's email is verified
  bool isEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  /// Updates user's email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      throw UnknownAuthException(
        message: 'Failed to update email',
        cause: e as Exception?,
      );
    }
  }

  /// Maps Firebase auth exceptions to typed exceptions
  AuthException _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return EmailAlreadyInUseException(cause: e);
      case 'invalid-email':
        return InvalidCredentialsException(
          message: 'The email format is invalid.',
          cause: e,
        );
      case 'operation-not-allowed':
        return UnknownAuthException(
          message: 'Operation not allowed. Please try again later.',
          cause: e,
        );
      case 'weak-password':
        return WeakPasswordException(cause: e);
      case 'user-disabled':
        return UnknownAuthException(
          message: 'This account has been disabled.',
          cause: e,
        );
      case 'user-not-found':
        return UserNotFoundException(cause: e);
      case 'wrong-password':
        return InvalidCredentialsException(cause: e);
      case 'invalid-credential':
        return InvalidCredentialsException(cause: e);
      case 'network-request-failed':
        return NetworkException(cause: e);
      case 'too-many-requests':
        return UnknownAuthException(
          message: 'Too many attempts. Please try again later.',
          cause: e,
        );
      default:
        return UnknownAuthException(
          message: e.message ?? 'An unknown authentication error occurred.',
          cause: e,
        );
    }
  }
}
