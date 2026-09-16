// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedUsersTable extends CachedUsers
    with TableInfo<$CachedUsersTable, CachedUserData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bvnMeta = const VerificationMeta('bvn');
  @override
  late final GeneratedColumn<String> bvn = GeneratedColumn<String>(
    'bvn',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ninMeta = const VerificationMeta('nin');
  @override
  late final GeneratedColumn<String> nin = GeneratedColumn<String>(
    'nin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    email,
    accountNumber,
    firstName,
    middleName,
    lastName,
    bvn,
    nin,
    phoneNumber,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedUserData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNumberMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middleNameMeta,
        middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('bvn')) {
      context.handle(
        _bvnMeta,
        bvn.isAcceptableOrUnknown(data['bvn']!, _bvnMeta),
      );
    } else if (isInserting) {
      context.missing(_bvnMeta);
    }
    if (data.containsKey('nin')) {
      context.handle(
        _ninMeta,
        nin.isAcceptableOrUnknown(data['nin']!, _ninMeta),
      );
    } else if (isInserting) {
      context.missing(_ninMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  CachedUserData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedUserData(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      bvn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bvn'],
      )!,
      nin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nin'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedUsersTable createAlias(String alias) {
    return $CachedUsersTable(attachedDatabase, alias);
  }
}

class CachedUserData extends DataClass implements Insertable<CachedUserData> {
  /// User's Firebase UID (primary key)
  final String uid;

  /// User's email address
  final String email;

  /// Unique 10-digit account number
  final String accountNumber;

  /// User's first name
  final String firstName;

  /// User's middle name (nullable)
  final String? middleName;

  /// User's last name
  final String lastName;

  /// Bank Verification Number
  final String bvn;

  /// National Identification Number
  final String nin;

  /// User's phone number
  final String phoneNumber;

  /// Last update timestamp (ISO 8601 string)
  final String updatedAt;
  const CachedUserData({
    required this.uid,
    required this.email,
    required this.accountNumber,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.bvn,
    required this.nin,
    required this.phoneNumber,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['email'] = Variable<String>(email);
    map['account_number'] = Variable<String>(accountNumber);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    map['last_name'] = Variable<String>(lastName);
    map['bvn'] = Variable<String>(bvn);
    map['nin'] = Variable<String>(nin);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  CachedUsersCompanion toCompanion(bool nullToAbsent) {
    return CachedUsersCompanion(
      uid: Value(uid),
      email: Value(email),
      accountNumber: Value(accountNumber),
      firstName: Value(firstName),
      middleName: middleName == null && nullToAbsent
          ? const Value.absent()
          : Value(middleName),
      lastName: Value(lastName),
      bvn: Value(bvn),
      nin: Value(nin),
      phoneNumber: Value(phoneNumber),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedUserData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedUserData(
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String>(json['email']),
      accountNumber: serializer.fromJson<String>(json['accountNumber']),
      firstName: serializer.fromJson<String>(json['firstName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      bvn: serializer.fromJson<String>(json['bvn']),
      nin: serializer.fromJson<String>(json['nin']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String>(email),
      'accountNumber': serializer.toJson<String>(accountNumber),
      'firstName': serializer.toJson<String>(firstName),
      'middleName': serializer.toJson<String?>(middleName),
      'lastName': serializer.toJson<String>(lastName),
      'bvn': serializer.toJson<String>(bvn),
      'nin': serializer.toJson<String>(nin),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  CachedUserData copyWith({
    String? uid,
    String? email,
    String? accountNumber,
    String? firstName,
    Value<String?> middleName = const Value.absent(),
    String? lastName,
    String? bvn,
    String? nin,
    String? phoneNumber,
    String? updatedAt,
  }) => CachedUserData(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    accountNumber: accountNumber ?? this.accountNumber,
    firstName: firstName ?? this.firstName,
    middleName: middleName.present ? middleName.value : this.middleName,
    lastName: lastName ?? this.lastName,
    bvn: bvn ?? this.bvn,
    nin: nin ?? this.nin,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedUserData copyWithCompanion(CachedUsersCompanion data) {
    return CachedUserData(
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName: data.middleName.present
          ? data.middleName.value
          : this.middleName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      bvn: data.bvn.present ? data.bvn.value : this.bvn,
      nin: data.nin.present ? data.nin.value : this.nin,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedUserData(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('bvn: $bvn, ')
          ..write('nin: $nin, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    email,
    accountNumber,
    firstName,
    middleName,
    lastName,
    bvn,
    nin,
    phoneNumber,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedUserData &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.accountNumber == this.accountNumber &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.lastName == this.lastName &&
          other.bvn == this.bvn &&
          other.nin == this.nin &&
          other.phoneNumber == this.phoneNumber &&
          other.updatedAt == this.updatedAt);
}

class CachedUsersCompanion extends UpdateCompanion<CachedUserData> {
  final Value<String> uid;
  final Value<String> email;
  final Value<String> accountNumber;
  final Value<String> firstName;
  final Value<String?> middleName;
  final Value<String> lastName;
  final Value<String> bvn;
  final Value<String> nin;
  final Value<String> phoneNumber;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const CachedUsersCompanion({
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.bvn = const Value.absent(),
    this.nin = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedUsersCompanion.insert({
    required String uid,
    required String email,
    required String accountNumber,
    required String firstName,
    this.middleName = const Value.absent(),
    required String lastName,
    required String bvn,
    required String nin,
    required String phoneNumber,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       email = Value(email),
       accountNumber = Value(accountNumber),
       firstName = Value(firstName),
       lastName = Value(lastName),
       bvn = Value(bvn),
       nin = Value(nin),
       phoneNumber = Value(phoneNumber),
       updatedAt = Value(updatedAt);
  static Insertable<CachedUserData> custom({
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? accountNumber,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? lastName,
    Expression<String>? bvn,
    Expression<String>? nin,
    Expression<String>? phoneNumber,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (accountNumber != null) 'account_number': accountNumber,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (lastName != null) 'last_name': lastName,
      if (bvn != null) 'bvn': bvn,
      if (nin != null) 'nin': nin,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedUsersCompanion copyWith({
    Value<String>? uid,
    Value<String>? email,
    Value<String>? accountNumber,
    Value<String>? firstName,
    Value<String?>? middleName,
    Value<String>? lastName,
    Value<String>? bvn,
    Value<String>? nin,
    Value<String>? phoneNumber,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedUsersCompanion(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      accountNumber: accountNumber ?? this.accountNumber,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      bvn: bvn ?? this.bvn,
      nin: nin ?? this.nin,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (bvn.present) {
      map['bvn'] = Variable<String>(bvn.value);
    }
    if (nin.present) {
      map['nin'] = Variable<String>(nin.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedUsersCompanion(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('bvn: $bvn, ')
          ..write('nin: $nin, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QueuedTransactionsTable extends QueuedTransactions
    with TableInfo<$QueuedTransactionsTable, QueuedTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueuedTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _senderUidMeta = const VerificationMeta(
    'senderUid',
  );
  @override
  late final GeneratedColumn<String> senderUid = GeneratedColumn<String>(
    'sender_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientUidMeta = const VerificationMeta(
    'recipientUid',
  );
  @override
  late final GeneratedColumn<String> recipientUid = GeneratedColumn<String>(
    'recipient_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountKoboMeta = const VerificationMeta(
    'amountKobo',
  );
  @override
  late final GeneratedColumn<int> amountKobo = GeneratedColumn<int>(
    'amount_kobo',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    transactionId,
    senderUid,
    recipientUid,
    amountKobo,
    idempotencyKey,
    status,
    retryCount,
    createdAt,
    updatedAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queued_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueuedTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('sender_uid')) {
      context.handle(
        _senderUidMeta,
        senderUid.isAcceptableOrUnknown(data['sender_uid']!, _senderUidMeta),
      );
    } else if (isInserting) {
      context.missing(_senderUidMeta);
    }
    if (data.containsKey('recipient_uid')) {
      context.handle(
        _recipientUidMeta,
        recipientUid.isAcceptableOrUnknown(
          data['recipient_uid']!,
          _recipientUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientUidMeta);
    }
    if (data.containsKey('amount_kobo')) {
      context.handle(
        _amountKoboMeta,
        amountKobo.isAcceptableOrUnknown(data['amount_kobo']!, _amountKoboMeta),
      );
    } else if (isInserting) {
      context.missing(_amountKoboMeta);
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
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  QueuedTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueuedTransaction(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      senderUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_uid'],
      )!,
      recipientUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_uid'],
      )!,
      amountKobo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_kobo'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $QueuedTransactionsTable createAlias(String alias) {
    return $QueuedTransactionsTable(attachedDatabase, alias);
  }
}

class QueuedTransaction extends DataClass
    implements Insertable<QueuedTransaction> {
  final int localId;
  final String transactionId;
  final String senderUid;
  final String recipientUid;
  final int amountKobo;
  final String idempotencyKey;
  final String status;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastError;
  const QueuedTransaction({
    required this.localId,
    required this.transactionId,
    required this.senderUid,
    required this.recipientUid,
    required this.amountKobo,
    required this.idempotencyKey,
    required this.status,
    required this.retryCount,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['transaction_id'] = Variable<String>(transactionId);
    map['sender_uid'] = Variable<String>(senderUid);
    map['recipient_uid'] = Variable<String>(recipientUid);
    map['amount_kobo'] = Variable<int>(amountKobo);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  QueuedTransactionsCompanion toCompanion(bool nullToAbsent) {
    return QueuedTransactionsCompanion(
      localId: Value(localId),
      transactionId: Value(transactionId),
      senderUid: Value(senderUid),
      recipientUid: Value(recipientUid),
      amountKobo: Value(amountKobo),
      idempotencyKey: Value(idempotencyKey),
      status: Value(status),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory QueuedTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueuedTransaction(
      localId: serializer.fromJson<int>(json['localId']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      senderUid: serializer.fromJson<String>(json['senderUid']),
      recipientUid: serializer.fromJson<String>(json['recipientUid']),
      amountKobo: serializer.fromJson<int>(json['amountKobo']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'transactionId': serializer.toJson<String>(transactionId),
      'senderUid': serializer.toJson<String>(senderUid),
      'recipientUid': serializer.toJson<String>(recipientUid),
      'amountKobo': serializer.toJson<int>(amountKobo),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  QueuedTransaction copyWith({
    int? localId,
    String? transactionId,
    String? senderUid,
    String? recipientUid,
    int? amountKobo,
    String? idempotencyKey,
    String? status,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> lastError = const Value.absent(),
  }) => QueuedTransaction(
    localId: localId ?? this.localId,
    transactionId: transactionId ?? this.transactionId,
    senderUid: senderUid ?? this.senderUid,
    recipientUid: recipientUid ?? this.recipientUid,
    amountKobo: amountKobo ?? this.amountKobo,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  QueuedTransaction copyWithCompanion(QueuedTransactionsCompanion data) {
    return QueuedTransaction(
      localId: data.localId.present ? data.localId.value : this.localId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      senderUid: data.senderUid.present ? data.senderUid.value : this.senderUid,
      recipientUid: data.recipientUid.present
          ? data.recipientUid.value
          : this.recipientUid,
      amountKobo: data.amountKobo.present
          ? data.amountKobo.value
          : this.amountKobo,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueuedTransaction(')
          ..write('localId: $localId, ')
          ..write('transactionId: $transactionId, ')
          ..write('senderUid: $senderUid, ')
          ..write('recipientUid: $recipientUid, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    transactionId,
    senderUid,
    recipientUid,
    amountKobo,
    idempotencyKey,
    status,
    retryCount,
    createdAt,
    updatedAt,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueuedTransaction &&
          other.localId == this.localId &&
          other.transactionId == this.transactionId &&
          other.senderUid == this.senderUid &&
          other.recipientUid == this.recipientUid &&
          other.amountKobo == this.amountKobo &&
          other.idempotencyKey == this.idempotencyKey &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastError == this.lastError);
}

class QueuedTransactionsCompanion extends UpdateCompanion<QueuedTransaction> {
  final Value<int> localId;
  final Value<String> transactionId;
  final Value<String> senderUid;
  final Value<String> recipientUid;
  final Value<int> amountKobo;
  final Value<String> idempotencyKey;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> lastError;
  const QueuedTransactionsCompanion({
    this.localId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.senderUid = const Value.absent(),
    this.recipientUid = const Value.absent(),
    this.amountKobo = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  QueuedTransactionsCompanion.insert({
    this.localId = const Value.absent(),
    required String transactionId,
    required String senderUid,
    required String recipientUid,
    required int amountKobo,
    required String idempotencyKey,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : transactionId = Value(transactionId),
       senderUid = Value(senderUid),
       recipientUid = Value(recipientUid),
       amountKobo = Value(amountKobo),
       idempotencyKey = Value(idempotencyKey);
  static Insertable<QueuedTransaction> custom({
    Expression<int>? localId,
    Expression<String>? transactionId,
    Expression<String>? senderUid,
    Expression<String>? recipientUid,
    Expression<int>? amountKobo,
    Expression<String>? idempotencyKey,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (senderUid != null) 'sender_uid': senderUid,
      if (recipientUid != null) 'recipient_uid': recipientUid,
      if (amountKobo != null) 'amount_kobo': amountKobo,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastError != null) 'last_error': lastError,
    });
  }

  QueuedTransactionsCompanion copyWith({
    Value<int>? localId,
    Value<String>? transactionId,
    Value<String>? senderUid,
    Value<String>? recipientUid,
    Value<int>? amountKobo,
    Value<String>? idempotencyKey,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? lastError,
  }) {
    return QueuedTransactionsCompanion(
      localId: localId ?? this.localId,
      transactionId: transactionId ?? this.transactionId,
      senderUid: senderUid ?? this.senderUid,
      recipientUid: recipientUid ?? this.recipientUid,
      amountKobo: amountKobo ?? this.amountKobo,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (senderUid.present) {
      map['sender_uid'] = Variable<String>(senderUid.value);
    }
    if (recipientUid.present) {
      map['recipient_uid'] = Variable<String>(recipientUid.value);
    }
    if (amountKobo.present) {
      map['amount_kobo'] = Variable<int>(amountKobo.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueuedTransactionsCompanion(')
          ..write('localId: $localId, ')
          ..write('transactionId: $transactionId, ')
          ..write('senderUid: $senderUid, ')
          ..write('recipientUid: $recipientUid, ')
          ..write('amountKobo: $amountKobo, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedUsersTable cachedUsers = $CachedUsersTable(this);
  late final $QueuedTransactionsTable queuedTransactions =
      $QueuedTransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedUsers,
    queuedTransactions,
  ];
}

typedef $$CachedUsersTableCreateCompanionBuilder =
    CachedUsersCompanion Function({
      required String uid,
      required String email,
      required String accountNumber,
      required String firstName,
      Value<String?> middleName,
      required String lastName,
      required String bvn,
      required String nin,
      required String phoneNumber,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$CachedUsersTableUpdateCompanionBuilder =
    CachedUsersCompanion Function({
      Value<String> uid,
      Value<String> email,
      Value<String> accountNumber,
      Value<String> firstName,
      Value<String?> middleName,
      Value<String> lastName,
      Value<String> bvn,
      Value<String> nin,
      Value<String> phoneNumber,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$CachedUsersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedUsersTable> {
  $$CachedUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bvn => $composableBuilder(
    column: $table.bvn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nin => $composableBuilder(
    column: $table.nin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedUsersTable> {
  $$CachedUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bvn => $composableBuilder(
    column: $table.bvn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nin => $composableBuilder(
    column: $table.nin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedUsersTable> {
  $$CachedUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get bvn =>
      $composableBuilder(column: $table.bvn, builder: (column) => column);

  GeneratedColumn<String> get nin =>
      $composableBuilder(column: $table.nin, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedUsersTable,
          CachedUserData,
          $$CachedUsersTableFilterComposer,
          $$CachedUsersTableOrderingComposer,
          $$CachedUsersTableAnnotationComposer,
          $$CachedUsersTableCreateCompanionBuilder,
          $$CachedUsersTableUpdateCompanionBuilder,
          (
            CachedUserData,
            BaseReferences<_$AppDatabase, $CachedUsersTable, CachedUserData>,
          ),
          CachedUserData,
          PrefetchHooks Function()
        > {
  $$CachedUsersTableTableManager(_$AppDatabase db, $CachedUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> accountNumber = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> bvn = const Value.absent(),
                Value<String> nin = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUsersCompanion(
                uid: uid,
                email: email,
                accountNumber: accountNumber,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                bvn: bvn,
                nin: nin,
                phoneNumber: phoneNumber,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required String email,
                required String accountNumber,
                required String firstName,
                Value<String?> middleName = const Value.absent(),
                required String lastName,
                required String bvn,
                required String nin,
                required String phoneNumber,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedUsersCompanion.insert(
                uid: uid,
                email: email,
                accountNumber: accountNumber,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                bvn: bvn,
                nin: nin,
                phoneNumber: phoneNumber,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedUsersTable, CachedUserData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedUsersTable,
                    CachedUserData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedUsersTable,
      CachedUserData,
      $$CachedUsersTableFilterComposer,
      $$CachedUsersTableOrderingComposer,
      $$CachedUsersTableAnnotationComposer,
      $$CachedUsersTableCreateCompanionBuilder,
      $$CachedUsersTableUpdateCompanionBuilder,
      (
        CachedUserData,
        BaseReferences<_$AppDatabase, $CachedUsersTable, CachedUserData>,
      ),
      CachedUserData,
      PrefetchHooks Function()
    >;
typedef $$QueuedTransactionsTableCreateCompanionBuilder =
    QueuedTransactionsCompanion Function({
      Value<int> localId,
      required String transactionId,
      required String senderUid,
      required String recipientUid,
      required int amountKobo,
      required String idempotencyKey,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> lastError,
    });
typedef $$QueuedTransactionsTableUpdateCompanionBuilder =
    QueuedTransactionsCompanion Function({
      Value<int> localId,
      Value<String> transactionId,
      Value<String> senderUid,
      Value<String> recipientUid,
      Value<int> amountKobo,
      Value<String> idempotencyKey,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> lastError,
    });

class $$QueuedTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $QueuedTransactionsTable> {
  $$QueuedTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderUid => $composableBuilder(
    column: $table.senderUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientUid => $composableBuilder(
    column: $table.recipientUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
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

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueuedTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QueuedTransactionsTable> {
  $$QueuedTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderUid => $composableBuilder(
    column: $table.senderUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientUid => $composableBuilder(
    column: $table.recipientUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
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

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueuedTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QueuedTransactionsTable> {
  $$QueuedTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderUid =>
      $composableBuilder(column: $table.senderUid, builder: (column) => column);

  GeneratedColumn<String> get recipientUid => $composableBuilder(
    column: $table.recipientUid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountKobo => $composableBuilder(
    column: $table.amountKobo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$QueuedTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QueuedTransactionsTable,
          QueuedTransaction,
          $$QueuedTransactionsTableFilterComposer,
          $$QueuedTransactionsTableOrderingComposer,
          $$QueuedTransactionsTableAnnotationComposer,
          $$QueuedTransactionsTableCreateCompanionBuilder,
          $$QueuedTransactionsTableUpdateCompanionBuilder,
          (
            QueuedTransaction,
            BaseReferences<
              _$AppDatabase,
              $QueuedTransactionsTable,
              QueuedTransaction
            >,
          ),
          QueuedTransaction,
          PrefetchHooks Function()
        > {
  $$QueuedTransactionsTableTableManager(
    _$AppDatabase db,
    $QueuedTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueuedTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueuedTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueuedTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> senderUid = const Value.absent(),
                Value<String> recipientUid = const Value.absent(),
                Value<int> amountKobo = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => QueuedTransactionsCompanion(
                localId: localId,
                transactionId: transactionId,
                senderUid: senderUid,
                recipientUid: recipientUid,
                amountKobo: amountKobo,
                idempotencyKey: idempotencyKey,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String transactionId,
                required String senderUid,
                required String recipientUid,
                required int amountKobo,
                required String idempotencyKey,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => QueuedTransactionsCompanion.insert(
                localId: localId,
                transactionId: transactionId,
                senderUid: senderUid,
                recipientUid: recipientUid,
                amountKobo: amountKobo,
                idempotencyKey: idempotencyKey,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QueuedTransactionsTable, QueuedTransaction>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $QueuedTransactionsTable,
                    QueuedTransaction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueuedTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QueuedTransactionsTable,
      QueuedTransaction,
      $$QueuedTransactionsTableFilterComposer,
      $$QueuedTransactionsTableOrderingComposer,
      $$QueuedTransactionsTableAnnotationComposer,
      $$QueuedTransactionsTableCreateCompanionBuilder,
      $$QueuedTransactionsTableUpdateCompanionBuilder,
      (
        QueuedTransaction,
        BaseReferences<
          _$AppDatabase,
          $QueuedTransactionsTable,
          QueuedTransaction
        >,
      ),
      QueuedTransaction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedUsersTableTableManager get cachedUsers =>
      $$CachedUsersTableTableManager(_db, _db.cachedUsers);
  $$QueuedTransactionsTableTableManager get queuedTransactions =>
      $$QueuedTransactionsTableTableManager(_db, _db.queuedTransactions);
}
