// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _openingBalancePaiseMeta =
      const VerificationMeta('openingBalancePaise');
  @override
  late final GeneratedColumn<int> openingBalancePaise = GeneratedColumn<int>(
    'opening_balance_paise',
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
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colourKeyMeta = const VerificationMeta(
    'colourKey',
  );
  @override
  late final GeneratedColumn<String> colourKey = GeneratedColumn<String>(
    'colour_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    openingBalancePaise,
    createdAt,
    updatedAt,
    isArchived,
    iconKey,
    colourKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('opening_balance_paise')) {
      context.handle(
        _openingBalancePaiseMeta,
        openingBalancePaise.isAcceptableOrUnknown(
          data['opening_balance_paise']!,
          _openingBalancePaiseMeta,
        ),
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
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('colour_key')) {
      context.handle(
        _colourKeyMeta,
        colourKey.isAcceptableOrUnknown(data['colour_key']!, _colourKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      openingBalancePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_paise'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      ),
      colourKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colour_key'],
      ),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter<AccountType>(AccountType.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final AccountType type;
  final int openingBalancePaise;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  final String? iconKey;
  final String? colourKey;
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalancePaise,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
    this.iconKey,
    this.colourKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['opening_balance_paise'] = Variable<int>(openingBalancePaise);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || iconKey != null) {
      map['icon_key'] = Variable<String>(iconKey);
    }
    if (!nullToAbsent || colourKey != null) {
      map['colour_key'] = Variable<String>(colourKey);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      openingBalancePaise: Value(openingBalancePaise),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
      iconKey: iconKey == null && nullToAbsent
          ? const Value.absent()
          : Value(iconKey),
      colourKey: colourKey == null && nullToAbsent
          ? const Value.absent()
          : Value(colourKey),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      openingBalancePaise: serializer.fromJson<int>(
        json['openingBalancePaise'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      iconKey: serializer.fromJson<String?>(json['iconKey']),
      colourKey: serializer.fromJson<String?>(json['colourKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $AccountsTable.$convertertype.toJson(type),
      ),
      'openingBalancePaise': serializer.toJson<int>(openingBalancePaise),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
      'iconKey': serializer.toJson<String?>(iconKey),
      'colourKey': serializer.toJson<String?>(colourKey),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    AccountType? type,
    int? openingBalancePaise,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    Value<String?> iconKey = const Value.absent(),
    Value<String?> colourKey = const Value.absent(),
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    openingBalancePaise: openingBalancePaise ?? this.openingBalancePaise,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
    iconKey: iconKey.present ? iconKey.value : this.iconKey,
    colourKey: colourKey.present ? colourKey.value : this.colourKey,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      openingBalancePaise: data.openingBalancePaise.present
          ? data.openingBalancePaise.value
          : this.openingBalancePaise,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colourKey: data.colourKey.present ? data.colourKey.value : this.colourKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalancePaise: $openingBalancePaise, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('iconKey: $iconKey, ')
          ..write('colourKey: $colourKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    openingBalancePaise,
    createdAt,
    updatedAt,
    isArchived,
    iconKey,
    colourKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.openingBalancePaise == this.openingBalancePaise &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived &&
          other.iconKey == this.iconKey &&
          other.colourKey == this.colourKey);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<int> openingBalancePaise;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<String?> iconKey;
  final Value<String?> colourKey;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.openingBalancePaise = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colourKey = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountType type,
    this.openingBalancePaise = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colourKey = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? openingBalancePaise,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<String>? iconKey,
    Expression<String>? colourKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (openingBalancePaise != null)
        'opening_balance_paise': openingBalancePaise,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (iconKey != null) 'icon_key': iconKey,
      if (colourKey != null) 'colour_key': colourKey,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<AccountType>? type,
    Value<int>? openingBalancePaise,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<String?>? iconKey,
    Value<String?>? colourKey,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      openingBalancePaise: openingBalancePaise ?? this.openingBalancePaise,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      iconKey: iconKey ?? this.iconKey,
      colourKey: colourKey ?? this.colourKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AccountsTable.$convertertype.toSql(type.value),
      );
    }
    if (openingBalancePaise.present) {
      map['opening_balance_paise'] = Variable<int>(openingBalancePaise.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colourKey.present) {
      map['colour_key'] = Variable<String>(colourKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalancePaise: $openingBalancePaise, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('iconKey: $iconKey, ')
          ..write('colourKey: $colourKey')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryKind>($CategoriesTable.$converterkind);
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    name,
    kind,
    iconKey,
    isDefault,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
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
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $CategoriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryKind, String, String> $converterkind =
      const EnumNameConverter<CategoryKind>(CategoryKind.values);
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final CategoryKind kind;
  final String? iconKey;
  final bool isDefault;
  final bool isArchived;
  final DateTime createdAt;
  const Category({
    required this.id,
    required this.name,
    required this.kind,
    this.iconKey,
    required this.isDefault,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || iconKey != null) {
      map['icon_key'] = Variable<String>(iconKey);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      iconKey: iconKey == null && nullToAbsent
          ? const Value.absent()
          : Value(iconKey),
      isDefault: Value(isDefault),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $CategoriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      iconKey: serializer.fromJson<String?>(json['iconKey']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $CategoriesTable.$converterkind.toJson(kind),
      ),
      'iconKey': serializer.toJson<String?>(iconKey),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    CategoryKind? kind,
    Value<String?> iconKey = const Value.absent(),
    bool? isDefault,
    bool? isArchived,
    DateTime? createdAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    iconKey: iconKey.present ? iconKey.value : this.iconKey,
    isDefault: isDefault ?? this.isDefault,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('iconKey: $iconKey, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, kind, iconKey, isDefault, isArchived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.iconKey == this.iconKey &&
          other.isDefault == this.isDefault &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<CategoryKind> kind;
  final Value<String?> iconKey;
  final Value<bool> isDefault;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required CategoryKind kind,
    this.iconKey = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? iconKey,
    Expression<bool>? isDefault,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (iconKey != null) 'icon_key': iconKey,
      if (isDefault != null) 'is_default': isDefault,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<CategoryKind>? kind,
    Value<String?>? iconKey,
    Value<bool>? isDefault,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      iconKey: iconKey ?? this.iconKey,
      isDefault: isDefault ?? this.isDefault,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('iconKey: $iconKey, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentAttemptsTable extends PaymentAttempts
    with TableInfo<$PaymentAttemptsTable, PaymentAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentAttemptStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PaymentAttemptStatus>($PaymentAttemptsTable.$converterstatus);
  static const VerificationMeta _payeeNameMeta = const VerificationMeta(
    'payeeName',
  );
  @override
  late final GeneratedColumn<String> payeeName = GeneratedColumn<String>(
    'payee_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeVpaMeta = const VerificationMeta(
    'payeeVpa',
  );
  @override
  late final GeneratedColumn<String> payeeVpa = GeneratedColumn<String>(
    'payee_vpa',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountWasProvidedByQrMeta =
      const VerificationMeta('amountWasProvidedByQr');
  @override
  late final GeneratedColumn<bool> amountWasProvidedByQr =
      GeneratedColumn<bool>(
        'amount_was_provided_by_qr',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("amount_was_provided_by_qr" IN (0, 1))',
        ),
      );
  static const VerificationMeta _rawQrPayloadMeta = const VerificationMeta(
    'rawQrPayload',
  );
  @override
  late final GeneratedColumn<String> rawQrPayload = GeneratedColumn<String>(
    'raw_qr_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intendedAccountIdMeta = const VerificationMeta(
    'intendedAccountId',
  );
  @override
  late final GeneratedColumn<int> intendedAccountId = GeneratedColumn<int>(
    'intended_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _actualFundingAccountIdMeta =
      const VerificationMeta('actualFundingAccountId');
  @override
  late final GeneratedColumn<int> actualFundingAccountId = GeneratedColumn<int>(
    'actual_funding_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _selectedPaymentAppIdMeta =
      const VerificationMeta('selectedPaymentAppId');
  @override
  late final GeneratedColumn<String> selectedPaymentAppId =
      GeneratedColumn<String>(
        'selected_payment_app_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _externalReferenceMeta = const VerificationMeta(
    'externalReference',
  );
  @override
  late final GeneratedColumn<String> externalReference =
      GeneratedColumn<String>(
        'external_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
  static const VerificationMeta _launchedAtMeta = const VerificationMeta(
    'launchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> launchedAt = GeneratedColumn<DateTime>(
    'launched_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<int> linkedTransactionId = GeneratedColumn<int>(
    'linked_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _launchErrorMeta = const VerificationMeta(
    'launchError',
  );
  @override
  late final GeneratedColumn<String> launchError = GeneratedColumn<String>(
    'launch_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    payeeName,
    payeeVpa,
    amountPaise,
    amountWasProvidedByQr,
    rawQrPayload,
    categoryId,
    note,
    intendedAccountId,
    actualFundingAccountId,
    selectedPaymentAppId,
    externalReference,
    createdAt,
    launchedAt,
    resolvedAt,
    linkedTransactionId,
    launchError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payee_name')) {
      context.handle(
        _payeeNameMeta,
        payeeName.isAcceptableOrUnknown(data['payee_name']!, _payeeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_payeeNameMeta);
    }
    if (data.containsKey('payee_vpa')) {
      context.handle(
        _payeeVpaMeta,
        payeeVpa.isAcceptableOrUnknown(data['payee_vpa']!, _payeeVpaMeta),
      );
    } else if (isInserting) {
      context.missing(_payeeVpaMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('amount_was_provided_by_qr')) {
      context.handle(
        _amountWasProvidedByQrMeta,
        amountWasProvidedByQr.isAcceptableOrUnknown(
          data['amount_was_provided_by_qr']!,
          _amountWasProvidedByQrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountWasProvidedByQrMeta);
    }
    if (data.containsKey('raw_qr_payload')) {
      context.handle(
        _rawQrPayloadMeta,
        rawQrPayload.isAcceptableOrUnknown(
          data['raw_qr_payload']!,
          _rawQrPayloadMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('intended_account_id')) {
      context.handle(
        _intendedAccountIdMeta,
        intendedAccountId.isAcceptableOrUnknown(
          data['intended_account_id']!,
          _intendedAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intendedAccountIdMeta);
    }
    if (data.containsKey('actual_funding_account_id')) {
      context.handle(
        _actualFundingAccountIdMeta,
        actualFundingAccountId.isAcceptableOrUnknown(
          data['actual_funding_account_id']!,
          _actualFundingAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_payment_app_id')) {
      context.handle(
        _selectedPaymentAppIdMeta,
        selectedPaymentAppId.isAcceptableOrUnknown(
          data['selected_payment_app_id']!,
          _selectedPaymentAppIdMeta,
        ),
      );
    }
    if (data.containsKey('external_reference')) {
      context.handle(
        _externalReferenceMeta,
        externalReference.isAcceptableOrUnknown(
          data['external_reference']!,
          _externalReferenceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('launched_at')) {
      context.handle(
        _launchedAtMeta,
        launchedAt.isAcceptableOrUnknown(data['launched_at']!, _launchedAtMeta),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
        _linkedTransactionIdMeta,
        linkedTransactionId.isAcceptableOrUnknown(
          data['linked_transaction_id']!,
          _linkedTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('launch_error')) {
      context.handle(
        _launchErrorMeta,
        launchError.isAcceptableOrUnknown(
          data['launch_error']!,
          _launchErrorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      status: $PaymentAttemptsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      payeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_name'],
      )!,
      payeeVpa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_vpa'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      amountWasProvidedByQr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}amount_was_provided_by_qr'],
      )!,
      rawQrPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_qr_payload'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      intendedAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intended_account_id'],
      )!,
      actualFundingAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_funding_account_id'],
      ),
      selectedPaymentAppId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_payment_app_id'],
      ),
      externalReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_reference'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      launchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}launched_at'],
      ),
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      linkedTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_transaction_id'],
      ),
      launchError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}launch_error'],
      ),
    );
  }

  @override
  $PaymentAttemptsTable createAlias(String alias) {
    return $PaymentAttemptsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentAttemptStatus, String, String>
  $converterstatus = const EnumNameConverter<PaymentAttemptStatus>(
    PaymentAttemptStatus.values,
  );
}

class PaymentAttempt extends DataClass implements Insertable<PaymentAttempt> {
  final int id;
  final PaymentAttemptStatus status;
  final String payeeName;
  final String payeeVpa;
  final int amountPaise;
  final bool amountWasProvidedByQr;
  final String? rawQrPayload;
  final int? categoryId;
  final String? note;
  final int intendedAccountId;
  final int? actualFundingAccountId;
  final String? selectedPaymentAppId;
  final String? externalReference;
  final DateTime createdAt;
  final DateTime? launchedAt;
  final DateTime? resolvedAt;
  final int? linkedTransactionId;
  final String? launchError;
  const PaymentAttempt({
    required this.id,
    required this.status,
    required this.payeeName,
    required this.payeeVpa,
    required this.amountPaise,
    required this.amountWasProvidedByQr,
    this.rawQrPayload,
    this.categoryId,
    this.note,
    required this.intendedAccountId,
    this.actualFundingAccountId,
    this.selectedPaymentAppId,
    this.externalReference,
    required this.createdAt,
    this.launchedAt,
    this.resolvedAt,
    this.linkedTransactionId,
    this.launchError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['status'] = Variable<String>(
        $PaymentAttemptsTable.$converterstatus.toSql(status),
      );
    }
    map['payee_name'] = Variable<String>(payeeName);
    map['payee_vpa'] = Variable<String>(payeeVpa);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['amount_was_provided_by_qr'] = Variable<bool>(amountWasProvidedByQr);
    if (!nullToAbsent || rawQrPayload != null) {
      map['raw_qr_payload'] = Variable<String>(rawQrPayload);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['intended_account_id'] = Variable<int>(intendedAccountId);
    if (!nullToAbsent || actualFundingAccountId != null) {
      map['actual_funding_account_id'] = Variable<int>(actualFundingAccountId);
    }
    if (!nullToAbsent || selectedPaymentAppId != null) {
      map['selected_payment_app_id'] = Variable<String>(selectedPaymentAppId);
    }
    if (!nullToAbsent || externalReference != null) {
      map['external_reference'] = Variable<String>(externalReference);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || launchedAt != null) {
      map['launched_at'] = Variable<DateTime>(launchedAt);
    }
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<int>(linkedTransactionId);
    }
    if (!nullToAbsent || launchError != null) {
      map['launch_error'] = Variable<String>(launchError);
    }
    return map;
  }

  PaymentAttemptsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAttemptsCompanion(
      id: Value(id),
      status: Value(status),
      payeeName: Value(payeeName),
      payeeVpa: Value(payeeVpa),
      amountPaise: Value(amountPaise),
      amountWasProvidedByQr: Value(amountWasProvidedByQr),
      rawQrPayload: rawQrPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(rawQrPayload),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      intendedAccountId: Value(intendedAccountId),
      actualFundingAccountId: actualFundingAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(actualFundingAccountId),
      selectedPaymentAppId: selectedPaymentAppId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedPaymentAppId),
      externalReference: externalReference == null && nullToAbsent
          ? const Value.absent()
          : Value(externalReference),
      createdAt: Value(createdAt),
      launchedAt: launchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(launchedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      launchError: launchError == null && nullToAbsent
          ? const Value.absent()
          : Value(launchError),
    );
  }

  factory PaymentAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAttempt(
      id: serializer.fromJson<int>(json['id']),
      status: $PaymentAttemptsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      payeeName: serializer.fromJson<String>(json['payeeName']),
      payeeVpa: serializer.fromJson<String>(json['payeeVpa']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      amountWasProvidedByQr: serializer.fromJson<bool>(
        json['amountWasProvidedByQr'],
      ),
      rawQrPayload: serializer.fromJson<String?>(json['rawQrPayload']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      intendedAccountId: serializer.fromJson<int>(json['intendedAccountId']),
      actualFundingAccountId: serializer.fromJson<int?>(
        json['actualFundingAccountId'],
      ),
      selectedPaymentAppId: serializer.fromJson<String?>(
        json['selectedPaymentAppId'],
      ),
      externalReference: serializer.fromJson<String?>(
        json['externalReference'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      launchedAt: serializer.fromJson<DateTime?>(json['launchedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      linkedTransactionId: serializer.fromJson<int?>(
        json['linkedTransactionId'],
      ),
      launchError: serializer.fromJson<String?>(json['launchError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'status': serializer.toJson<String>(
        $PaymentAttemptsTable.$converterstatus.toJson(status),
      ),
      'payeeName': serializer.toJson<String>(payeeName),
      'payeeVpa': serializer.toJson<String>(payeeVpa),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'amountWasProvidedByQr': serializer.toJson<bool>(amountWasProvidedByQr),
      'rawQrPayload': serializer.toJson<String?>(rawQrPayload),
      'categoryId': serializer.toJson<int?>(categoryId),
      'note': serializer.toJson<String?>(note),
      'intendedAccountId': serializer.toJson<int>(intendedAccountId),
      'actualFundingAccountId': serializer.toJson<int?>(actualFundingAccountId),
      'selectedPaymentAppId': serializer.toJson<String?>(selectedPaymentAppId),
      'externalReference': serializer.toJson<String?>(externalReference),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'launchedAt': serializer.toJson<DateTime?>(launchedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'linkedTransactionId': serializer.toJson<int?>(linkedTransactionId),
      'launchError': serializer.toJson<String?>(launchError),
    };
  }

  PaymentAttempt copyWith({
    int? id,
    PaymentAttemptStatus? status,
    String? payeeName,
    String? payeeVpa,
    int? amountPaise,
    bool? amountWasProvidedByQr,
    Value<String?> rawQrPayload = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? intendedAccountId,
    Value<int?> actualFundingAccountId = const Value.absent(),
    Value<String?> selectedPaymentAppId = const Value.absent(),
    Value<String?> externalReference = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> launchedAt = const Value.absent(),
    Value<DateTime?> resolvedAt = const Value.absent(),
    Value<int?> linkedTransactionId = const Value.absent(),
    Value<String?> launchError = const Value.absent(),
  }) => PaymentAttempt(
    id: id ?? this.id,
    status: status ?? this.status,
    payeeName: payeeName ?? this.payeeName,
    payeeVpa: payeeVpa ?? this.payeeVpa,
    amountPaise: amountPaise ?? this.amountPaise,
    amountWasProvidedByQr: amountWasProvidedByQr ?? this.amountWasProvidedByQr,
    rawQrPayload: rawQrPayload.present ? rawQrPayload.value : this.rawQrPayload,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note.present ? note.value : this.note,
    intendedAccountId: intendedAccountId ?? this.intendedAccountId,
    actualFundingAccountId: actualFundingAccountId.present
        ? actualFundingAccountId.value
        : this.actualFundingAccountId,
    selectedPaymentAppId: selectedPaymentAppId.present
        ? selectedPaymentAppId.value
        : this.selectedPaymentAppId,
    externalReference: externalReference.present
        ? externalReference.value
        : this.externalReference,
    createdAt: createdAt ?? this.createdAt,
    launchedAt: launchedAt.present ? launchedAt.value : this.launchedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    linkedTransactionId: linkedTransactionId.present
        ? linkedTransactionId.value
        : this.linkedTransactionId,
    launchError: launchError.present ? launchError.value : this.launchError,
  );
  PaymentAttempt copyWithCompanion(PaymentAttemptsCompanion data) {
    return PaymentAttempt(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      payeeName: data.payeeName.present ? data.payeeName.value : this.payeeName,
      payeeVpa: data.payeeVpa.present ? data.payeeVpa.value : this.payeeVpa,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      amountWasProvidedByQr: data.amountWasProvidedByQr.present
          ? data.amountWasProvidedByQr.value
          : this.amountWasProvidedByQr,
      rawQrPayload: data.rawQrPayload.present
          ? data.rawQrPayload.value
          : this.rawQrPayload,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      intendedAccountId: data.intendedAccountId.present
          ? data.intendedAccountId.value
          : this.intendedAccountId,
      actualFundingAccountId: data.actualFundingAccountId.present
          ? data.actualFundingAccountId.value
          : this.actualFundingAccountId,
      selectedPaymentAppId: data.selectedPaymentAppId.present
          ? data.selectedPaymentAppId.value
          : this.selectedPaymentAppId,
      externalReference: data.externalReference.present
          ? data.externalReference.value
          : this.externalReference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      launchedAt: data.launchedAt.present
          ? data.launchedAt.value
          : this.launchedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      launchError: data.launchError.present
          ? data.launchError.value
          : this.launchError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAttempt(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeVpa: $payeeVpa, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('amountWasProvidedByQr: $amountWasProvidedByQr, ')
          ..write('rawQrPayload: $rawQrPayload, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('intendedAccountId: $intendedAccountId, ')
          ..write('actualFundingAccountId: $actualFundingAccountId, ')
          ..write('selectedPaymentAppId: $selectedPaymentAppId, ')
          ..write('externalReference: $externalReference, ')
          ..write('createdAt: $createdAt, ')
          ..write('launchedAt: $launchedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('launchError: $launchError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    payeeName,
    payeeVpa,
    amountPaise,
    amountWasProvidedByQr,
    rawQrPayload,
    categoryId,
    note,
    intendedAccountId,
    actualFundingAccountId,
    selectedPaymentAppId,
    externalReference,
    createdAt,
    launchedAt,
    resolvedAt,
    linkedTransactionId,
    launchError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAttempt &&
          other.id == this.id &&
          other.status == this.status &&
          other.payeeName == this.payeeName &&
          other.payeeVpa == this.payeeVpa &&
          other.amountPaise == this.amountPaise &&
          other.amountWasProvidedByQr == this.amountWasProvidedByQr &&
          other.rawQrPayload == this.rawQrPayload &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.intendedAccountId == this.intendedAccountId &&
          other.actualFundingAccountId == this.actualFundingAccountId &&
          other.selectedPaymentAppId == this.selectedPaymentAppId &&
          other.externalReference == this.externalReference &&
          other.createdAt == this.createdAt &&
          other.launchedAt == this.launchedAt &&
          other.resolvedAt == this.resolvedAt &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.launchError == this.launchError);
}

class PaymentAttemptsCompanion extends UpdateCompanion<PaymentAttempt> {
  final Value<int> id;
  final Value<PaymentAttemptStatus> status;
  final Value<String> payeeName;
  final Value<String> payeeVpa;
  final Value<int> amountPaise;
  final Value<bool> amountWasProvidedByQr;
  final Value<String?> rawQrPayload;
  final Value<int?> categoryId;
  final Value<String?> note;
  final Value<int> intendedAccountId;
  final Value<int?> actualFundingAccountId;
  final Value<String?> selectedPaymentAppId;
  final Value<String?> externalReference;
  final Value<DateTime> createdAt;
  final Value<DateTime?> launchedAt;
  final Value<DateTime?> resolvedAt;
  final Value<int?> linkedTransactionId;
  final Value<String?> launchError;
  const PaymentAttemptsCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.payeeName = const Value.absent(),
    this.payeeVpa = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.amountWasProvidedByQr = const Value.absent(),
    this.rawQrPayload = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.intendedAccountId = const Value.absent(),
    this.actualFundingAccountId = const Value.absent(),
    this.selectedPaymentAppId = const Value.absent(),
    this.externalReference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.launchedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.launchError = const Value.absent(),
  });
  PaymentAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required PaymentAttemptStatus status,
    required String payeeName,
    required String payeeVpa,
    required int amountPaise,
    required bool amountWasProvidedByQr,
    this.rawQrPayload = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    required int intendedAccountId,
    this.actualFundingAccountId = const Value.absent(),
    this.selectedPaymentAppId = const Value.absent(),
    this.externalReference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.launchedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.launchError = const Value.absent(),
  }) : status = Value(status),
       payeeName = Value(payeeName),
       payeeVpa = Value(payeeVpa),
       amountPaise = Value(amountPaise),
       amountWasProvidedByQr = Value(amountWasProvidedByQr),
       intendedAccountId = Value(intendedAccountId);
  static Insertable<PaymentAttempt> custom({
    Expression<int>? id,
    Expression<String>? status,
    Expression<String>? payeeName,
    Expression<String>? payeeVpa,
    Expression<int>? amountPaise,
    Expression<bool>? amountWasProvidedByQr,
    Expression<String>? rawQrPayload,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<int>? intendedAccountId,
    Expression<int>? actualFundingAccountId,
    Expression<String>? selectedPaymentAppId,
    Expression<String>? externalReference,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? launchedAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? linkedTransactionId,
    Expression<String>? launchError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (payeeName != null) 'payee_name': payeeName,
      if (payeeVpa != null) 'payee_vpa': payeeVpa,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (amountWasProvidedByQr != null)
        'amount_was_provided_by_qr': amountWasProvidedByQr,
      if (rawQrPayload != null) 'raw_qr_payload': rawQrPayload,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (intendedAccountId != null) 'intended_account_id': intendedAccountId,
      if (actualFundingAccountId != null)
        'actual_funding_account_id': actualFundingAccountId,
      if (selectedPaymentAppId != null)
        'selected_payment_app_id': selectedPaymentAppId,
      if (externalReference != null) 'external_reference': externalReference,
      if (createdAt != null) 'created_at': createdAt,
      if (launchedAt != null) 'launched_at': launchedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (launchError != null) 'launch_error': launchError,
    });
  }

  PaymentAttemptsCompanion copyWith({
    Value<int>? id,
    Value<PaymentAttemptStatus>? status,
    Value<String>? payeeName,
    Value<String>? payeeVpa,
    Value<int>? amountPaise,
    Value<bool>? amountWasProvidedByQr,
    Value<String?>? rawQrPayload,
    Value<int?>? categoryId,
    Value<String?>? note,
    Value<int>? intendedAccountId,
    Value<int?>? actualFundingAccountId,
    Value<String?>? selectedPaymentAppId,
    Value<String?>? externalReference,
    Value<DateTime>? createdAt,
    Value<DateTime?>? launchedAt,
    Value<DateTime?>? resolvedAt,
    Value<int?>? linkedTransactionId,
    Value<String?>? launchError,
  }) {
    return PaymentAttemptsCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      payeeName: payeeName ?? this.payeeName,
      payeeVpa: payeeVpa ?? this.payeeVpa,
      amountPaise: amountPaise ?? this.amountPaise,
      amountWasProvidedByQr:
          amountWasProvidedByQr ?? this.amountWasProvidedByQr,
      rawQrPayload: rawQrPayload ?? this.rawQrPayload,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      intendedAccountId: intendedAccountId ?? this.intendedAccountId,
      actualFundingAccountId:
          actualFundingAccountId ?? this.actualFundingAccountId,
      selectedPaymentAppId: selectedPaymentAppId ?? this.selectedPaymentAppId,
      externalReference: externalReference ?? this.externalReference,
      createdAt: createdAt ?? this.createdAt,
      launchedAt: launchedAt ?? this.launchedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      launchError: launchError ?? this.launchError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PaymentAttemptsTable.$converterstatus.toSql(status.value),
      );
    }
    if (payeeName.present) {
      map['payee_name'] = Variable<String>(payeeName.value);
    }
    if (payeeVpa.present) {
      map['payee_vpa'] = Variable<String>(payeeVpa.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (amountWasProvidedByQr.present) {
      map['amount_was_provided_by_qr'] = Variable<bool>(
        amountWasProvidedByQr.value,
      );
    }
    if (rawQrPayload.present) {
      map['raw_qr_payload'] = Variable<String>(rawQrPayload.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (intendedAccountId.present) {
      map['intended_account_id'] = Variable<int>(intendedAccountId.value);
    }
    if (actualFundingAccountId.present) {
      map['actual_funding_account_id'] = Variable<int>(
        actualFundingAccountId.value,
      );
    }
    if (selectedPaymentAppId.present) {
      map['selected_payment_app_id'] = Variable<String>(
        selectedPaymentAppId.value,
      );
    }
    if (externalReference.present) {
      map['external_reference'] = Variable<String>(externalReference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (launchedAt.present) {
      map['launched_at'] = Variable<DateTime>(launchedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] = Variable<int>(linkedTransactionId.value);
    }
    if (launchError.present) {
      map['launch_error'] = Variable<String>(launchError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeVpa: $payeeVpa, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('amountWasProvidedByQr: $amountWasProvidedByQr, ')
          ..write('rawQrPayload: $rawQrPayload, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('intendedAccountId: $intendedAccountId, ')
          ..write('actualFundingAccountId: $actualFundingAccountId, ')
          ..write('selectedPaymentAppId: $selectedPaymentAppId, ')
          ..write('externalReference: $externalReference, ')
          ..write('createdAt: $createdAt, ')
          ..write('launchedAt: $launchedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('launchError: $launchError')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
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
  @override
  late final GeneratedColumnWithTypeConverter<TransactionSource, String>
  source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TransactionSource>($TransactionsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod, String>
  paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PaymentMethod>($TransactionsTable.$converterpaymentMethod);
  static const VerificationMeta _paymentAppIdMeta = const VerificationMeta(
    'paymentAppId',
  );
  @override
  late final GeneratedColumn<String> paymentAppId = GeneratedColumn<String>(
    'payment_app_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualFundingAccountIdMeta =
      const VerificationMeta('actualFundingAccountId');
  @override
  late final GeneratedColumn<int> actualFundingAccountId = GeneratedColumn<int>(
    'actual_funding_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _paymentAttemptIdMeta = const VerificationMeta(
    'paymentAttemptId',
  );
  @override
  late final GeneratedColumn<int> paymentAttemptId = GeneratedColumn<int>(
    'payment_attempt_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES payment_attempts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _externalReferenceMeta = const VerificationMeta(
    'externalReference',
  );
  @override
  late final GeneratedColumn<String> externalReference =
      GeneratedColumn<String>(
        'external_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    type,
    amountPaise,
    categoryId,
    merchant,
    note,
    occurredAt,
    createdAt,
    updatedAt,
    source,
    paymentMethod,
    paymentAppId,
    actualFundingAccountId,
    paymentAttemptId,
    externalReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
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
    if (data.containsKey('payment_app_id')) {
      context.handle(
        _paymentAppIdMeta,
        paymentAppId.isAcceptableOrUnknown(
          data['payment_app_id']!,
          _paymentAppIdMeta,
        ),
      );
    }
    if (data.containsKey('actual_funding_account_id')) {
      context.handle(
        _actualFundingAccountIdMeta,
        actualFundingAccountId.isAcceptableOrUnknown(
          data['actual_funding_account_id']!,
          _actualFundingAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('payment_attempt_id')) {
      context.handle(
        _paymentAttemptIdMeta,
        paymentAttemptId.isAcceptableOrUnknown(
          data['payment_attempt_id']!,
          _paymentAttemptIdMeta,
        ),
      );
    }
    if (data.containsKey('external_reference')) {
      context.handle(
        _externalReferenceMeta,
        externalReference.isAcceptableOrUnknown(
          data['external_reference']!,
          _externalReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      source: $TransactionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      paymentMethod: $TransactionsTable.$converterpaymentMethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_method'],
        )!,
      ),
      paymentAppId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_app_id'],
      ),
      actualFundingAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_funding_account_id'],
      ),
      paymentAttemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_attempt_id'],
      ),
      externalReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_reference'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionSource, String, String>
  $convertersource = const EnumNameConverter<TransactionSource>(
    TransactionSource.values,
  );
  static JsonTypeConverter2<PaymentMethod, String, String>
  $converterpaymentMethod = const EnumNameConverter<PaymentMethod>(
    PaymentMethod.values,
  );
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int accountId;
  final TransactionType type;
  final int amountPaise;
  final int? categoryId;
  final String? merchant;
  final String? note;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TransactionSource source;
  final PaymentMethod paymentMethod;
  final String? paymentAppId;
  final int? actualFundingAccountId;
  final int? paymentAttemptId;
  final String? externalReference;
  const Transaction({
    required this.id,
    required this.accountId,
    required this.type,
    required this.amountPaise,
    this.categoryId,
    this.merchant,
    this.note,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.source,
    required this.paymentMethod,
    this.paymentAppId,
    this.actualFundingAccountId,
    this.paymentAttemptId,
    this.externalReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount_paise'] = Variable<int>(amountPaise);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source),
      );
    }
    {
      map['payment_method'] = Variable<String>(
        $TransactionsTable.$converterpaymentMethod.toSql(paymentMethod),
      );
    }
    if (!nullToAbsent || paymentAppId != null) {
      map['payment_app_id'] = Variable<String>(paymentAppId);
    }
    if (!nullToAbsent || actualFundingAccountId != null) {
      map['actual_funding_account_id'] = Variable<int>(actualFundingAccountId);
    }
    if (!nullToAbsent || paymentAttemptId != null) {
      map['payment_attempt_id'] = Variable<int>(paymentAttemptId);
    }
    if (!nullToAbsent || externalReference != null) {
      map['external_reference'] = Variable<String>(externalReference);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      type: Value(type),
      amountPaise: Value(amountPaise),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      source: Value(source),
      paymentMethod: Value(paymentMethod),
      paymentAppId: paymentAppId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentAppId),
      actualFundingAccountId: actualFundingAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(actualFundingAccountId),
      paymentAttemptId: paymentAttemptId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentAttemptId),
      externalReference: externalReference == null && nullToAbsent
          ? const Value.absent()
          : Value(externalReference),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      note: serializer.fromJson<String?>(json['note']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      source: $TransactionsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      paymentMethod: $TransactionsTable.$converterpaymentMethod.fromJson(
        serializer.fromJson<String>(json['paymentMethod']),
      ),
      paymentAppId: serializer.fromJson<String?>(json['paymentAppId']),
      actualFundingAccountId: serializer.fromJson<int?>(
        json['actualFundingAccountId'],
      ),
      paymentAttemptId: serializer.fromJson<int?>(json['paymentAttemptId']),
      externalReference: serializer.fromJson<String?>(
        json['externalReference'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'categoryId': serializer.toJson<int?>(categoryId),
      'merchant': serializer.toJson<String?>(merchant),
      'note': serializer.toJson<String?>(note),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'source': serializer.toJson<String>(
        $TransactionsTable.$convertersource.toJson(source),
      ),
      'paymentMethod': serializer.toJson<String>(
        $TransactionsTable.$converterpaymentMethod.toJson(paymentMethod),
      ),
      'paymentAppId': serializer.toJson<String?>(paymentAppId),
      'actualFundingAccountId': serializer.toJson<int?>(actualFundingAccountId),
      'paymentAttemptId': serializer.toJson<int?>(paymentAttemptId),
      'externalReference': serializer.toJson<String?>(externalReference),
    };
  }

  Transaction copyWith({
    int? id,
    int? accountId,
    TransactionType? type,
    int? amountPaise,
    Value<int?> categoryId = const Value.absent(),
    Value<String?> merchant = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? occurredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    TransactionSource? source,
    PaymentMethod? paymentMethod,
    Value<String?> paymentAppId = const Value.absent(),
    Value<int?> actualFundingAccountId = const Value.absent(),
    Value<int?> paymentAttemptId = const Value.absent(),
    Value<String?> externalReference = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    type: type ?? this.type,
    amountPaise: amountPaise ?? this.amountPaise,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    merchant: merchant.present ? merchant.value : this.merchant,
    note: note.present ? note.value : this.note,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    source: source ?? this.source,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentAppId: paymentAppId.present ? paymentAppId.value : this.paymentAppId,
    actualFundingAccountId: actualFundingAccountId.present
        ? actualFundingAccountId.value
        : this.actualFundingAccountId,
    paymentAttemptId: paymentAttemptId.present
        ? paymentAttemptId.value
        : this.paymentAttemptId,
    externalReference: externalReference.present
        ? externalReference.value
        : this.externalReference,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      type: data.type.present ? data.type.value : this.type,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      note: data.note.present ? data.note.value : this.note,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      source: data.source.present ? data.source.value : this.source,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentAppId: data.paymentAppId.present
          ? data.paymentAppId.value
          : this.paymentAppId,
      actualFundingAccountId: data.actualFundingAccountId.present
          ? data.actualFundingAccountId.value
          : this.actualFundingAccountId,
      paymentAttemptId: data.paymentAttemptId.present
          ? data.paymentAttemptId.value
          : this.paymentAttemptId,
      externalReference: data.externalReference.present
          ? data.externalReference.value
          : this.externalReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('type: $type, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('categoryId: $categoryId, ')
          ..write('merchant: $merchant, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('source: $source, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentAppId: $paymentAppId, ')
          ..write('actualFundingAccountId: $actualFundingAccountId, ')
          ..write('paymentAttemptId: $paymentAttemptId, ')
          ..write('externalReference: $externalReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    type,
    amountPaise,
    categoryId,
    merchant,
    note,
    occurredAt,
    createdAt,
    updatedAt,
    source,
    paymentMethod,
    paymentAppId,
    actualFundingAccountId,
    paymentAttemptId,
    externalReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.type == this.type &&
          other.amountPaise == this.amountPaise &&
          other.categoryId == this.categoryId &&
          other.merchant == this.merchant &&
          other.note == this.note &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.source == this.source &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentAppId == this.paymentAppId &&
          other.actualFundingAccountId == this.actualFundingAccountId &&
          other.paymentAttemptId == this.paymentAttemptId &&
          other.externalReference == this.externalReference);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<TransactionType> type;
  final Value<int> amountPaise;
  final Value<int?> categoryId;
  final Value<String?> merchant;
  final Value<String?> note;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<TransactionSource> source;
  final Value<PaymentMethod> paymentMethod;
  final Value<String?> paymentAppId;
  final Value<int?> actualFundingAccountId;
  final Value<int?> paymentAttemptId;
  final Value<String?> externalReference;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.merchant = const Value.absent(),
    this.note = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentAppId = const Value.absent(),
    this.actualFundingAccountId = const Value.absent(),
    this.paymentAttemptId = const Value.absent(),
    this.externalReference = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required TransactionType type,
    required int amountPaise,
    this.categoryId = const Value.absent(),
    this.merchant = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime occurredAt,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required TransactionSource source,
    required PaymentMethod paymentMethod,
    this.paymentAppId = const Value.absent(),
    this.actualFundingAccountId = const Value.absent(),
    this.paymentAttemptId = const Value.absent(),
    this.externalReference = const Value.absent(),
  }) : accountId = Value(accountId),
       type = Value(type),
       amountPaise = Value(amountPaise),
       occurredAt = Value(occurredAt),
       source = Value(source),
       paymentMethod = Value(paymentMethod);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? type,
    Expression<int>? amountPaise,
    Expression<int>? categoryId,
    Expression<String>? merchant,
    Expression<String>? note,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? source,
    Expression<String>? paymentMethod,
    Expression<String>? paymentAppId,
    Expression<int>? actualFundingAccountId,
    Expression<int>? paymentAttemptId,
    Expression<String>? externalReference,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (type != null) 'type': type,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (categoryId != null) 'category_id': categoryId,
      if (merchant != null) 'merchant': merchant,
      if (note != null) 'note': note,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (source != null) 'source': source,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentAppId != null) 'payment_app_id': paymentAppId,
      if (actualFundingAccountId != null)
        'actual_funding_account_id': actualFundingAccountId,
      if (paymentAttemptId != null) 'payment_attempt_id': paymentAttemptId,
      if (externalReference != null) 'external_reference': externalReference,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<TransactionType>? type,
    Value<int>? amountPaise,
    Value<int?>? categoryId,
    Value<String?>? merchant,
    Value<String?>? note,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<TransactionSource>? source,
    Value<PaymentMethod>? paymentMethod,
    Value<String?>? paymentAppId,
    Value<int?>? actualFundingAccountId,
    Value<int?>? paymentAttemptId,
    Value<String?>? externalReference,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      type: type ?? this.type,
      amountPaise: amountPaise ?? this.amountPaise,
      categoryId: categoryId ?? this.categoryId,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      source: source ?? this.source,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentAppId: paymentAppId ?? this.paymentAppId,
      actualFundingAccountId:
          actualFundingAccountId ?? this.actualFundingAccountId,
      paymentAttemptId: paymentAttemptId ?? this.paymentAttemptId,
      externalReference: externalReference ?? this.externalReference,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source.value),
      );
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(
        $TransactionsTable.$converterpaymentMethod.toSql(paymentMethod.value),
      );
    }
    if (paymentAppId.present) {
      map['payment_app_id'] = Variable<String>(paymentAppId.value);
    }
    if (actualFundingAccountId.present) {
      map['actual_funding_account_id'] = Variable<int>(
        actualFundingAccountId.value,
      );
    }
    if (paymentAttemptId.present) {
      map['payment_attempt_id'] = Variable<int>(paymentAttemptId.value);
    }
    if (externalReference.present) {
      map['external_reference'] = Variable<String>(externalReference.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('type: $type, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('categoryId: $categoryId, ')
          ..write('merchant: $merchant, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('source: $source, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentAppId: $paymentAppId, ')
          ..write('actualFundingAccountId: $actualFundingAccountId, ')
          ..write('paymentAttemptId: $paymentAttemptId, ')
          ..write('externalReference: $externalReference')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceAccountIdMeta = const VerificationMeta(
    'sourceAccountId',
  );
  @override
  late final GeneratedColumn<int> sourceAccountId = GeneratedColumn<int>(
    'source_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<int> destinationAccountId = GeneratedColumn<int>(
    'destination_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    sourceAccountId,
    destinationAccountId,
    amountPaise,
    occurredAt,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transfer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
        _sourceAccountIdMeta,
        sourceAccountId.isAcceptableOrUnknown(
          data['source_account_id']!,
          _sourceAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAccountIdMeta);
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
        _destinationAccountIdMeta,
        destinationAccountId.isAcceptableOrUnknown(
          data['destination_account_id']!,
          _destinationAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationAccountIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_account_id'],
      )!,
      destinationAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}destination_account_id'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final int sourceAccountId;
  final int destinationAccountId;
  final int amountPaise;
  final DateTime occurredAt;
  final String? note;
  final DateTime createdAt;
  const Transfer({
    required this.id,
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.amountPaise,
    required this.occurredAt,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_account_id'] = Variable<int>(sourceAccountId);
    map['destination_account_id'] = Variable<int>(destinationAccountId);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: Value(id),
      sourceAccountId: Value(sourceAccountId),
      destinationAccountId: Value(destinationAccountId),
      amountPaise: Value(amountPaise),
      occurredAt: Value(occurredAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Transfer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      sourceAccountId: serializer.fromJson<int>(json['sourceAccountId']),
      destinationAccountId: serializer.fromJson<int>(
        json['destinationAccountId'],
      ),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceAccountId': serializer.toJson<int>(sourceAccountId),
      'destinationAccountId': serializer.toJson<int>(destinationAccountId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transfer copyWith({
    int? id,
    int? sourceAccountId,
    int? destinationAccountId,
    int? amountPaise,
    DateTime? occurredAt,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Transfer(
    id: id ?? this.id,
    sourceAccountId: sourceAccountId ?? this.sourceAccountId,
    destinationAccountId: destinationAccountId ?? this.destinationAccountId,
    amountPaise: amountPaise ?? this.amountPaise,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Transfer copyWithCompanion(TransfersCompanion data) {
    return Transfer(
      id: data.id.present ? data.id.value : this.id,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceAccountId,
    destinationAccountId,
    amountPaise,
    occurredAt,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.sourceAccountId == this.sourceAccountId &&
          other.destinationAccountId == this.destinationAccountId &&
          other.amountPaise == this.amountPaise &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<int> sourceAccountId;
  final Value<int> destinationAccountId;
  final Value<int> amountPaise;
  final Value<DateTime> occurredAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    required int sourceAccountId,
    required int destinationAccountId,
    required int amountPaise,
    required DateTime occurredAt,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sourceAccountId = Value(sourceAccountId),
       destinationAccountId = Value(destinationAccountId),
       amountPaise = Value(amountPaise),
       occurredAt = Value(occurredAt);
  static Insertable<Transfer> custom({
    Expression<int>? id,
    Expression<int>? sourceAccountId,
    Expression<int>? destinationAccountId,
    Expression<int>? amountPaise,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransfersCompanion copyWith({
    Value<int>? id,
    Value<int>? sourceAccountId,
    Value<int>? destinationAccountId,
    Value<int>? amountPaise,
    Value<DateTime>? occurredAt,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return TransfersCompanion(
      id: id ?? this.id,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      amountPaise: amountPaise ?? this.amountPaise,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<int>(sourceAccountId.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] = Variable<int>(destinationAccountId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PaymentAttemptsTable paymentAttempts = $PaymentAttemptsTable(
    this,
  );
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final TransactionsDao transactionsDao = TransactionsDao(
    this as AppDatabase,
  );
  late final TransfersDao transfersDao = TransfersDao(this as AppDatabase);
  late final PaymentAttemptsDao paymentAttemptsDao = PaymentAttemptsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    categories,
    paymentAttempts,
    transactions,
    transfers,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payment_attempts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payment_attempts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payment_attempts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  required AccountType type,
  Value<int> openingBalancePaise,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isArchived,
  Value<String?> iconKey,
  Value<String?> colourKey,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<AccountType> type,
  Value<int> openingBalancePaise,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isArchived,
  Value<String?> iconKey,
  Value<String?> colourKey,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PaymentAttemptsTable, List<PaymentAttempt>>
  _intendedAccountPaymentAttemptsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentAttempts,
        aliasName: 'accounts__id__payment_attempts__intended_account_id',
      );

  $$PaymentAttemptsTableProcessedTableManager
  get intendedAccountPaymentAttempts {
    final manager = $$PaymentAttemptsTableTableManager(
      $_db,
      $_db.paymentAttempts,
    ).filter((f) => f.intendedAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _intendedAccountPaymentAttemptsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentAttemptsTable, List<PaymentAttempt>>
  _actualFundingAccountPaymentAttemptsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentAttempts,
        aliasName: 'accounts__id__payment_attempts__actual_funding_account_id',
      );

  $$PaymentAttemptsTableProcessedTableManager
  get actualFundingAccountPaymentAttempts {
    final manager =
        $$PaymentAttemptsTableTableManager($_db, $_db.paymentAttempts).filter(
          (f) =>
              f.actualFundingAccountId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _actualFundingAccountPaymentAttemptsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _accountTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableProcessedTableManager get accountTransactions {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accountTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _actualFundingAccountTransactionsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactions,
        aliasName: 'accounts__id__transactions__actual_funding_account_id',
      );

  $$TransactionsTableProcessedTableManager
  get actualFundingAccountTransactions {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter(
          (f) =>
              f.actualFundingAccountId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _actualFundingAccountTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransfersTable, List<Transfer>>
  _outgoingTransfersTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transfers,
    aliasName: 'accounts__id__transfers__source_account_id',
  );

  $$TransfersTableProcessedTableManager get outgoingTransfers {
    final manager = $$TransfersTableTableManager(
      $_db,
      $_db.transfers,
    ).filter((f) => f.sourceAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_outgoingTransfersTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransfersTable, List<Transfer>>
  _incomingTransfersTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transfers,
    aliasName: 'accounts__id__transfers__destination_account_id',
  );

  $$TransfersTableProcessedTableManager get incomingTransfers {
    final manager = $$TransfersTableTableManager($_db, $_db.transfers).filter(
      (f) => f.destinationAccountId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_incomingTransfersTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get openingBalancePaise => $composableBuilder(
    column: $table.openingBalancePaise,
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

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colourKey => $composableBuilder(
    column: $table.colourKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> intendedAccountPaymentAttempts(
    Expression<bool> Function($$PaymentAttemptsTableFilterComposer f) f,
  ) {
    final $$PaymentAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.intendedAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> actualFundingAccountPaymentAttempts(
    Expression<bool> Function($$PaymentAttemptsTableFilterComposer f) f,
  ) {
    final $$PaymentAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.actualFundingAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountTransactions(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> actualFundingAccountTransactions(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.actualFundingAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> outgoingTransfers(
    Expression<bool> Function($$TransfersTableFilterComposer f) f,
  ) {
    final $$TransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableFilterComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingTransfers(
    Expression<bool> Function($$TransfersTableFilterComposer f) f,
  ) {
    final $$TransfersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.destinationAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableFilterComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalancePaise => $composableBuilder(
    column: $table.openingBalancePaise,
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

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colourKey => $composableBuilder(
    column: $table.colourKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get openingBalancePaise => $composableBuilder(
    column: $table.openingBalancePaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get colourKey =>
      $composableBuilder(column: $table.colourKey, builder: (column) => column);

  Expression<T> intendedAccountPaymentAttempts<T extends Object>(
    Expression<T> Function($$PaymentAttemptsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.intendedAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> actualFundingAccountPaymentAttempts<T extends Object>(
    Expression<T> Function($$PaymentAttemptsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.actualFundingAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accountTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> actualFundingAccountTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.actualFundingAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> outgoingTransfers<T extends Object>(
    Expression<T> Function($$TransfersTableAnnotationComposer a) f,
  ) {
    final $$TransfersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.sourceAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableAnnotationComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomingTransfers<T extends Object>(
    Expression<T> Function($$TransfersTableAnnotationComposer a) f,
  ) {
    final $$TransfersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfers,
      getReferencedColumn: (t) => t.destinationAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableAnnotationComposer(
            $db: $db,
            $table: $db.transfers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool intendedAccountPaymentAttempts,
            bool actualFundingAccountPaymentAttempts,
            bool accountTransactions,
            bool actualFundingAccountTransactions,
            bool outgoingTransfers,
            bool incomingTransfers,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<int> openingBalancePaise = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<String?> colourKey = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                type: type,
                openingBalancePaise: openingBalancePaise,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                iconKey: iconKey,
                colourKey: colourKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required AccountType type,
                Value<int> openingBalancePaise = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<String?> colourKey = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                openingBalancePaise: openingBalancePaise,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                iconKey: iconKey,
                colourKey: colourKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, Account>(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                intendedAccountPaymentAttempts = false,
                actualFundingAccountPaymentAttempts = false,
                accountTransactions = false,
                actualFundingAccountTransactions = false,
                outgoingTransfers = false,
                incomingTransfers = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (intendedAccountPaymentAttempts) db.paymentAttempts,
                    if (actualFundingAccountPaymentAttempts) db.paymentAttempts,
                    if (accountTransactions) db.transactions,
                    if (actualFundingAccountTransactions) db.transactions,
                    if (outgoingTransfers) db.transfers,
                    if (incomingTransfers) db.transfers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (intendedAccountPaymentAttempts)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          PaymentAttempt,
                          $PaymentAttemptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._intendedAccountPaymentAttemptsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).intendedAccountPaymentAttempts,
                          currentColumn: 'id',
                          referencedColumn: 'intended_account_id',
                          typedResults: items,
                        ),
                      if (actualFundingAccountPaymentAttempts)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          PaymentAttempt,
                          $PaymentAttemptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._actualFundingAccountPaymentAttemptsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).actualFundingAccountPaymentAttempts,
                          currentColumn: 'id',
                          referencedColumn: 'actual_funding_account_id',
                          typedResults: items,
                        ),
                      if (accountTransactions)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          Transaction,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._accountTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).accountTransactions,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (actualFundingAccountTransactions)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          Transaction,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._actualFundingAccountTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).actualFundingAccountTransactions,
                          currentColumn: 'id',
                          referencedColumn: 'actual_funding_account_id',
                          typedResults: items,
                        ),
                      if (outgoingTransfers)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          Transfer,
                          $TransfersTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._outgoingTransfersTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingTransfers,
                          currentColumn: 'id',
                          referencedColumn: 'source_account_id',
                          typedResults: items,
                        ),
                      if (incomingTransfers)
                        await $_getPrefetchedDataByColumns<
                          Account,
                          $AccountsTable,
                          Transfer,
                          $TransfersTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._incomingTransfersTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingTransfers,
                          currentColumn: 'id',
                          referencedColumn: 'destination_account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool intendedAccountPaymentAttempts,
        bool actualFundingAccountPaymentAttempts,
        bool accountTransactions,
        bool actualFundingAccountTransactions,
        bool outgoingTransfers,
        bool incomingTransfers,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required CategoryKind kind,
  Value<String?> iconKey,
  Value<bool> isDefault,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<CategoryKind> kind,
  Value<String?> iconKey,
  Value<bool> isDefault,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PaymentAttemptsTable, List<PaymentAttempt>>
  _paymentAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentAttempts,
    aliasName: 'categories__id__payment_attempts__category_id',
  );

  $$PaymentAttemptsTableProcessedTableManager get paymentAttemptsRefs {
    final manager = $$PaymentAttemptsTableTableManager(
      $_db,
      $_db.paymentAttempts,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryKind, CategoryKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> paymentAttemptsRefs(
    Expression<bool> Function($$PaymentAttemptsTableFilterComposer f) f,
  ) {
    final $$PaymentAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> paymentAttemptsRefs<T extends Object>(
    Expression<T> Function($$PaymentAttemptsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool paymentAttemptsRefs,
            bool transactionsRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryKind> kind = const Value.absent(),
                Value<String?> iconKey = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                kind: kind,
                iconKey: iconKey,
                isDefault: isDefault,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required CategoryKind kind,
                Value<String?> iconKey = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                iconKey: iconKey,
                isDefault: isDefault,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({paymentAttemptsRefs = false, transactionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paymentAttemptsRefs) db.paymentAttempts,
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paymentAttemptsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          PaymentAttempt,
                          $PaymentAttemptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._paymentAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentAttemptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          Transaction,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool paymentAttemptsRefs, bool transactionsRefs})
    >;
typedef $$PaymentAttemptsTableCreateCompanionBuilder =
    PaymentAttemptsCompanion Function({
      Value<int> id,
      required PaymentAttemptStatus status,
      required String payeeName,
      required String payeeVpa,
      required int amountPaise,
      required bool amountWasProvidedByQr,
      Value<String?> rawQrPayload,
      Value<int?> categoryId,
      Value<String?> note,
      required int intendedAccountId,
      Value<int?> actualFundingAccountId,
      Value<String?> selectedPaymentAppId,
      Value<String?> externalReference,
      Value<DateTime> createdAt,
      Value<DateTime?> launchedAt,
      Value<DateTime?> resolvedAt,
      Value<int?> linkedTransactionId,
      Value<String?> launchError,
    });
typedef $$PaymentAttemptsTableUpdateCompanionBuilder =
    PaymentAttemptsCompanion Function({
      Value<int> id,
      Value<PaymentAttemptStatus> status,
      Value<String> payeeName,
      Value<String> payeeVpa,
      Value<int> amountPaise,
      Value<bool> amountWasProvidedByQr,
      Value<String?> rawQrPayload,
      Value<int?> categoryId,
      Value<String?> note,
      Value<int> intendedAccountId,
      Value<int?> actualFundingAccountId,
      Value<String?> selectedPaymentAppId,
      Value<String?> externalReference,
      Value<DateTime> createdAt,
      Value<DateTime?> launchedAt,
      Value<DateTime?> resolvedAt,
      Value<int?> linkedTransactionId,
      Value<String?> launchError,
    });

final class $$PaymentAttemptsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PaymentAttemptsTable, PaymentAttempt> {
  $$PaymentAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) => db.categories
      .createAlias('payment_attempts__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _intendedAccountIdTable(_$AppDatabase db) => db.accounts
      .createAlias('payment_attempts__intended_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get intendedAccountId {
    final $_column = $_itemColumn<int>('intended_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_intendedAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _actualFundingAccountIdTable(_$AppDatabase db) => db
      .accounts
      .createAlias('payment_attempts__actual_funding_account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get actualFundingAccountId {
    final $_column = $_itemColumn<int>('actual_funding_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _actualFundingAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _linkedTransactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('payment_attempts__linked_transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get linkedTransactionId {
    final $_column = $_itemColumn<int>('linked_transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'payment_attempts__id__transactions__payment_attempt_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.paymentAttemptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAttemptsTable> {
  $$PaymentAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PaymentAttemptStatus,
    PaymentAttemptStatus,
    String
  >
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get payeeName => $composableBuilder(
    column: $table.payeeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payeeVpa => $composableBuilder(
    column: $table.payeeVpa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get amountWasProvidedByQr => $composableBuilder(
    column: $table.amountWasProvidedByQr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawQrPayload => $composableBuilder(
    column: $table.rawQrPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedPaymentAppId => $composableBuilder(
    column: $table.selectedPaymentAppId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get launchedAt => $composableBuilder(
    column: $table.launchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get launchError => $composableBuilder(
    column: $table.launchError,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get intendedAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intendedAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get actualFundingAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actualFundingAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get linkedTransactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.paymentAttemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAttemptsTable> {
  $$PaymentAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payeeName => $composableBuilder(
    column: $table.payeeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payeeVpa => $composableBuilder(
    column: $table.payeeVpa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get amountWasProvidedByQr => $composableBuilder(
    column: $table.amountWasProvidedByQr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawQrPayload => $composableBuilder(
    column: $table.rawQrPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedPaymentAppId => $composableBuilder(
    column: $table.selectedPaymentAppId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get launchedAt => $composableBuilder(
    column: $table.launchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get launchError => $composableBuilder(
    column: $table.launchError,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get intendedAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intendedAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get actualFundingAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actualFundingAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get linkedTransactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAttemptsTable> {
  $$PaymentAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentAttemptStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => column);

  GeneratedColumn<String> get payeeVpa =>
      $composableBuilder(column: $table.payeeVpa, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get amountWasProvidedByQr => $composableBuilder(
    column: $table.amountWasProvidedByQr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawQrPayload => $composableBuilder(
    column: $table.rawQrPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get selectedPaymentAppId => $composableBuilder(
    column: $table.selectedPaymentAppId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get launchedAt => $composableBuilder(
    column: $table.launchedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get launchError => $composableBuilder(
    column: $table.launchError,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get intendedAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intendedAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get actualFundingAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actualFundingAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get linkedTransactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.paymentAttemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentAttemptsTable,
          PaymentAttempt,
          $$PaymentAttemptsTableFilterComposer,
          $$PaymentAttemptsTableOrderingComposer,
          $$PaymentAttemptsTableAnnotationComposer,
          $$PaymentAttemptsTableCreateCompanionBuilder,
          $$PaymentAttemptsTableUpdateCompanionBuilder,
          (PaymentAttempt, $$PaymentAttemptsTableReferences),
          PaymentAttempt,
          PrefetchHooks Function({
            bool categoryId,
            bool intendedAccountId,
            bool actualFundingAccountId,
            bool linkedTransactionId,
            bool transactionsRefs,
          })
        > {
  $$PaymentAttemptsTableTableManager(
    _$AppDatabase db,
    $PaymentAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<PaymentAttemptStatus> status = const Value.absent(),
                Value<String> payeeName = const Value.absent(),
                Value<String> payeeVpa = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<bool> amountWasProvidedByQr = const Value.absent(),
                Value<String?> rawQrPayload = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> intendedAccountId = const Value.absent(),
                Value<int?> actualFundingAccountId = const Value.absent(),
                Value<String?> selectedPaymentAppId = const Value.absent(),
                Value<String?> externalReference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> launchedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int?> linkedTransactionId = const Value.absent(),
                Value<String?> launchError = const Value.absent(),
              }) => PaymentAttemptsCompanion(
                id: id,
                status: status,
                payeeName: payeeName,
                payeeVpa: payeeVpa,
                amountPaise: amountPaise,
                amountWasProvidedByQr: amountWasProvidedByQr,
                rawQrPayload: rawQrPayload,
                categoryId: categoryId,
                note: note,
                intendedAccountId: intendedAccountId,
                actualFundingAccountId: actualFundingAccountId,
                selectedPaymentAppId: selectedPaymentAppId,
                externalReference: externalReference,
                createdAt: createdAt,
                launchedAt: launchedAt,
                resolvedAt: resolvedAt,
                linkedTransactionId: linkedTransactionId,
                launchError: launchError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required PaymentAttemptStatus status,
                required String payeeName,
                required String payeeVpa,
                required int amountPaise,
                required bool amountWasProvidedByQr,
                Value<String?> rawQrPayload = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int intendedAccountId,
                Value<int?> actualFundingAccountId = const Value.absent(),
                Value<String?> selectedPaymentAppId = const Value.absent(),
                Value<String?> externalReference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> launchedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int?> linkedTransactionId = const Value.absent(),
                Value<String?> launchError = const Value.absent(),
              }) => PaymentAttemptsCompanion.insert(
                id: id,
                status: status,
                payeeName: payeeName,
                payeeVpa: payeeVpa,
                amountPaise: amountPaise,
                amountWasProvidedByQr: amountWasProvidedByQr,
                rawQrPayload: rawQrPayload,
                categoryId: categoryId,
                note: note,
                intendedAccountId: intendedAccountId,
                actualFundingAccountId: actualFundingAccountId,
                selectedPaymentAppId: selectedPaymentAppId,
                externalReference: externalReference,
                createdAt: createdAt,
                launchedAt: launchedAt,
                resolvedAt: resolvedAt,
                linkedTransactionId: linkedTransactionId,
                launchError: launchError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentAttemptsTable, PaymentAttempt>(table),
                  $$PaymentAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                intendedAccountId = false,
                actualFundingAccountId = false,
                linkedTransactionId = false,
                transactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$PaymentAttemptsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$PaymentAttemptsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (intendedAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.intendedAccountId,
                            referencedTable: $$PaymentAttemptsTableReferences
                                ._intendedAccountIdTable(db),
                            referencedColumn: $$PaymentAttemptsTableReferences
                                ._intendedAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (actualFundingAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.actualFundingAccountId,
                            referencedTable: $$PaymentAttemptsTableReferences
                                ._actualFundingAccountIdTable(db),
                            referencedColumn: $$PaymentAttemptsTableReferences
                                ._actualFundingAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (linkedTransactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.linkedTransactionId,
                            referencedTable: $$PaymentAttemptsTableReferences
                                ._linkedTransactionIdTable(db),
                            referencedColumn: $$PaymentAttemptsTableReferences
                                ._linkedTransactionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          PaymentAttempt,
                          $PaymentAttemptsTable,
                          Transaction,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PaymentAttemptsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PaymentAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'payment_attempt_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentAttemptsTable,
      PaymentAttempt,
      $$PaymentAttemptsTableFilterComposer,
      $$PaymentAttemptsTableOrderingComposer,
      $$PaymentAttemptsTableAnnotationComposer,
      $$PaymentAttemptsTableCreateCompanionBuilder,
      $$PaymentAttemptsTableUpdateCompanionBuilder,
      (PaymentAttempt, $$PaymentAttemptsTableReferences),
      PaymentAttempt,
      PrefetchHooks Function({
        bool categoryId,
        bool intendedAccountId,
        bool actualFundingAccountId,
        bool linkedTransactionId,
        bool transactionsRefs,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int accountId,
      required TransactionType type,
      required int amountPaise,
      Value<int?> categoryId,
      Value<String?> merchant,
      Value<String?> note,
      required DateTime occurredAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required TransactionSource source,
      required PaymentMethod paymentMethod,
      Value<String?> paymentAppId,
      Value<int?> actualFundingAccountId,
      Value<int?> paymentAttemptId,
      Value<String?> externalReference,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<TransactionType> type,
      Value<int> amountPaise,
      Value<int?> categoryId,
      Value<String?> merchant,
      Value<String?> note,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<TransactionSource> source,
      Value<PaymentMethod> paymentMethod,
      Value<String?> paymentAppId,
      Value<int?> actualFundingAccountId,
      Value<int?> paymentAttemptId,
      Value<String?> externalReference,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _actualFundingAccountIdTable(_$AppDatabase db) => db
      .accounts
      .createAlias('transactions__actual_funding_account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get actualFundingAccountId {
    final $_column = $_itemColumn<int>('actual_funding_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _actualFundingAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PaymentAttemptsTable _paymentAttemptIdTable(_$AppDatabase db) => db
      .paymentAttempts
      .createAlias('transactions__payment_attempt_id__payment_attempts__id');

  $$PaymentAttemptsTableProcessedTableManager? get paymentAttemptId {
    final $_column = $_itemColumn<int>('payment_attempt_id');
    if ($_column == null) return null;
    final manager = $$PaymentAttemptsTableTableManager(
      $_db,
      $_db.paymentAttempts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentAttemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentAttemptsTable, List<PaymentAttempt>>
  _paymentAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentAttempts,
    aliasName: 'transactions__id__payment_attempts__linked_transaction_id',
  );

  $$PaymentAttemptsTableProcessedTableManager get paymentAttemptsRefs {
    final manager =
        $$PaymentAttemptsTableTableManager($_db, $_db.paymentAttempts).filter(
          (f) => f.linkedTransactionId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _paymentAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
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

  ColumnWithTypeConverterFilters<TransactionSource, TransactionSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMethod, PaymentMethod, String>
  get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get paymentAppId => $composableBuilder(
    column: $table.paymentAppId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get actualFundingAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actualFundingAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentAttemptsTableFilterComposer get paymentAttemptId {
    final $$PaymentAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentAttemptId,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentAttemptsRefs(
    Expression<bool> Function($$PaymentAttemptsTableFilterComposer f) f,
  ) {
    final $$PaymentAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.linkedTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentAppId => $composableBuilder(
    column: $table.paymentAppId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get actualFundingAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actualFundingAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentAttemptsTableOrderingComposer get paymentAttemptId {
    final $$PaymentAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentAttemptId,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMethod, String> get paymentMethod =>
      $composableBuilder(
        column: $table.paymentMethod,
        builder: (column) => column,
      );

  GeneratedColumn<String> get paymentAppId => $composableBuilder(
    column: $table.paymentAppId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalReference => $composableBuilder(
    column: $table.externalReference,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get actualFundingAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actualFundingAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PaymentAttemptsTableAnnotationComposer get paymentAttemptId {
    final $$PaymentAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentAttemptId,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentAttemptsRefs<T extends Object>(
    Expression<T> Function($$PaymentAttemptsTableAnnotationComposer a) f,
  ) {
    final $$PaymentAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentAttempts,
      getReferencedColumn: (t) => t.linkedTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool accountId,
            bool categoryId,
            bool actualFundingAccountId,
            bool paymentAttemptId,
            bool paymentAttemptsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<TransactionSource> source = const Value.absent(),
                Value<PaymentMethod> paymentMethod = const Value.absent(),
                Value<String?> paymentAppId = const Value.absent(),
                Value<int?> actualFundingAccountId = const Value.absent(),
                Value<int?> paymentAttemptId = const Value.absent(),
                Value<String?> externalReference = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                accountId: accountId,
                type: type,
                amountPaise: amountPaise,
                categoryId: categoryId,
                merchant: merchant,
                note: note,
                occurredAt: occurredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                source: source,
                paymentMethod: paymentMethod,
                paymentAppId: paymentAppId,
                actualFundingAccountId: actualFundingAccountId,
                paymentAttemptId: paymentAttemptId,
                externalReference: externalReference,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required TransactionType type,
                required int amountPaise,
                Value<int?> categoryId = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime occurredAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required TransactionSource source,
                required PaymentMethod paymentMethod,
                Value<String?> paymentAppId = const Value.absent(),
                Value<int?> actualFundingAccountId = const Value.absent(),
                Value<int?> paymentAttemptId = const Value.absent(),
                Value<String?> externalReference = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                accountId: accountId,
                type: type,
                amountPaise: amountPaise,
                categoryId: categoryId,
                merchant: merchant,
                note: note,
                occurredAt: occurredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                source: source,
                paymentMethod: paymentMethod,
                paymentAppId: paymentAppId,
                actualFundingAccountId: actualFundingAccountId,
                paymentAttemptId: paymentAttemptId,
                externalReference: externalReference,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Transaction>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                categoryId = false,
                actualFundingAccountId = false,
                paymentAttemptId = false,
                paymentAttemptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paymentAttemptsRefs) db.paymentAttempts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionsTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (actualFundingAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.actualFundingAccountId,
                            referencedTable: $$TransactionsTableReferences
                                ._actualFundingAccountIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._actualFundingAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (paymentAttemptId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.paymentAttemptId,
                            referencedTable: $$TransactionsTableReferences
                                ._paymentAttemptIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._paymentAttemptIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paymentAttemptsRefs)
                        await $_getPrefetchedDataByColumns<
                          Transaction,
                          $TransactionsTable,
                          PaymentAttempt,
                          $PaymentAttemptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._paymentAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentAttemptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'linked_transaction_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool accountId,
        bool categoryId,
        bool actualFundingAccountId,
        bool paymentAttemptId,
        bool paymentAttemptsRefs,
      })
    >;
typedef $$TransfersTableCreateCompanionBuilder = TransfersCompanion Function({
  Value<int> id,
  required int sourceAccountId,
  required int destinationAccountId,
  required int amountPaise,
  required DateTime occurredAt,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$TransfersTableUpdateCompanionBuilder = TransfersCompanion Function({
  Value<int> id,
  Value<int> sourceAccountId,
  Value<int> destinationAccountId,
  Value<int> amountPaise,
  Value<DateTime> occurredAt,
  Value<String?> note,
  Value<DateTime> createdAt,
});

final class $$TransfersTableReferences
    extends BaseReferences<_$AppDatabase, $TransfersTable, Transfer> {
  $$TransfersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _sourceAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('transfers__source_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get sourceAccountId {
    final $_column = $_itemColumn<int>('source_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _destinationAccountIdTable(_$AppDatabase db) => db
      .accounts
      .createAlias('transfers__destination_account_id__accounts__id');

  $$AccountsTableProcessedTableManager get destinationAccountId {
    final $_column = $_itemColumn<int>('destination_account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _destinationAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransfersTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get sourceAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get destinationAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get sourceAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get destinationAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get sourceAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get destinationAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransfersTable,
          Transfer,
          $$TransfersTableFilterComposer,
          $$TransfersTableOrderingComposer,
          $$TransfersTableAnnotationComposer,
          $$TransfersTableCreateCompanionBuilder,
          $$TransfersTableUpdateCompanionBuilder,
          (Transfer, $$TransfersTableReferences),
          Transfer,
          PrefetchHooks Function({
            bool sourceAccountId,
            bool destinationAccountId,
          })
        > {
  $$TransfersTableTableManager(_$AppDatabase db, $TransfersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sourceAccountId = const Value.absent(),
                Value<int> destinationAccountId = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransfersCompanion(
                id: id,
                sourceAccountId: sourceAccountId,
                destinationAccountId: destinationAccountId,
                amountPaise: amountPaise,
                occurredAt: occurredAt,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sourceAccountId,
                required int destinationAccountId,
                required int amountPaise,
                required DateTime occurredAt,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransfersCompanion.insert(
                id: id,
                sourceAccountId: sourceAccountId,
                destinationAccountId: destinationAccountId,
                amountPaise: amountPaise,
                occurredAt: occurredAt,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransfersTable, Transfer>(table),
                  $$TransfersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceAccountId = false, destinationAccountId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceAccountId,
                            referencedTable: $$TransfersTableReferences
                                ._sourceAccountIdTable(db),
                            referencedColumn: $$TransfersTableReferences
                                ._sourceAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (destinationAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.destinationAccountId,
                            referencedTable: $$TransfersTableReferences
                                ._destinationAccountIdTable(db),
                            referencedColumn: $$TransfersTableReferences
                                ._destinationAccountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransfersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransfersTable,
      Transfer,
      $$TransfersTableFilterComposer,
      $$TransfersTableOrderingComposer,
      $$TransfersTableAnnotationComposer,
      $$TransfersTableCreateCompanionBuilder,
      $$TransfersTableUpdateCompanionBuilder,
      (Transfer, $$TransfersTableReferences),
      Transfer,
      PrefetchHooks Function({bool sourceAccountId, bool destinationAccountId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$PaymentAttemptsTableTableManager get paymentAttempts =>
      $$PaymentAttemptsTableTableManager(_db, _db.paymentAttempts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db, _db.transfers);
}
