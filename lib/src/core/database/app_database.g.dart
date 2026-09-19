// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PendingQueueItemsTable extends PendingQueueItems
    with TableInfo<$PendingQueueItemsTable, PendingQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actionType,
    payloadJson,
    idempotencyKey,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingQueueItemsTable createAlias(String alias) {
    return $PendingQueueItemsTable(attachedDatabase, alias);
  }
}

class PendingQueueItem extends DataClass
    implements Insertable<PendingQueueItem> {
  final String id;
  final String actionType;
  final String payloadJson;
  final String idempotencyKey;

  /// Status is stored as string. Use `TransactionStatus` in business logic (SyncEngine, OfflineQueueService).
  final String status;
  final DateTime createdAt;
  const PendingQueueItem({
    required this.id,
    required this.actionType,
    required this.payloadJson,
    required this.idempotencyKey,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['action_type'] = Variable<String>(actionType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return PendingQueueItemsCompanion(
      id: Value(id),
      actionType: Value(actionType),
      payloadJson: Value(payloadJson),
      idempotencyKey: Value(idempotencyKey),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory PendingQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingQueueItem(
      id: serializer.fromJson<String>(json['id']),
      actionType: serializer.fromJson<String>(json['actionType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actionType': serializer.toJson<String>(actionType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingQueueItem copyWith({
    String? id,
    String? actionType,
    String? payloadJson,
    String? idempotencyKey,
    String? status,
    DateTime? createdAt,
  }) => PendingQueueItem(
    id: id ?? this.id,
    actionType: actionType ?? this.actionType,
    payloadJson: payloadJson ?? this.payloadJson,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingQueueItem copyWithCompanion(PendingQueueItemsCompanion data) {
    return PendingQueueItem(
      id: data.id.present ? data.id.value : this.id,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingQueueItem(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    actionType,
    payloadJson,
    idempotencyKey,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingQueueItem &&
          other.id == this.id &&
          other.actionType == this.actionType &&
          other.payloadJson == this.payloadJson &&
          other.idempotencyKey == this.idempotencyKey &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class PendingQueueItemsCompanion extends UpdateCompanion<PendingQueueItem> {
  final Value<String> id;
  final Value<String> actionType;
  final Value<String> payloadJson;
  final Value<String> idempotencyKey;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingQueueItemsCompanion({
    this.id = const Value.absent(),
    this.actionType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String actionType,
    required String payloadJson,
    required String idempotencyKey,
    required String status,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : actionType = Value(actionType),
       payloadJson = Value(payloadJson),
       idempotencyKey = Value(idempotencyKey),
       status = Value(status);
  static Insertable<PendingQueueItem> custom({
    Expression<String>? id,
    Expression<String>? actionType,
    Expression<String>? payloadJson,
    Expression<String>? idempotencyKey,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actionType != null) 'action_type': actionType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingQueueItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? actionType,
    Value<String>? payloadJson,
    Value<String>? idempotencyKey,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingQueueItemsCompanion(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      payloadJson: payloadJson ?? this.payloadJson,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('actionType: $actionType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTransactionsTable extends LocalTransactions
    with TableInfo<$LocalTransactionsTable, LocalTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInKoboMeta = const VerificationMeta(
    'amountInKobo',
  );
  @override
  late final GeneratedColumn<BigInt> amountInKobo = GeneratedColumn<BigInt>(
    'amount_in_kobo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountInKobo,
    type,
    title,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_in_kobo')) {
      context.handle(
        _amountInKoboMeta,
        amountInKobo.isAcceptableOrUnknown(
          data['amount_in_kobo']!,
          _amountInKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInKoboMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amountInKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}amount_in_kobo'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalTransactionsTable createAlias(String alias) {
    return $LocalTransactionsTable(attachedDatabase, alias);
  }
}

class LocalTransaction extends DataClass
    implements Insertable<LocalTransaction> {
  final String id;
  final BigInt amountInKobo;
  final String type;
  final String title;
  final String status;
  final DateTime createdAt;
  const LocalTransaction({
    required this.id,
    required this.amountInKobo,
    required this.type,
    required this.title,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_in_kobo'] = Variable<BigInt>(amountInKobo);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalTransactionsCompanion toCompanion(bool nullToAbsent) {
    return LocalTransactionsCompanion(
      id: Value(id),
      amountInKobo: Value(amountInKobo),
      type: Value(type),
      title: Value(title),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory LocalTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransaction(
      id: serializer.fromJson<String>(json['id']),
      amountInKobo: serializer.fromJson<BigInt>(json['amountInKobo']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountInKobo': serializer.toJson<BigInt>(amountInKobo),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalTransaction copyWith({
    String? id,
    BigInt? amountInKobo,
    String? type,
    String? title,
    String? status,
    DateTime? createdAt,
  }) => LocalTransaction(
    id: id ?? this.id,
    amountInKobo: amountInKobo ?? this.amountInKobo,
    type: type ?? this.type,
    title: title ?? this.title,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalTransaction copyWithCompanion(LocalTransactionsCompanion data) {
    return LocalTransaction(
      id: data.id.present ? data.id.value : this.id,
      amountInKobo: data.amountInKobo.present
          ? data.amountInKobo.value
          : this.amountInKobo,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransaction(')
          ..write('id: $id, ')
          ..write('amountInKobo: $amountInKobo, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, amountInKobo, type, title, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransaction &&
          other.id == this.id &&
          other.amountInKobo == this.amountInKobo &&
          other.type == this.type &&
          other.title == this.title &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class LocalTransactionsCompanion extends UpdateCompanion<LocalTransaction> {
  final Value<String> id;
  final Value<BigInt> amountInKobo;
  final Value<String> type;
  final Value<String> title;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalTransactionsCompanion({
    this.id = const Value.absent(),
    this.amountInKobo = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTransactionsCompanion.insert({
    required String id,
    required BigInt amountInKobo,
    required String type,
    required String title,
    required String status,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountInKobo = Value(amountInKobo),
       type = Value(type),
       title = Value(title),
       status = Value(status);
  static Insertable<LocalTransaction> custom({
    Expression<String>? id,
    Expression<BigInt>? amountInKobo,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountInKobo != null) 'amount_in_kobo': amountInKobo,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTransactionsCompanion copyWith({
    Value<String>? id,
    Value<BigInt>? amountInKobo,
    Value<String>? type,
    Value<String>? title,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalTransactionsCompanion(
      id: id ?? this.id,
      amountInKobo: amountInKobo ?? this.amountInKobo,
      type: type ?? this.type,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountInKobo.present) {
      map['amount_in_kobo'] = Variable<BigInt>(amountInKobo.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountInKobo: $amountInKobo, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentTransactionsTable extends RecentTransactions
    with TableInfo<$RecentTransactionsTable, RecentTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInKoboMeta = const VerificationMeta(
    'amountInKobo',
  );
  @override
  late final GeneratedColumn<BigInt> amountInKobo = GeneratedColumn<BigInt>(
    'amount_in_kobo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _firebaseIdMeta = const VerificationMeta(
    'firebaseId',
  );
  @override
  late final GeneratedColumn<String> firebaseId = GeneratedColumn<String>(
    'firebase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountInKobo,
    type,
    title,
    status,
    createdAt,
    firebaseId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_in_kobo')) {
      context.handle(
        _amountInKoboMeta,
        amountInKobo.isAcceptableOrUnknown(
          data['amount_in_kobo']!,
          _amountInKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInKoboMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('firebase_id')) {
      context.handle(
        _firebaseIdMeta,
        firebaseId.isAcceptableOrUnknown(data['firebase_id']!, _firebaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_firebaseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amountInKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}amount_in_kobo'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      firebaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firebase_id'],
      )!,
    );
  }

  @override
  $RecentTransactionsTable createAlias(String alias) {
    return $RecentTransactionsTable(attachedDatabase, alias);
  }
}

class RecentTransaction extends DataClass
    implements Insertable<RecentTransaction> {
  /// Firestore document ID
  final String id;

  /// Amount stored in kobo (e.g., 20000 = ₦200.00)
  final BigInt amountInKobo;

  /// Transaction type: 'debit', 'credit', 'savings_contribution'
  final String type;

  /// Transaction title/description (e.g., "Payment to John", "Salary Deposit")
  final String title;

  /// Transaction status: 'completed', 'pending', 'failed'
  final String status;

  /// When the transaction was created
  final DateTime createdAt;

  /// Unique Firestore document ID for deduplication
  final String firebaseId;
  const RecentTransaction({
    required this.id,
    required this.amountInKobo,
    required this.type,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.firebaseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_in_kobo'] = Variable<BigInt>(amountInKobo);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['firebase_id'] = Variable<String>(firebaseId);
    return map;
  }

  RecentTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecentTransactionsCompanion(
      id: Value(id),
      amountInKobo: Value(amountInKobo),
      type: Value(type),
      title: Value(title),
      status: Value(status),
      createdAt: Value(createdAt),
      firebaseId: Value(firebaseId),
    );
  }

  factory RecentTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentTransaction(
      id: serializer.fromJson<String>(json['id']),
      amountInKobo: serializer.fromJson<BigInt>(json['amountInKobo']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      firebaseId: serializer.fromJson<String>(json['firebaseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountInKobo': serializer.toJson<BigInt>(amountInKobo),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'firebaseId': serializer.toJson<String>(firebaseId),
    };
  }

  RecentTransaction copyWith({
    String? id,
    BigInt? amountInKobo,
    String? type,
    String? title,
    String? status,
    DateTime? createdAt,
    String? firebaseId,
  }) => RecentTransaction(
    id: id ?? this.id,
    amountInKobo: amountInKobo ?? this.amountInKobo,
    type: type ?? this.type,
    title: title ?? this.title,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    firebaseId: firebaseId ?? this.firebaseId,
  );
  RecentTransaction copyWithCompanion(RecentTransactionsCompanion data) {
    return RecentTransaction(
      id: data.id.present ? data.id.value : this.id,
      amountInKobo: data.amountInKobo.present
          ? data.amountInKobo.value
          : this.amountInKobo,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      firebaseId: data.firebaseId.present
          ? data.firebaseId.value
          : this.firebaseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentTransaction(')
          ..write('id: $id, ')
          ..write('amountInKobo: $amountInKobo, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('firebaseId: $firebaseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, amountInKobo, type, title, status, createdAt, firebaseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentTransaction &&
          other.id == this.id &&
          other.amountInKobo == this.amountInKobo &&
          other.type == this.type &&
          other.title == this.title &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.firebaseId == this.firebaseId);
}

class RecentTransactionsCompanion extends UpdateCompanion<RecentTransaction> {
  final Value<String> id;
  final Value<BigInt> amountInKobo;
  final Value<String> type;
  final Value<String> title;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String> firebaseId;
  final Value<int> rowid;
  const RecentTransactionsCompanion({
    this.id = const Value.absent(),
    this.amountInKobo = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.firebaseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentTransactionsCompanion.insert({
    required String id,
    required BigInt amountInKobo,
    required String type,
    required String title,
    required String status,
    this.createdAt = const Value.absent(),
    required String firebaseId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountInKobo = Value(amountInKobo),
       type = Value(type),
       title = Value(title),
       status = Value(status),
       firebaseId = Value(firebaseId);
  static Insertable<RecentTransaction> custom({
    Expression<String>? id,
    Expression<BigInt>? amountInKobo,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? firebaseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountInKobo != null) 'amount_in_kobo': amountInKobo,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (firebaseId != null) 'firebase_id': firebaseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentTransactionsCompanion copyWith({
    Value<String>? id,
    Value<BigInt>? amountInKobo,
    Value<String>? type,
    Value<String>? title,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String>? firebaseId,
    Value<int>? rowid,
  }) {
    return RecentTransactionsCompanion(
      id: id ?? this.id,
      amountInKobo: amountInKobo ?? this.amountInKobo,
      type: type ?? this.type,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      firebaseId: firebaseId ?? this.firebaseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountInKobo.present) {
      map['amount_in_kobo'] = Variable<BigInt>(amountInKobo.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (firebaseId.present) {
      map['firebase_id'] = Variable<String>(firebaseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amountInKobo: $amountInKobo, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('firebaseId: $firebaseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSavingsGoalsTable extends LocalSavingsGoals
    with TableInfo<$LocalSavingsGoalsTable, LocalSavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountInKoboMeta =
      const VerificationMeta('targetAmountInKobo');
  @override
  late final GeneratedColumn<BigInt> targetAmountInKobo =
      GeneratedColumn<BigInt>(
        'target_amount_in_kobo',
        aliasedName,
        false,
        type: DriftSqlType.bigInt,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _currentAmountInKoboMeta =
      const VerificationMeta('currentAmountInKobo');
  @override
  late final GeneratedColumn<BigInt> currentAmountInKobo =
      GeneratedColumn<BigInt>(
        'current_amount_in_kobo',
        aliasedName,
        false,
        type: DriftSqlType.bigInt,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    targetAmountInKobo,
    currentAmountInKobo,
    targetDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount_in_kobo')) {
      context.handle(
        _targetAmountInKoboMeta,
        targetAmountInKobo.isAcceptableOrUnknown(
          data['target_amount_in_kobo']!,
          _targetAmountInKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountInKoboMeta);
    }
    if (data.containsKey('current_amount_in_kobo')) {
      context.handle(
        _currentAmountInKoboMeta,
        currentAmountInKobo.isAcceptableOrUnknown(
          data['current_amount_in_kobo']!,
          _currentAmountInKoboMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentAmountInKoboMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmountInKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}target_amount_in_kobo'],
      )!,
      currentAmountInKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}current_amount_in_kobo'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalSavingsGoalsTable createAlias(String alias) {
    return $LocalSavingsGoalsTable(attachedDatabase, alias);
  }
}

class LocalSavingsGoal extends DataClass
    implements Insertable<LocalSavingsGoal> {
  /// Unique identifier for the savings goal (Firestore document ID or UUID)
  final String id;

  /// User ID who owns this savings goal
  final String userId;

  /// Goal name (e.g., "Emergency Fund", "Vacation Fund")
  final String name;

  /// Target amount stored in kobo (64-bit int, e.g., 5000000 = ₦50,000.00)
  final BigInt targetAmountInKobo;

  /// Current saved amount in kobo (64-bit int, e.g., 1250000 = ₦12,500.00)
  final BigInt currentAmountInKobo;

  /// Target date for achieving the goal
  final DateTime targetDate;

  /// When the savings goal was created
  final DateTime createdAt;
  const LocalSavingsGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmountInKobo,
    required this.currentAmountInKobo,
    required this.targetDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['target_amount_in_kobo'] = Variable<BigInt>(targetAmountInKobo);
    map['current_amount_in_kobo'] = Variable<BigInt>(currentAmountInKobo);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalSavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return LocalSavingsGoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      targetAmountInKobo: Value(targetAmountInKobo),
      currentAmountInKobo: Value(currentAmountInKobo),
      targetDate: Value(targetDate),
      createdAt: Value(createdAt),
    );
  }

  factory LocalSavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSavingsGoal(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      targetAmountInKobo: serializer.fromJson<BigInt>(
        json['targetAmountInKobo'],
      ),
      currentAmountInKobo: serializer.fromJson<BigInt>(
        json['currentAmountInKobo'],
      ),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'targetAmountInKobo': serializer.toJson<BigInt>(targetAmountInKobo),
      'currentAmountInKobo': serializer.toJson<BigInt>(currentAmountInKobo),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalSavingsGoal copyWith({
    String? id,
    String? userId,
    String? name,
    BigInt? targetAmountInKobo,
    BigInt? currentAmountInKobo,
    DateTime? targetDate,
    DateTime? createdAt,
  }) => LocalSavingsGoal(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    targetAmountInKobo: targetAmountInKobo ?? this.targetAmountInKobo,
    currentAmountInKobo: currentAmountInKobo ?? this.currentAmountInKobo,
    targetDate: targetDate ?? this.targetDate,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalSavingsGoal copyWithCompanion(LocalSavingsGoalsCompanion data) {
    return LocalSavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      targetAmountInKobo: data.targetAmountInKobo.present
          ? data.targetAmountInKobo.value
          : this.targetAmountInKobo,
      currentAmountInKobo: data.currentAmountInKobo.present
          ? data.currentAmountInKobo.value
          : this.currentAmountInKobo,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSavingsGoal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('targetAmountInKobo: $targetAmountInKobo, ')
          ..write('currentAmountInKobo: $currentAmountInKobo, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    targetAmountInKobo,
    currentAmountInKobo,
    targetDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSavingsGoal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.targetAmountInKobo == this.targetAmountInKobo &&
          other.currentAmountInKobo == this.currentAmountInKobo &&
          other.targetDate == this.targetDate &&
          other.createdAt == this.createdAt);
}

class LocalSavingsGoalsCompanion extends UpdateCompanion<LocalSavingsGoal> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<BigInt> targetAmountInKobo;
  final Value<BigInt> currentAmountInKobo;
  final Value<DateTime> targetDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalSavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmountInKobo = const Value.absent(),
    this.currentAmountInKobo = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSavingsGoalsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required BigInt targetAmountInKobo,
    required BigInt currentAmountInKobo,
    required DateTime targetDate,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       targetAmountInKobo = Value(targetAmountInKobo),
       currentAmountInKobo = Value(currentAmountInKobo),
       targetDate = Value(targetDate);
  static Insertable<LocalSavingsGoal> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<BigInt>? targetAmountInKobo,
    Expression<BigInt>? currentAmountInKobo,
    Expression<DateTime>? targetDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (targetAmountInKobo != null)
        'target_amount_in_kobo': targetAmountInKobo,
      if (currentAmountInKobo != null)
        'current_amount_in_kobo': currentAmountInKobo,
      if (targetDate != null) 'target_date': targetDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSavingsGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<BigInt>? targetAmountInKobo,
    Value<BigInt>? currentAmountInKobo,
    Value<DateTime>? targetDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalSavingsGoalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmountInKobo: targetAmountInKobo ?? this.targetAmountInKobo,
      currentAmountInKobo: currentAmountInKobo ?? this.currentAmountInKobo,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmountInKobo.present) {
      map['target_amount_in_kobo'] = Variable<BigInt>(targetAmountInKobo.value);
    }
    if (currentAmountInKobo.present) {
      map['current_amount_in_kobo'] = Variable<BigInt>(
        currentAmountInKobo.value,
      );
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('targetAmountInKobo: $targetAmountInKobo, ')
          ..write('currentAmountInKobo: $currentAmountInKobo, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PendingQueueItemsTable pendingQueueItems =
      $PendingQueueItemsTable(this);
  late final $LocalTransactionsTable localTransactions =
      $LocalTransactionsTable(this);
  late final $RecentTransactionsTable recentTransactions =
      $RecentTransactionsTable(this);
  late final $LocalSavingsGoalsTable localSavingsGoals =
      $LocalSavingsGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pendingQueueItems,
    localTransactions,
    recentTransactions,
    localSavingsGoals,
  ];
}

typedef $$PendingQueueItemsTableCreateCompanionBuilder =
    PendingQueueItemsCompanion Function({
      Value<String> id,
      required String actionType,
      required String payloadJson,
      required String idempotencyKey,
      required String status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PendingQueueItemsTableUpdateCompanionBuilder =
    PendingQueueItemsCompanion Function({
      Value<String> id,
      Value<String> actionType,
      Value<String> payloadJson,
      Value<String> idempotencyKey,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingQueueItemsTable> {
  $$PendingQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingQueueItemsTable> {
  $$PendingQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingQueueItemsTable> {
  $$PendingQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingQueueItemsTable,
          PendingQueueItem,
          $$PendingQueueItemsTableFilterComposer,
          $$PendingQueueItemsTableOrderingComposer,
          $$PendingQueueItemsTableAnnotationComposer,
          $$PendingQueueItemsTableCreateCompanionBuilder,
          $$PendingQueueItemsTableUpdateCompanionBuilder,
          (
            PendingQueueItem,
            BaseReferences<
              _$AppDatabase,
              $PendingQueueItemsTable,
              PendingQueueItem
            >,
          ),
          PendingQueueItem,
          PrefetchHooks Function()
        > {
  $$PendingQueueItemsTableTableManager(
    _$AppDatabase db,
    $PendingQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingQueueItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingQueueItemsCompanion(
                id: id,
                actionType: actionType,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String actionType,
                required String payloadJson,
                required String idempotencyKey,
                required String status,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingQueueItemsCompanion.insert(
                id: id,
                actionType: actionType,
                payloadJson: payloadJson,
                idempotencyKey: idempotencyKey,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingQueueItemsTable, PendingQueueItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingQueueItemsTable,
                    PendingQueueItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingQueueItemsTable,
      PendingQueueItem,
      $$PendingQueueItemsTableFilterComposer,
      $$PendingQueueItemsTableOrderingComposer,
      $$PendingQueueItemsTableAnnotationComposer,
      $$PendingQueueItemsTableCreateCompanionBuilder,
      $$PendingQueueItemsTableUpdateCompanionBuilder,
      (
        PendingQueueItem,
        BaseReferences<
          _$AppDatabase,
          $PendingQueueItemsTable,
          PendingQueueItem
        >,
      ),
      PendingQueueItem,
      PrefetchHooks Function()
    >;
typedef $$LocalTransactionsTableCreateCompanionBuilder =
    LocalTransactionsCompanion Function({
      required String id,
      required BigInt amountInKobo,
      required String type,
      required String title,
      required String status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalTransactionsTableUpdateCompanionBuilder =
    LocalTransactionsCompanion Function({
      Value<String> id,
      Value<BigInt> amountInKobo,
      Value<String> type,
      Value<String> title,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get amountInKobo => $composableBuilder(
    column: $table.amountInKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get amountInKobo => $composableBuilder(
    column: $table.amountInKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<BigInt> get amountInKobo => $composableBuilder(
    column: $table.amountInKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTransactionsTable,
          LocalTransaction,
          $$LocalTransactionsTableFilterComposer,
          $$LocalTransactionsTableOrderingComposer,
          $$LocalTransactionsTableAnnotationComposer,
          $$LocalTransactionsTableCreateCompanionBuilder,
          $$LocalTransactionsTableUpdateCompanionBuilder,
          (
            LocalTransaction,
            BaseReferences<
              _$AppDatabase,
              $LocalTransactionsTable,
              LocalTransaction
            >,
          ),
          LocalTransaction,
          PrefetchHooks Function()
        > {
  $$LocalTransactionsTableTableManager(
    _$AppDatabase db,
    $LocalTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<BigInt> amountInKobo = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransactionsCompanion(
                id: id,
                amountInKobo: amountInKobo,
                type: type,
                title: title,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required BigInt amountInKobo,
                required String type,
                required String title,
                required String status,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransactionsCompanion.insert(
                id: id,
                amountInKobo: amountInKobo,
                type: type,
                title: title,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalTransactionsTable, LocalTransaction>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalTransactionsTable,
                    LocalTransaction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTransactionsTable,
      LocalTransaction,
      $$LocalTransactionsTableFilterComposer,
      $$LocalTransactionsTableOrderingComposer,
      $$LocalTransactionsTableAnnotationComposer,
      $$LocalTransactionsTableCreateCompanionBuilder,
      $$LocalTransactionsTableUpdateCompanionBuilder,
      (
        LocalTransaction,
        BaseReferences<
          _$AppDatabase,
          $LocalTransactionsTable,
          LocalTransaction
        >,
      ),
      LocalTransaction,
      PrefetchHooks Function()
    >;
typedef $$RecentTransactionsTableCreateCompanionBuilder =
    RecentTransactionsCompanion Function({
      required String id,
      required BigInt amountInKobo,
      required String type,
      required String title,
      required String status,
      Value<DateTime> createdAt,
      required String firebaseId,
      Value<int> rowid,
    });
typedef $$RecentTransactionsTableUpdateCompanionBuilder =
    RecentTransactionsCompanion Function({
      Value<String> id,
      Value<BigInt> amountInKobo,
      Value<String> type,
      Value<String> title,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String> firebaseId,
      Value<int> rowid,
    });

class $$RecentTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecentTransactionsTable> {
  $$RecentTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get amountInKobo => $composableBuilder(
    column: $table.amountInKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firebaseId => $composableBuilder(
    column: $table.firebaseId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentTransactionsTable> {
  $$RecentTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get amountInKobo => $composableBuilder(
    column: $table.amountInKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firebaseId => $composableBuilder(
    column: $table.firebaseId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentTransactionsTable> {
  $$RecentTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<BigInt> get amountInKobo => $composableBuilder(
    column: $table.amountInKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get firebaseId => $composableBuilder(
    column: $table.firebaseId,
    builder: (column) => column,
  );
}

class $$RecentTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentTransactionsTable,
          RecentTransaction,
          $$RecentTransactionsTableFilterComposer,
          $$RecentTransactionsTableOrderingComposer,
          $$RecentTransactionsTableAnnotationComposer,
          $$RecentTransactionsTableCreateCompanionBuilder,
          $$RecentTransactionsTableUpdateCompanionBuilder,
          (
            RecentTransaction,
            BaseReferences<
              _$AppDatabase,
              $RecentTransactionsTable,
              RecentTransaction
            >,
          ),
          RecentTransaction,
          PrefetchHooks Function()
        > {
  $$RecentTransactionsTableTableManager(
    _$AppDatabase db,
    $RecentTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<BigInt> amountInKobo = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> firebaseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentTransactionsCompanion(
                id: id,
                amountInKobo: amountInKobo,
                type: type,
                title: title,
                status: status,
                createdAt: createdAt,
                firebaseId: firebaseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required BigInt amountInKobo,
                required String type,
                required String title,
                required String status,
                Value<DateTime> createdAt = const Value.absent(),
                required String firebaseId,
                Value<int> rowid = const Value.absent(),
              }) => RecentTransactionsCompanion.insert(
                id: id,
                amountInKobo: amountInKobo,
                type: type,
                title: title,
                status: status,
                createdAt: createdAt,
                firebaseId: firebaseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecentTransactionsTable, RecentTransaction>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $RecentTransactionsTable,
                    RecentTransaction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentTransactionsTable,
      RecentTransaction,
      $$RecentTransactionsTableFilterComposer,
      $$RecentTransactionsTableOrderingComposer,
      $$RecentTransactionsTableAnnotationComposer,
      $$RecentTransactionsTableCreateCompanionBuilder,
      $$RecentTransactionsTableUpdateCompanionBuilder,
      (
        RecentTransaction,
        BaseReferences<
          _$AppDatabase,
          $RecentTransactionsTable,
          RecentTransaction
        >,
      ),
      RecentTransaction,
      PrefetchHooks Function()
    >;
typedef $$LocalSavingsGoalsTableCreateCompanionBuilder =
    LocalSavingsGoalsCompanion Function({
      required String id,
      required String userId,
      required String name,
      required BigInt targetAmountInKobo,
      required BigInt currentAmountInKobo,
      required DateTime targetDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalSavingsGoalsTableUpdateCompanionBuilder =
    LocalSavingsGoalsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<BigInt> targetAmountInKobo,
      Value<BigInt> currentAmountInKobo,
      Value<DateTime> targetDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalSavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSavingsGoalsTable> {
  $$LocalSavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get targetAmountInKobo => $composableBuilder(
    column: $table.targetAmountInKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<BigInt> get currentAmountInKobo => $composableBuilder(
    column: $table.currentAmountInKobo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSavingsGoalsTable> {
  $$LocalSavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get targetAmountInKobo => $composableBuilder(
    column: $table.targetAmountInKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<BigInt> get currentAmountInKobo => $composableBuilder(
    column: $table.currentAmountInKobo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSavingsGoalsTable> {
  $$LocalSavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<BigInt> get targetAmountInKobo => $composableBuilder(
    column: $table.targetAmountInKobo,
    builder: (column) => column,
  );

  GeneratedColumn<BigInt> get currentAmountInKobo => $composableBuilder(
    column: $table.currentAmountInKobo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalSavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSavingsGoalsTable,
          LocalSavingsGoal,
          $$LocalSavingsGoalsTableFilterComposer,
          $$LocalSavingsGoalsTableOrderingComposer,
          $$LocalSavingsGoalsTableAnnotationComposer,
          $$LocalSavingsGoalsTableCreateCompanionBuilder,
          $$LocalSavingsGoalsTableUpdateCompanionBuilder,
          (
            LocalSavingsGoal,
            BaseReferences<
              _$AppDatabase,
              $LocalSavingsGoalsTable,
              LocalSavingsGoal
            >,
          ),
          LocalSavingsGoal,
          PrefetchHooks Function()
        > {
  $$LocalSavingsGoalsTableTableManager(
    _$AppDatabase db,
    $LocalSavingsGoalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSavingsGoalsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<BigInt> targetAmountInKobo = const Value.absent(),
                Value<BigInt> currentAmountInKobo = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSavingsGoalsCompanion(
                id: id,
                userId: userId,
                name: name,
                targetAmountInKobo: targetAmountInKobo,
                currentAmountInKobo: currentAmountInKobo,
                targetDate: targetDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required BigInt targetAmountInKobo,
                required BigInt currentAmountInKobo,
                required DateTime targetDate,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSavingsGoalsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                targetAmountInKobo: targetAmountInKobo,
                currentAmountInKobo: currentAmountInKobo,
                targetDate: targetDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSavingsGoalsTable, LocalSavingsGoal>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSavingsGoalsTable,
                    LocalSavingsGoal
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSavingsGoalsTable,
      LocalSavingsGoal,
      $$LocalSavingsGoalsTableFilterComposer,
      $$LocalSavingsGoalsTableOrderingComposer,
      $$LocalSavingsGoalsTableAnnotationComposer,
      $$LocalSavingsGoalsTableCreateCompanionBuilder,
      $$LocalSavingsGoalsTableUpdateCompanionBuilder,
      (
        LocalSavingsGoal,
        BaseReferences<
          _$AppDatabase,
          $LocalSavingsGoalsTable,
          LocalSavingsGoal
        >,
      ),
      LocalSavingsGoal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PendingQueueItemsTableTableManager get pendingQueueItems =>
      $$PendingQueueItemsTableTableManager(_db, _db.pendingQueueItems);
  $$LocalTransactionsTableTableManager get localTransactions =>
      $$LocalTransactionsTableTableManager(_db, _db.localTransactions);
  $$RecentTransactionsTableTableManager get recentTransactions =>
      $$RecentTransactionsTableTableManager(_db, _db.recentTransactions);
  $$LocalSavingsGoalsTableTableManager get localSavingsGoals =>
      $$LocalSavingsGoalsTableTableManager(_db, _db.localSavingsGoals);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the AppDatabase instance using code generation.
///
/// The database is automatically closed when the provider is disposed.
/// Riverpod provider for the AppDatabase instance using code generation.
///
/// keepAlive: true ensures that the database is only created once and
/// persists across screen changes, page transitions, and hot restarts.

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

/// Riverpod provider for the AppDatabase instance using code generation.
///
/// The database is automatically closed when the provider is disposed.
/// Riverpod provider for the AppDatabase instance using code generation.
///
/// keepAlive: true ensures that the database is only created once and
/// persists across screen changes, page transitions, and hot restarts.

final class DatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Riverpod provider for the AppDatabase instance using code generation.
  ///
  /// The database is automatically closed when the provider is disposed.
  /// Riverpod provider for the AppDatabase instance using code generation.
  ///
  /// keepAlive: true ensures that the database is only created once and
  /// persists across screen changes, page transitions, and hot restarts.
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$databaseHash() => r'f862f3bf360bcbc54d6f70e90aed473cb726296e';
