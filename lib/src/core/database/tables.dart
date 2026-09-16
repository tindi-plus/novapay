import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Strongly typed enum for transaction/queue status.
/// Stored as string in Drift (`status.value`) and mapped back using `fromString`.
enum TransactionStatus {
  pending,
  processing,
  success,
  failed;

  String get value => name;

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => TransactionStatus.failed,
    );
  }
}

/// Table for pending offline actions (queue for sync to backend).
class PendingQueueItems extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get actionType => text()();

  TextColumn get payloadJson => text()();

  TextColumn get idempotencyKey => text().unique()();

  /// Status is stored as string. Use `TransactionStatus` in business logic (SyncEngine, OfflineQueueService).
  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Table for locally cached transaction/ledger history.
class LocalTransactions extends Table {
  TextColumn get id => text()();

  Int64Column get amountInKobo => int64()();

  TextColumn get type => text()();

  TextColumn get title => text()();

  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

