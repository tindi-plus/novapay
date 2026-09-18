# Fix: Firestore Listener & Database Instance Errors

## Problems Fixed

### Error 1: Database Connection Closed
```
Bad state: Tried to send Request (id = 10): StatementMethod.insert: ... 
over isolate channel, but the connection was closed!
```

### Error 2: Multiple Database Instances  
```
WARNING (drift): It looks like you've created the database class AppDatabase multiple times.
When these two databases use the same QueryExecutor, race conditions will occur.
```

## Root Causes

### Error 1 - Connection Closed:
- Firestore listener not registered with Riverpod lifecycle
- Database disposed while listener still running
- Race condition on SQLite access

### Error 2 - Multiple Instances:
- Called `ref.watch()` inside async methods
- Caused provider re-evaluation cycles
- Database provider recreated multiple times
- Multiple SQLite instances with same connection → Drift warning

## Solution: Two-Part Fix

### Part 1: Proper Lifecycle Management
Use `ref.onDispose()` to register listener cleanup with Riverpod

### Part 2: Correct Dependency Tracking  
Move ALL `ref.watch()` calls to provider level (not inside async methods)

## Key Changes

### BEFORE (Problematic):
```dart
@riverpod
Future<void> firestoreSyncService(Ref ref) async {
  final service = FirestoreSyncService(ref);
  await service.setupRecentTransactionsSyncListener(); 
}

class FirestoreSyncService {
  Future<void> setupRecentTransactionsSyncListener() async {
    final authState = ref.watch(authStateProvider);  // ❌ Inside async!
    final database = ref.watch(databaseProvider);    // ❌ Causes re-eval!
    // ...
  }
}
```

### AFTER (Fixed):
```dart
@riverpod
Future<void> firestoreSyncService(Ref ref) async {
  // ✅ All ref.watch() calls FIRST, at provider level
  final authState = ref.watch(auth.authStateProvider);
  final firestore = ref.watch(firestoreProvider);
  final database = ref.watch(databaseProvider);
  
  final service = FirestoreSyncService(ref);
  
  // ✅ Pass as parameters (no async watches)
  await service.setupRecentTransactionsSyncListener(
    authState: authState,
    firestore: firestore,
    database: database,
  );
}

class FirestoreSyncService {
  Future<void> setupRecentTransactionsSyncListener({
    required AsyncValue<User?> authState,
    required FirebaseFirestore firestore,
    required AppDatabase database,
  }) async {
    // ✅ No ref.watch() calls here
    // ✅ Service receives dependencies as parameters
    
    if (authState.value == null) return;
    
    final subscription = firestore
        .collection('users')
        .doc(authState.value!.uid)
        .collection('transactions')
        .snapshots()
        .listen((snapshot) async {
          for (final doc in snapshot.docs) {
            try {
              await database.saveRecentTransaction(...);
            } catch (e) {
              debugPrint('Error: $e');
            }
          }
        });
    
    // ✅ Register cleanup - listener cancelled on provider disposal
    ref.onDispose(() {
      subscription.cancel();
    });
  }
}
```

## Why This Works

**Fixes Error 1 (Connection Closed):**
- `ref.onDispose()` ensures listener properly cancelled
- Database stays open while listener active  
- Try-catch handles errors gracefully
- No race conditions

**Fixes Error 2 (Multiple Instances):**
- Watching dependencies at provider level prevents re-evaluation cycles
- Riverpod caches database provider correctly
- No additional instances created
- No Drift warnings

## Files Changed

### Created: `lib/src/core/providers/firestore_sync_service.dart` (130 lines)
- `FirestoreSyncService` class
- `@riverpod Future<void> firestoreSyncService(Ref ref)` provider
- All dependencies watched at provider level
- Proper error handling and cleanup

### Modified: `lib/src/features/home/data/recent_transactions_repository.dart`  
- Removed `_setupFirestoreListener()` method
- Added `ref.watch(firestoreSyncServiceProvider)` trigger
- Repository focuses on data access only

### Unchanged: `lib/src/core/database/app_database.dart`

## Results

After this fix:

✅ No "connection was closed" errors  
✅ No "AppDatabase multiple times" warnings  
✅ Transactions sync reliably from Firestore to Drift  
✅ Listener lifecycle properly managed by Riverpod  
✅ Auth state changes handled gracefully  
✅ Offline transaction viewing works  

## Architecture Benefits

- **Separation of Concerns**: Listener management ≠ Data access
- **Proper Lifecycle**: Riverpod manages listener lifetime  
- **Error Resilience**: Try-catch wraps DB operations
- **Scalability**: Pattern works for other listeners
- **Testability**: Services testable independently
- **Maintainability**: Clear responsibilities
