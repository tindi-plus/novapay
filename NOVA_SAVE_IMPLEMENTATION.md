# NovaSave Implementation Documentation

## Overview
This document describes the implementation of the NovaSave goal-based micro-savings feature for the NovaPay application. The implementation includes a Freezed data model and a Drift database schema for offline-first savings goal management.

## Files Created/Modified

### 1. Data Model
**File:** `lib/src/features/nova_save/domain/savings_goal_model.dart`

A Freezed immutable data model representing a single savings goal.

#### Fields
- `String id` - Unique identifier (Firestore document ID or UUID)
- `String userId` - User ID who owns this savings goal
- `String name` - Goal name (e.g., "Emergency Fund", "Vacation Fund")
- `int targetAmountInKobo` - 64-bit int target amount in Kobo (100 Kobo = ₦1.00)
- `int currentAmountInKobo` - 64-bit int current saved amount in Kobo
- `DateTime targetDate` - Target date for achieving the goal
- `DateTime createdAt` - When the savings goal was created

#### Methods - Serialization
- `toJson()` - Serializes to JSON with ISO 8601 datetime strings
- `fromJson(Map<String, dynamic> json)` - Deserializes from JSON
- `toMap()` - Converts to Map for database storage (preserves DateTime objects)
- `fromMap(Map<String, dynamic> map)` - Deserializes from Map, handling both String and DateTime formats

#### Methods - Built-in by Freezed
- `copyWith()` - Creates a copy with selected fields replaced (auto-generated)

#### Helper Getters
- `formattedTargetNaira` - Returns formatted target amount (e.g., "₦50,000.00")
- `formattedCurrentNaira` - Returns formatted current amount (e.g., "₦12,500.00")
- `progressRatio` - Returns progress as double between 0.0-1.0 (clamped)
- `progressPercentage` - Returns progress as formatted percentage string (e.g., "25%")

#### Usage Example
```dart
final goal = SavingsGoalModel(
  id: 'goal-001',
  userId: 'user-123',
  name: 'Emergency Fund',
  targetAmountInKobo: 5000000, // ₦50,000.00
  currentAmountInKobo: 1250000, // ₦12,500.00
  targetDate: DateTime(2025, 12, 31),
  createdAt: DateTime.now(),
);

print(goal.formattedTargetNaira); // ₦50,000.00
print(goal.progressPercentage); // 25%

final updated = goal.copyWith(currentAmountInKobo: 2500000);
print(updated.progressPercentage); // 50%
```

## 2. Database Schema

**File:** `lib/src/core/database/tables.dart`

Added `LocalSavingsGoals` Drift table:

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TextColumn | Primary Key | Unique identifier |
| `userId` | TextColumn | Required | User ID for querying |
| `name` | TextColumn | Required | Goal name |
| `targetAmountInKobo` | Int64Column | Required | 64-bit target amount |
| `currentAmountInKobo` | Int64Column | Required | 64-bit current amount |
| `targetDate` | DateTimeColumn | Required | Goal target date |
| `createdAt` | DateTimeColumn | Required, Default: now | Creation timestamp |

## 3. Database DAO Methods

**File:** `lib/src/core/database/app_database.dart`

Updated schema version from 1 to 2 and added LocalSavingsGoals table to @DriftDatabase annotation.

### Insert/Update
```dart
Future<void> saveSavingsGoal({
  required String id,
  required String userId,
  required String name,
  required int targetAmountInKobo,
  required int currentAmountInKobo,
  required DateTime targetDate,
  DateTime? createdAt,
})
```
Upserts a savings goal by id.

### Read - Streaming
```dart
Stream<List<LocalSavingsGoal>> watchSavingsGoalsByUserId(String userId)
```
Returns stream of all goals for a user, ordered newest first. For reactive UI.

### Read - One-Time
```dart
Future<List<LocalSavingsGoal>> getSavingsGoalsByUserId(String userId)
Future<LocalSavingsGoal?> getSavingsGoalById(String id)
```

### Update
```dart
Future<void> updateSavingsGoalCurrentAmount(
  String id,
  {required int currentAmountInKobo}
)
```
Update only current amount without replacing entire record.

### Delete
```dart
Future<void> deleteSavingsGoal(String id)
Future<void> deleteAllSavingsGoalsByUserId(String userId)
Future<void> clearAllSavingsGoals()
```

## 4. Testing

**File:** `test/savings_goal_model_test.dart`

✅ 16 tests pass covering:
- Model creation and field access
- Currency formatting (Naira)
- Progress calculation (ratio and percentage)
- Serialization/deserialization (JSON and Map)
- copyWith functionality
- DateTime handling
- Edge cases (zero target, overachievement, 64-bit values)

Run tests:
```bash
flutter test test/savings_goal_model_test.dart
```

## Architecture Alignment

✅ Follows NovaPay conventions:
- Freezed immutable models (like TransactionModel, UserModel)
- Drift for local database (consistent with existing pattern)
- 64-bit integers for Kobo amounts
- Currency formatting with intl package
- Offline-first caching pattern
- Stream-based DAO queries for reactive UI

✅ No existing functionality changed:
- All existing tables remain unchanged
- Existing DAO methods untouched
- Schema version increment only (additive)
- Fully backward compatible

## Code Generation

Auto-generated files (do not edit):
- `lib/src/features/nova_save/domain/savings_goal_model.freezed.dart`
- `lib/src/features/nova_save/domain/savings_goal_model.g.dart`
- `lib/src/core/database/app_database.g.dart` (updated)

Regenerate after changes:
```bash
flutter pub run build_runner build
```

## Summary

✅ **Implementation Complete**
- Data model with Freezed: 155 lines of code
- Database schema: 28 lines of code
- DAO methods: 81 lines of code
- Tests: 16 passing tests
- Documentation: This file

Ready for integration with Firestore repository and UI screens.
