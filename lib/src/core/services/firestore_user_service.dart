import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novapay/src/core/errors/auth_exceptions.dart';
import 'package:novapay/src/features/auth/domain/models/nova_user.dart';

/// Service layer for Firestore user operations
/// Handles user document creation, retrieval, and updates
class FirestoreUserService {
  final FirebaseFirestore _firestore;
  static const String usersCollection = 'users';

  FirestoreUserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Creates a new user document in Firestore
  /// Throws [NetworkException] on network errors
  /// Throws [UnknownAuthException] for other errors
  Future<void> createUserDocument(NovaUser user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.uid)
          .set(user.toFirestoreMap());
    } on FirebaseException catch (e) {
      if (e.code == 'network-error') {
        throw NetworkException(cause: e);
      }
      throw UnknownAuthException(
        message: 'Failed to create user profile',
        cause: e,
      );
    } catch (e) {
      throw UnknownAuthException(
        message: 'Failed to create user profile',
        cause: e as Exception?,
      );
    }
  }

  /// Retrieves a user document from Firestore
  /// Returns NovaUser if found
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [NetworkException] on network errors
  Future<NovaUser> getUserDocument(String uid) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw UserNotFoundException(
          message: 'User profile not found. Please complete registration.',
        );
      }

      return NovaUser.fromFirestore(
        doc,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'network-error') {
        throw NetworkException(cause: e);
      }
      throw UnknownAuthException(
        message: 'Failed to retrieve user profile',
        cause: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownAuthException(
        message: 'Failed to retrieve user profile',
        cause: e as Exception?,
      );
    }
  }

  /// Updates a user document in Firestore
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [NetworkException] on network errors
  Future<void> updateUserDocument(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .update(updates);
    } on FirebaseException catch (e) {
      if (e.code == 'network-error') {
        throw NetworkException(cause: e);
      }
      if (e.code == 'not-found') {
        throw UserNotFoundException(cause: e);
      }
      throw UnknownAuthException(
        message: 'Failed to update user profile',
        cause: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownAuthException(
        message: 'Failed to update user profile',
        cause: e as Exception?,
      );
    }
  }

  /// Deletes a user document from Firestore
  Future<void> deleteUserDocument(String uid) async {
    try {
      await _firestore.collection(usersCollection).doc(uid).delete();
    } on FirebaseException catch (e) {
      throw UnknownAuthException(
        message: 'Failed to delete user profile',
        cause: e,
      );
    } catch (e) {
      throw UnknownAuthException(
        message: 'Failed to delete user profile',
        cause: e as Exception?,
      );
    }
  }

  /// Checks if a user document exists
  Future<bool> userDocumentExists(String uid) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(uid)
          .get();
      return doc.exists;
    } on FirebaseException catch (e) {
      if (e.code == 'network-error') {
        throw NetworkException(cause: e);
      }
      throw UnknownAuthException(cause: e);
    } catch (e) {
      throw UnknownAuthException(cause: e as Exception?);
    }
  }

  /// Verifies user's email in Firestore
  Future<void> markEmailAsVerified(String uid) async {
    try {
      await updateUserDocument(uid, {'isEmailVerified': true});
    } catch (e) {
      // Continue even if update fails - email is still verified in Firebase
    }
  }

  /// Gets a reference to a specific user document
  DocumentReference<Map<String, dynamic>> getUserDocumentRef(String uid) {
    return _firestore.collection(usersCollection).doc(uid);
  }

  /// Streams user document changes
  Stream<NovaUser?> streamUserDocument(String uid) {
    return _firestore
        .collection(usersCollection)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      return NovaUser.fromFirestore(
        snapshot,
      );
    });
  }
}
