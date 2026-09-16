import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:novapay/src/features/auth/data/drift/app_database.dart';
import 'package:novapay/src/features/auth/domain/models/nova_user.dart';

/// Service for caching user data locally using Drift and Secure Storage
/// Provides fallback for offline access to user profile
class LocalUserCache {
  final AppDatabase _database;
  final FlutterSecureStorage _secureStorage;

  // Keys for secure storage
  static const String _currentUserUidKey = 'current_user_uid';
  static const String _lastAuthTimeKey = 'last_auth_time';

  LocalUserCache({
    required AppDatabase database,
    FlutterSecureStorage? secureStorage,
  })  : _database = database,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Caches a user after successful login
  Future<void> cacheUserAfterLogin(NovaUser user) async {
    try {
      // Store in Drift database
      await _database.cacheUser(
        uid: user.uid,
        email: user.email,
        accountNumber: user.accountNumber,
        firstName: user.firstName,
        middleName: user.middleName,
        lastName: user.lastName,
        bvn: user.bvn,
        nin: user.nin,
        phoneNumber: user.phoneNumber,
        updatedAt: user.updatedAt.toIso8601String(),
      );

      // Store current user UID in secure storage
      await _secureStorage.write(
        key: _currentUserUidKey,
        value: user.uid,
      );

      // Store last auth time
      await _secureStorage.write(
        key: _lastAuthTimeKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // Log error but don't throw - caching is non-critical
      print('Error caching user: $e');
    }
  }

  /// Retrieves a cached user by UID from local database
  /// Returns null if not found
  Future<NovaUser?> getCachedUser(String uid) async {
    try {
      final cachedData = await _database.getCachedUser(uid);
      if (cachedData == null) return null;

      return NovaUser(
        uid: cachedData.uid,
        email: cachedData.email,
        accountNumber: cachedData.accountNumber,
        firstName: cachedData.firstName,
        middleName: cachedData.middleName,
        lastName: cachedData.lastName,
        bvn: cachedData.bvn,
        nin: cachedData.nin,
        phoneNumber: cachedData.phoneNumber,
        createdAt: DateTime.now(), // Use current time as we don't store it
        updatedAt: DateTime.parse(cachedData.updatedAt),
      );
    } catch (e) {
      print('Error retrieving cached user: $e');
      return null;
    }
  }

  /// Gets the current user's UID from secure storage
  /// Returns null if no user is cached
  Future<String?> getCurrentUserUid() async {
    try {
      return await _secureStorage.read(key: _currentUserUidKey);
    } catch (e) {
      print('Error reading current user UID: $e');
      return null;
    }
  }

  /// Gets the last authentication time
  /// Returns null if never authenticated
  Future<DateTime?> getLastAuthTime() async {
    try {
      final timeStr = await _secureStorage.read(key: _lastAuthTimeKey);
      if (timeStr == null) return null;
      return DateTime.parse(timeStr);
    } catch (e) {
      print('Error reading last auth time: $e');
      return null;
    }
  }

  /// Updates the cached user profile
  Future<void> updateCachedUser(NovaUser user) async {
    try {
      await _database.cacheUser(
        uid: user.uid,
        email: user.email,
        accountNumber: user.accountNumber,
        firstName: user.firstName,
        middleName: user.middleName,
        lastName: user.lastName,
        bvn: user.bvn,
        nin: user.nin,
        phoneNumber: user.phoneNumber,
        updatedAt: user.updatedAt.toIso8601String(),
      );
    } catch (e) {
      print('Error updating cached user: $e');
    }
  }

  /// Clears the current user cache after logout
  Future<void> clearUserCache() async {
    try {
      // Get the current user UID
      final currentUid = await getCurrentUserUid();

      // Clear from Drift
      if (currentUid != null) {
        await _database.clearCachedUser(currentUid);
      }

      // Clear from secure storage
      await _secureStorage.delete(key: _currentUserUidKey);
      await _secureStorage.delete(key: _lastAuthTimeKey);
    } catch (e) {
      print('Error clearing user cache: $e');
    }
  }

  /// Clears all cached users (for debugging/testing)
  Future<void> clearAllUsers() async {
    try {
      await _database.clearAllCachedUsers();
      await _secureStorage.delete(key: _currentUserUidKey);
      await _secureStorage.delete(key: _lastAuthTimeKey);
    } catch (e) {
      print('Error clearing all cached users: $e');
    }
  }

  /// Checks if the cache is still valid (user was cached recently)
  Future<bool> isCacheValid({Duration cacheValidityDuration = const Duration(days: 7)}) async {
    try {
      final lastAuthTime = await getLastAuthTime();
      if (lastAuthTime == null) return false;

      final now = DateTime.now();
      return now.difference(lastAuthTime) < cacheValidityDuration;
    } catch (e) {
      return false;
    }
  }

  /// Syncs cached user with Firestore data (updates cache)
  Future<void> syncCachedUser(NovaUser user) async {
    await updateCachedUser(user);
  }
}
