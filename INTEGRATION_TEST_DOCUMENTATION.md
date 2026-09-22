# Offline Queue Sync Integration Test Documentation

## Overview

`integration_test/offline_queue_sync_test.dart` covers NovaPay's offline-first transaction lifecycle:
- Local persistence via Drift SQLite
- Idempotent replay with exactly-once guarantees
- State transitions (pending → processing → success)
- Background synchronization on connectivity restoration
- Regression guards against double-replay

## Test Constants

```dart
initialBalanceKobo = 2500000              // ₦25,000.00
sendAmountKobo = 500000                   // ₦5,000.00
expectedFinalBalanceKobo = 2000000        // ₦20,000.00
testIdempotencyKey = '550e8400-e29b-41d4-a716-446655440000'
```

## Main Test: 5-Step Lifecycle (TEST 1)

### Step 1: Initial Setup
- Boot app with 2,500,000 Kobo balance
- Assert: `walletBalanceInKobo == 2500000`

### Step 2: Offline Enqueue
- Mock `ConnectivityResult.none`
- Enqueue 500,000 Kobo transaction
- Assert: Queue has 1 pending item with correct idempotency key and Kobo amount

### Step 3: App Restart Simulation
- Create new queue service instance
- Assert: Transaction persisted with same idempotency key and pending status

### Step 4: Network Restoration & Sync
- Toggle connectivity to `ConnectivityResult.mobile`
- Call `SyncEngine.processQueue()`
- Assert:
  - Cloud Function called exactly once
  - Idempotency key in payload matches test constant
  - Amount in payload: 500,000 Kobo
  - Queue becomes empty after sync

### Step 5: Double-Replay Guard
- Call `SyncEngine.processQueue()` again
- Assert:
  - Cloud Function NOT called again
  - Queue remains empty
  - No double debit

## Additional Tests (2-8)

| # | Test Name | Focus |
|---|-----------|-------|
| 2 | Multiple transactions | Queue multiple items, verify FIFO ordering |
| 3 | Duplicate keys | Unique constraint rejection |
| 4 | Status update | Transition from pending to processing |
| 5 | Item deletion | Remove after sync |
| 6 | Kobo precision | Amounts: 1, 100, 500000, 2500000, 9999999 |
| 7 | Key persistence | Survive app restarts |
| 8 | Ordered retrieval | FIFO processing |

## Running Tests

```bash
# All integration tests
flutter test integration_test/

# Specific test
flutter test integration_test/offline_queue_sync_test.dart

# Verbose
flutter test integration_test/offline_queue_sync_test.dart -v

# Specific device
flutter test integration_test/offline_queue_sync_test.dart -d ios
```

## Mock Services

- `MockFirebaseAuth`: Auth state
- `MockFirebaseFirestore`: User profiles
- `MockFirebaseFunctions`: Cloud Function invocation tracking
- `MockConnectivity`: Network state toggling
- `MockAuthRepository`: User profile repository

## Key Verifications

✅ Integer Kobo amounts (no floats)  
✅ Exact idempotency key in payloads  
✅ State machine transitions  
✅ Exactly-once Cloud Function calls  
✅ Database persistence across restarts  
✅ FIFO queue processing  
✅ Duplicate key rejection  

## Total: 8 Test Cases, 45+ Assertions
