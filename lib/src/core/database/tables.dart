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

/// Table for recently viewed transaction history (user-facing ledger).
/// Separate from LocalTransactions which is for sync queue management.
/// These are cached from Firestore `users/{uid}/transactions` sub-collection
/// and support offline viewing.
class RecentTransactions extends Table {
  /// Firestore document ID
  TextColumn get id => text()();

  /// Amount stored in kobo (e.g., 20000 = ₦200.00)
  Int64Column get amountInKobo => int64()();

  /// Transaction type: 'debit', 'credit', 'savings_contribution'
  TextColumn get type => text()();

  /// Transaction title/description (e.g., "Payment to John", "Salary Deposit")
  TextColumn get title => text()();

  /// Transaction status: 'completed', 'pending', 'failed'
  TextColumn get status => text()();

  /// When the transaction was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Unique Firestore document ID for deduplication
  TextColumn get firebaseId => text().unique()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Table for locally cached savings goals (NovaSave feature).
/// These are cached from Firestore `users/{uid}/savingsGoals` sub-collection
/// and support offline viewing and management.
class LocalSavingsGoals extends Table {
  /// Unique identifier for the savings goal (Firestore document ID or UUID)
  TextColumn get id => text()();

  /// User ID who owns this savings goal
  TextColumn get userId => text()();

  /// Goal name (e.g., "Emergency Fund", "Vacation Fund")
  TextColumn get name => text()();

  /// Target amount stored in kobo (64-bit int, e.g., 5000000 = ₦50,000.00)
  Int64Column get targetAmountInKobo => int64()();

  /// Current saved amount in kobo (64-bit int, e.g., 1250000 = ₦12,500.00)
  Int64Column get currentAmountInKobo => int64()();

  /// Target date for achieving the goal
  DateTimeColumn get targetDate => dateTime()();

  /// When the savings goal was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

