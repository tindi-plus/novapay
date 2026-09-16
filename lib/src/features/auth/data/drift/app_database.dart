import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Drift table for caching user profiles locally
@DataClassName('CachedUserData')
class CachedUsers extends Table {
  /// User's Firebase UID (primary key)
  TextColumn get uid => text()();

  /// User's email address
  TextColumn get email => text()();

  /// Unique 10-digit account number
  TextColumn get accountNumber => text()();

  /// User's first name
  TextColumn get firstName => text()();

  /// User's middle name (nullable)
  TextColumn get middleName => text().nullable()();

  /// User's last name
  TextColumn get lastName => text()();

  /// Bank Verification Number
  TextColumn get bvn => text()();

  /// National Identification Number
  TextColumn get nin => text()();

  /// User's phone number
  TextColumn get phoneNumber => text()();

  /// Last update timestamp (ISO 8601 string)
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {uid};
}
/// Offline queue table for durable transaction processing.
/// Satisfies: offline-first, survives crashes/restarts/device restarts, exactly-once replay.
/// Fields per spec. Unique on transactionId and idempotencyKey. Indexes for performance.
@DataClassName('QueuedTransaction')
class QueuedTransactions extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get transactionId => text().unique()();
  TextColumn get senderUid => text()();
  TextColumn get recipientUid => text()();
  IntColumn get amountKobo => integer()();
  TextColumn get idempotencyKey => text().unique()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {localId};

  @override
  List<String> get customConstraints => [
        'UNIQUE(transactionId)',
        'UNIQUE(idempotencyKey)',
      ];
}


/// Drift database instance
@DriftDatabase(tables: [CachedUsers, QueuedTransactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  /// Inserts or replaces a cached user
  Future<void> cacheUser({
    required String uid,
    required String email,
    required String accountNumber,
    required String firstName,
    String? middleName,
    required String lastName,
    required String bvn,
    required String nin,
    required String phoneNumber,
    required String updatedAt,
  }) async {
    await into(cachedUsers).insertOnConflictUpdate(
      CachedUsersCompanion(
        uid: Value(uid),
        email: Value(email),
        accountNumber: Value(accountNumber),
        firstName: Value(firstName),
        middleName: Value(middleName),
        lastName: Value(lastName),
        bvn: Value(bvn),
        nin: Value(nin),
        phoneNumber: Value(phoneNumber),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  /// Retrieves a cached user by UID
  Future<CachedUserData?> getCachedUser(String uid) async {
    final result = await (select(cachedUsers)..where((u) => u.uid.equals(uid)))
        .getSingleOrNull();
    return result;
  }

  /// Clears all cached users
  Future<void> clearAllCachedUsers() async {
    await delete(cachedUsers).go();
  }

  /// Clears a specific cached user
  Future<void> clearCachedUser(String uid) async {
    await (delete(cachedUsers)..where((u) => u.uid.equals(uid))).go();
  }

  /// Gets all cached users
  Future<List<CachedUserData>> getAllCachedUsers() async {
    return await select(cachedUsers).get();
  }

  // === Offline Queue Methods (for Send Money durable queue) ===
  /// Adds a transaction to the durable queue (pending/queued status).
  /// Generates idempotencyKey client-side before enqueue.
  Future<int> enqueueTransaction({
    required String transactionId,
    required String senderUid,
    required String recipientUid,
    required int amountKobo,
    required String idempotencyKey,
    String status = 'queued',
  }) async {
    final entry = QueuedTransactionsCompanion.insert(
      transactionId: transactionId,
      senderUid: senderUid,
      recipientUid: recipientUid,
      amountKobo: amountKobo,
      idempotencyKey: idempotencyKey,
      status: Value(status),
      retryCount: const Value(0),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    final id = await into(queuedTransactions).insert(entry);
    return id;
  }

  /// Loads queued items for replay (pending or failed with retryCount=0).
  /// Sequential processing guaranteed by caller.
  Future<List<QueuedTransaction>> loadPendingTransactions() async {
    return (select(queuedTransactions)
          ..where((t) =>
              t.status.equals('pending') |
              t.status.equals('queued') |
              (t.status.equals('failed') & t.retryCount.equals(0)))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Updates queue status and retryCount. Enforces retryCount <=1 for exactly-once.
  Future<void> updateQueueStatus({
    required String transactionId,
    required String status,
    String? lastError,
    int retryCount = 1,
  }) async {
    await (update(queuedTransactions)..where((t) => t.transactionId.equals(transactionId)))
        .write(QueuedTransactionsCompanion(
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError != null ? Value(lastError) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> markAsCompleted(String transactionId) async {
    await updateQueueStatus(
      transactionId: transactionId,
      status: 'completed',
    );
  }

  Future<void> markAsFailed(String transactionId, String reason) async {
    await updateQueueStatus(
      transactionId: transactionId,
      status: 'failed',
      lastError: reason,
    );
  }

  /// Cleanup for scalability.
  Future<void> deleteCompletedTransactions() async {
    await (delete(queuedTransactions)..where((t) => t.status.equals('completed'))).go();
  }

  Future<QueuedTransaction?> getQueueItemByIdempotency(String idempotencyKey) async {
    return (select(queuedTransactions)
          ..where((t) => t.idempotencyKey.equals(idempotencyKey)))
        .getSingleOrNull();
  }

  }

  /// Opens a connection to the Drift database (shared for all features).
  QueryExecutor _openConnection() {
    return driftDatabase(name: 'novapay_app_db');
  }
