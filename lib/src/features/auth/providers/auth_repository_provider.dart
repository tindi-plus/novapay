import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novapay/src/core/services/account_number_generator.dart';
import 'package:novapay/src/core/services/firebase_auth_service.dart';
import 'package:novapay/src/core/services/firestore_user_service.dart';
import 'package:novapay/src/features/auth/data/datasources/local_user_cache.dart';
import 'package:novapay/src/features/auth/data/drift/app_database.dart';
import 'package:novapay/src/features/auth/data/repositories/auth_repository.dart';

/// Provides the Drift database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provides the Firebase Auth service
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

/// Provides the Firestore user service
final firestoreUserServiceProvider = Provider<FirestoreUserService>((ref) {
  return FirestoreUserService();
});

/// Provides the account number generator
final accountNumberGeneratorProvider = Provider<AccountNumberGenerator>((ref) {
  return AccountNumberGenerator();
});

/// Provides the local user cache
final localUserCacheProvider = Provider<LocalUserCache>((ref) {
  final database = ref.watch(databaseProvider);
  return LocalUserCache(database: database);
});

/// Provides the main authentication repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuthService = ref.watch(firebaseAuthServiceProvider);
  final firestoreUserService = ref.watch(firestoreUserServiceProvider);
  final accountNumberGenerator = ref.watch(accountNumberGeneratorProvider);
  final localUserCache = ref.watch(localUserCacheProvider);

  return AuthRepository(
    firebaseAuthService: firebaseAuthService,
    firestoreUserService: firestoreUserService,
    accountNumberGenerator: accountNumberGenerator,
    localUserCache: localUserCache,
  );
});
