import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The main database class for the NovaPay app using Drift (SQLite).
///
/// This provides offline persistence for:
/// - A pending action queue (for offline-first sync to backend)
/// - Local cached transaction history (ledger)
@DriftDatabase(tables: [PendingQueueItems, LocalTransactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Opens a connection to the SQLite database using drift_flutter.
  ///
  /// This uses the application documents directory on mobile/desktop
  /// and appropriate storage on web.
  static DatabaseConnection _openConnection() {
    return driftDatabase(name: 'nova_pay');
  }

  @override
  int get schemaVersion => 1;

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
    await (update(pendingQueueItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
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
    return (select(localTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Gets a specific transaction by ID.
  Future<LocalTransaction?> getLocalTransactionById(String id) {
    return (select(localTransactions)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Deletes old transactions (for cache management).
  Future<void> deleteOldTransactions(DateTime olderThan) async {
    await (delete(localTransactions)
          ..where((tbl) => tbl.createdAt.isSmallerThanValue(olderThan)))
        .go();
  }
}

/// Riverpod provider for the AppDatabase instance using code generation.
///
/// The database is automatically closed when the provider is disposed.
@riverpod
AppDatabase database(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
}

