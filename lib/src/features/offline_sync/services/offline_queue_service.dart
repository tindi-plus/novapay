import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';

part 'offline_queue_service.g.dart';

/// Local Queue Service for enqueuing offline mutations atomically using Drift.
///
/// This service provides a clean abstraction over the pending queue table
/// for offline-first operations. Mutations are enqueued with idempotency
/// keys to ensure they are processed exactly once.
class OfflineQueueService {
  final AppDatabase _db;

  OfflineQueueService(this._db);

  /// Enqueues a transaction/mutation to be processed when online.
  ///
  /// Creates a `PendingQueueItemsCompanion` with status `TransactionStatus.pending`.
  /// Uses a database transaction for atomicity.
  /// Generates UUID v4 for the ID if not provided.
  ///
  /// Returns the ID of the enqueued item.
  /// The pending notification banner is handled by the SyncNotification provider
  /// (listened by UI). The message is shown when initially queued due to connectivity issues.
  Future<String> enqueueTransaction({
    required String actionType,
    required Map<String, dynamic> payload,
    required String idempotencyKey,
    String? id,
    TransactionStatus initialStatus = TransactionStatus.pending,
  }) async {
    final itemId = id ?? const Uuid().v4();
    final payloadJson = jsonEncode(payload);

    final companion = PendingQueueItemsCompanion(
      id: Value(itemId),
      actionType: Value(actionType),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      status: Value(initialStatus.value),
      createdAt: Value(DateTime.now()),
    );

    // Atomic insert to ensure the queue operation is reliable
    await _db.transaction(() async {
      await _db.into(_db.pendingQueueItems).insert(companion);
    });

    return itemId;
  }

  /// Returns a list of all queue items with `status == TransactionStatus.pending`
  /// (strictly for replay as per requirements). Failed items are not automatically replayed.
  Future<List<PendingQueueItem>> getPendingItems() {
    return (_db.select(_db.pendingQueueItems)
          ..where(
            (tbl) => tbl.status.equals(TransactionStatus.pending.value),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Updates the status of a queue item using strongly typed TransactionStatus.
  Future<void> updateItemStatus(String id, TransactionStatus status) async {
    await _db.updatePendingQueueItemStatus(
      id,
      status: status.value,
    );
  }

  /// Removes a processed item from the queue (after success).
  Future<void> deleteQueuedItem(String id) async {
    await _db.deletePendingQueueItem(id);
  }
}

/// Riverpod provider for OfflineQueueService using code generation.
@riverpod
OfflineQueueService offlineQueueService(Ref ref) {
  final database = ref.watch(databaseProvider);
  return OfflineQueueService(database);
}
