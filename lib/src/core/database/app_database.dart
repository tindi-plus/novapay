import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The main database class for the NovaPay app using Drift (SQLite).
///
/// This provides offline persistence for:
/// - A pending action queue (for offline-first sync to backend)
/// - Local cached transaction history (ledger) - used for sync queue management
/// - Recent transaction history (user-facing) - cached from Firestore for offline viewing
/// - Local cached savings goals (NovaSave feature) - cached from Firestore for offline viewing
@DriftDatabase(
  tables: [PendingQueueItems, LocalTransactions, RecentTransactions, LocalSavingsGoals],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Opens a connection to the SQLite database using drift_flutter.
  ///
  /// This uses the application documents directory on mobile/desktop
  /// and appropriate storage on web.
  static DatabaseConnection _openConnection() {
    debugPrint("Drift database connection is created!!..");
    return driftDatabase(name: 'nova_pay');
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Creates the new LocalSavingsGoals table without deleting old transactions
          await m.createTable(localSavingsGoals); 
        }
      },
      beforeOpen: (details) async {
        // Enables foreign key constraints in SQLite
        await customStatement('PRAGMA foreign_keys = ON'); 
      },
    );
  }


  /// Inserts a new pending queue item.
  Future<String> addPendingQueueItem({
    required String actionType,
    required String payloadJson,
    required String idempotencyKey,
    String status = 'pending',
  }) async {
    final id = const Uuid().v4(); // Fallback if clientDefault doesn't trigger

    final companion = PendingQueueItemsCompanion(
      id: Value(id),
      actionType: Value(actionType),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      status: Value(status),
      createdAt: Value(DateTime.now()),
    );

    await into(pendingQueueItems).insert(companion);
    return id;
  }

  /// Updates the status of a pending queue item.
  Future<void> updatePendingQueueItemStatus(
    String id, {
    required String status,
    String? errorMessage,
  }) async {
    await (update(pendingQueueItems)..where((tbl) => tbl.id.equals(id))).write(
      PendingQueueItemsCompanion(
        status: Value(status),
        // Could add error field if table is extended later
      ),
    );
  }

  /// Convenience method using the strongly typed `TransactionStatus` enum.
  Future<void> updatePendingQueueItemStatusEnum(
    String id,
    TransactionStatus status,
  ) async {
    await updatePendingQueueItemStatus(id, status: status.value);
  }

  /// Deletes a pending queue item (e.g. after successful sync).
  Future<void> deletePendingQueueItem(String id) async {
    await (delete(pendingQueueItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Watches pending queue items (stream for UI reactivity).
  /// Ordered by creation time (oldest first). Uses TransactionStatus.pending.
  Stream<List<PendingQueueItem>> watchPendingQueueItems() {
    return (select(pendingQueueItems)
          ..where((tbl) => tbl.status.equals(TransactionStatus.pending.value))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// Gets all pending items as a future (for replay in SyncEngine).
  /// Only returns items with status == TransactionStatus.pending.
  Future<List<PendingQueueItem>> getAllPendingQueueItems() {
    return (select(pendingQueueItems)
          ..where((tbl) => tbl.status.equals(TransactionStatus.pending.value))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Basic CRUD for LocalTransactions.

  /// Inserts or updates a local transaction (upsert by id).
  Future<void> saveLocalTransaction({
    required String id,
    required int amountInKobo,
    required String type,
    required String title,
    required String status,
    DateTime? createdAt,
  }) async {
    final companion = LocalTransactionsCompanion(
      id: Value(id),
      amountInKobo: Value(BigInt.from(amountInKobo)),
      type: Value(type),
      title: Value(title),
      status: Value(status),
      createdAt: Value(createdAt ?? DateTime.now()),
    );

    await into(localTransactions).insertOnConflictUpdate(companion);
  }

  /// Watches all local transactions ordered by date (newest first).
  Stream<List<LocalTransaction>> watchLocalTransactions() {
    return (select(
      localTransactions,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Gets a specific transaction by ID.
  Future<LocalTransaction?> getLocalTransactionById(String id) {
    return (select(
      localTransactions,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Deletes old transactions (for cache management).
  Future<void> deleteOldTransactions(DateTime olderThan) async {
    await (delete(
      localTransactions,
    )..where((tbl) => tbl.createdAt.isSmallerThanValue(olderThan))).go();
  }

  /// --- RecentTransactions (User-Facing History) ---

  /// Inserts or updates a recent transaction (upsert by firebaseId).
  /// Used to cache transactions from Firestore for offline viewing.
  Future<void> saveRecentTransaction({
    required String id,
    required int amountInKobo,
    required String type,
    required String title,
    required String status,
    required String firebaseId,
    DateTime? createdAt,
  }) async {
    final companion = RecentTransactionsCompanion(
      id: Value(id),
      amountInKobo: Value(BigInt.from(amountInKobo)),
      type: Value(type),
      title: Value(title),
      status: Value(status),
      firebaseId: Value(firebaseId),
      createdAt: Value(createdAt ?? DateTime.now()),
    );

    await into(recentTransactions).insertOnConflictUpdate(companion);
  }

  /// Watches all recent transactions ordered by date (newest first).
  /// Returns a stream for real-time UI updates.
  Stream<List<RecentTransaction>> watchRecentTransactions() {
    return (select(
      recentTransactions,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Gets a specific recent transaction by ID.
  Future<RecentTransaction?> getRecentTransactionById(String id) {
    return (select(
      recentTransactions,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Deletes old recent transactions (for cache management).
  /// Keeps only recent transactions to avoid bloating the database.
  Future<void> deleteOldRecentTransactions(DateTime olderThan) async {
    await (delete(
      recentTransactions,
    )..where((tbl) => tbl.createdAt.isSmallerThanValue(olderThan))).go();
  }

  /// Clears all recent transactions (full cache reset).
  /// Used when user wants to force-refresh from Firestore.
  Future<void> clearRecentTransactions() async {
    await delete(recentTransactions).go();
  }

  /// --- LocalSavingsGoals (NovaSave Feature) ---

  /// Inserts or updates a savings goal (upsert by id).
  /// Used to cache savings goals from Firestore for offline viewing and management.
  Future<void> saveSavingsGoal({
    required String id,
    required String userId,
    required String name,
    required int targetAmountInKobo,
    required int currentAmountInKobo,
    required DateTime targetDate,
    DateTime? createdAt,
  }) async {
    final companion = LocalSavingsGoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      targetAmountInKobo: Value(BigInt.from(targetAmountInKobo)),
      currentAmountInKobo: Value(BigInt.from(currentAmountInKobo)),
      targetDate: Value(targetDate),
      createdAt: Value(createdAt ?? DateTime.now()),
    );

    await into(localSavingsGoals).insertOnConflictUpdate(companion);
  }

  /// Retrieves all savings goals for a specific user.
  /// Returns a stream for real-time UI updates.
  Stream<List<LocalSavingsGoal>> watchSavingsGoalsByUserId(String userId) {
    return (select(localSavingsGoals)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Retrieves all savings goals for a specific user as a Future.
  /// Useful for one-time data retrieval without streaming.
  Future<List<LocalSavingsGoal>> getSavingsGoalsByUserId(String userId) {
    return (select(localSavingsGoals)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Retrieves a specific savings goal by ID.
  Future<LocalSavingsGoal?> getSavingsGoalById(String id) {
    return (select(localSavingsGoals)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Updates the current amount for a savings goal.
  /// Useful for adding contributions to a goal without replacing the entire record.
  Future<void> updateSavingsGoalCurrentAmount(
    String id, {
    required int currentAmountInKobo,
  }) async {
    await (update(localSavingsGoals)..where((tbl) => tbl.id.equals(id))).write(
      LocalSavingsGoalsCompanion(
        currentAmountInKobo: Value(BigInt.from(currentAmountInKobo)),
      ),
    );
  }

  /// Deletes a savings goal by ID.
  /// Use with caution as this permanently removes the goal from local cache.
  Future<void> deleteSavingsGoal(String id) async {
    await (delete(localSavingsGoals)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Deletes all savings goals for a specific user.
  /// Useful for cache cleanup when user switches accounts.
  Future<void> deleteAllSavingsGoalsByUserId(String userId) async {
    await (delete(localSavingsGoals)..where((tbl) => tbl.userId.equals(userId)))
        .go();
  }

  /// Clears all savings goals (full cache reset).
  /// Used when user wants to force-refresh from Firestore.
  Future<void> clearAllSavingsGoals() async {
    await delete(localSavingsGoals).go();
  }
}

/// Riverpod provider for the AppDatabase instance using code generation.
///
/// The database is automatically closed when the provider is disposed.
/// Riverpod provider for the AppDatabase instance using code generation.
///
/// keepAlive: true ensures that the database is only created once and
/// persists across screen changes, page transitions, and hot restarts.
@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final database = AppDatabase();

  // Note: Since keepAlive is true, this will only run if the entire
  // ProviderContainer is wiped out (e.g. app shutdown).
  ref.onDispose(() async {
    await database.close();
  });

  return database;
}
