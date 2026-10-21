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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('USD'));
  static const VerificationMeta _balanceCentsMeta =
      const VerificationMeta('balanceCents');
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
      'balance_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _includeInNetWorthMeta =
      const VerificationMeta('includeInNetWorth');
  @override
  late final GeneratedColumn<bool> includeInNetWorth = GeneratedColumn<bool>(
      'include_in_net_worth', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("include_in_net_worth" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _includeInBudgetMeta =
      const VerificationMeta('includeInBudget');
  @override
  late final GeneratedColumn<bool> includeInBudget = GeneratedColumn<bool>(
      'include_in_budget', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("include_in_budget" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        currency,
        balanceCents,
        includeInNetWorth,
        includeInBudget,
        isArchived,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
          _balanceCentsMeta,
          balanceCents.isAcceptableOrUnknown(
              data['balance_cents']!, _balanceCentsMeta));
    }
    if (data.containsKey('include_in_net_worth')) {
      context.handle(
          _includeInNetWorthMeta,
          includeInNetWorth.isAcceptableOrUnknown(
              data['include_in_net_worth']!, _includeInNetWorthMeta));
    }
    if (data.containsKey('include_in_budget')) {
      context.handle(
          _includeInBudgetMeta,
          includeInBudget.isAcceptableOrUnknown(
              data['include_in_budget']!, _includeInBudgetMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $AccountsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      balanceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_cents'])!,
      includeInNetWorth: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}include_in_net_worth'])!,
      includeInBudget: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}include_in_budget'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
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
  final String currency;
  final int balanceCents;
  final bool includeInNetWorth;
  final bool includeInBudget;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.currency,
      required this.balanceCents,
      required this.includeInNetWorth,
      required this.includeInBudget,
      required this.isArchived,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['currency'] = Variable<String>(currency);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['include_in_net_worth'] = Variable<bool>(includeInNetWorth);
    map['include_in_budget'] = Variable<bool>(includeInBudget);
    map['is_archived'] = Variable<bool>(isArchived);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currency: Value(currency),
      balanceCents: Value(balanceCents),
      includeInNetWorth: Value(includeInNetWorth),
      includeInBudget: Value(includeInBudget),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      currency: serializer.fromJson<String>(json['currency']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      includeInNetWorth: serializer.fromJson<bool>(json['includeInNetWorth']),
      includeInBudget: serializer.fromJson<bool>(json['includeInBudget']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type':
          serializer.toJson<String>($AccountsTable.$convertertype.toJson(type)),
      'currency': serializer.toJson<String>(currency),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'includeInNetWorth': serializer.toJson<bool>(includeInNetWorth),
      'includeInBudget': serializer.toJson<bool>(includeInBudget),
      'isArchived': serializer.toJson<bool>(isArchived),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Account copyWith(
          {int? id,
          String? name,
          AccountType? type,
          String? currency,
          int? balanceCents,
          bool? includeInNetWorth,
          bool? includeInBudget,
          bool? isArchived,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        currency: currency ?? this.currency,
        balanceCents: balanceCents ?? this.balanceCents,
        includeInNetWorth: includeInNetWorth ?? this.includeInNetWorth,
        includeInBudget: includeInBudget ?? this.includeInBudget,
        isArchived: isArchived ?? this.isArchived,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currency: data.currency.present ? data.currency.value : this.currency,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      includeInNetWorth: data.includeInNetWorth.present
          ? data.includeInNetWorth.value
          : this.includeInNetWorth,
      includeInBudget: data.includeInBudget.present
          ? data.includeInBudget.value
          : this.includeInBudget,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('includeInNetWorth: $includeInNetWorth, ')
          ..write('includeInBudget: $includeInBudget, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      type,
      currency,
      balanceCents,
      includeInNetWorth,
      includeInBudget,
      isArchived,
      sortOrder,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currency == this.currency &&
          other.balanceCents == this.balanceCents &&
          other.includeInNetWorth == this.includeInNetWorth &&
          other.includeInBudget == this.includeInBudget &&
          other.isArchived == this.isArchived &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<String> currency;
  final Value<int> balanceCents;
  final Value<bool> includeInNetWorth;
  final Value<bool> includeInBudget;
  final Value<bool> isArchived;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.includeInNetWorth = const Value.absent(),
    this.includeInBudget = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountType type,
    this.currency = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.includeInNetWorth = const Value.absent(),
    this.includeInBudget = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currency,
    Expression<int>? balanceCents,
    Expression<bool>? includeInNetWorth,
    Expression<bool>? includeInBudget,
    Expression<bool>? isArchived,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currency != null) 'currency': currency,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (includeInNetWorth != null) 'include_in_net_worth': includeInNetWorth,
      if (includeInBudget != null) 'include_in_budget': includeInBudget,
      if (isArchived != null) 'is_archived': isArchived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<AccountType>? type,
      Value<String>? currency,
      Value<int>? balanceCents,
      Value<bool>? includeInNetWorth,
      Value<bool>? includeInBudget,
      Value<bool>? isArchived,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      balanceCents: balanceCents ?? this.balanceCents,
      includeInNetWorth: includeInNetWorth ?? this.includeInNetWorth,
      includeInBudget: includeInBudget ?? this.includeInBudget,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      map['type'] =
          Variable<String>($AccountsTable.$convertertype.toSql(type.value));
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (includeInNetWorth.present) {
      map['include_in_net_worth'] = Variable<bool>(includeInNetWorth.value);
    }
    if (includeInBudget.present) {
      map['include_in_budget'] = Variable<bool>(includeInBudget.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('includeInNetWorth: $includeInNetWorth, ')
          ..write('includeInBudget: $includeInBudget, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) => AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryGroupsTable extends CategoryGroups
    with TableInfo<$CategoryGroupsTable, CategoryGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isHiddenMeta =
      const VerificationMeta('isHidden');
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
      'is_hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isHidden];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_groups';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_hidden')) {
      context.handle(_isHiddenMeta,
          isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isHidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hidden'])!,
    );
  }

  @override
  $CategoryGroupsTable createAlias(String alias) {
    return $CategoryGroupsTable(attachedDatabase, alias);
  }
}

class CategoryGroup extends DataClass implements Insertable<CategoryGroup> {
  final int id;
  final String name;
  final int sortOrder;
  final bool isHidden;
  const CategoryGroup(
      {required this.id,
      required this.name,
      required this.sortOrder,
      required this.isHidden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_hidden'] = Variable<bool>(isHidden);
    return map;
  }

  CategoryGroupsCompanion toCompanion(bool nullToAbsent) {
    return CategoryGroupsCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isHidden: Value(isHidden),
    );
  }

  factory CategoryGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isHidden': serializer.toJson<bool>(isHidden),
    };
  }

  CategoryGroup copyWith(
          {int? id, String? name, int? sortOrder, bool? isHidden}) =>
      CategoryGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        isHidden: isHidden ?? this.isHidden,
      );
  CategoryGroup copyWithCompanion(CategoryGroupsCompanion data) {
    return CategoryGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isHidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isHidden == this.isHidden);
}

class CategoryGroupsCompanion extends UpdateCompanion<CategoryGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isHidden;
  const CategoryGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
  });
  CategoryGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isHidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isHidden != null) 'is_hidden': isHidden,
    });
  }

  CategoryGroupsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<bool>? isHidden}) {
    return CategoryGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isHidden: isHidden ?? this.isHidden,
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
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden')
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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isHiddenMeta =
      const VerificationMeta('isHidden');
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
      'is_hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, name, icon, color, sortOrder, isHidden];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_hidden')) {
      context.handle(_isHiddenMeta,
          isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isHidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hidden'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final int groupId;
  final String name;
  final String? icon;
  final int? color;
  final int sortOrder;
  final bool isHidden;
  const Category(
      {required this.id,
      required this.groupId,
      required this.name,
      this.icon,
      this.color,
      required this.sortOrder,
      required this.isHidden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_hidden'] = Variable<bool>(isHidden);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      sortOrder: Value(sortOrder),
      isHidden: Value(isHidden),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<int?>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<int?>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isHidden': serializer.toJson<bool>(isHidden),
    };
  }

  Category copyWith(
          {int? id,
          int? groupId,
          String? name,
          Value<String?> icon = const Value.absent(),
          Value<int?> color = const Value.absent(),
          int? sortOrder,
          bool? isHidden}) =>
      Category(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        sortOrder: sortOrder ?? this.sortOrder,
        isHidden: isHidden ?? this.isHidden,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, name, icon, color, sortOrder, isHidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder &&
          other.isHidden == this.isHidden);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int?> color;
  final Value<int> sortOrder;
  final Value<bool> isHidden;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
  })  : groupId = Value(groupId),
        name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? sortOrder,
    Expression<bool>? isHidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isHidden != null) 'is_hidden': isHidden,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? name,
      Value<String?>? icon,
      Value<int?>? color,
      Value<int>? sortOrder,
      Value<bool>? isHidden}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden')
          ..write(')'))
        .toString();
  }
}

class $BudgetAllocationsTable extends BudgetAllocations
    with TableInfo<$BudgetAllocationsTable, BudgetAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
      'month', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 7, maxTextLength: 7),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _assignedCentsMeta =
      const VerificationMeta('assignedCents');
  @override
  late final GeneratedColumn<int> assignedCents = GeneratedColumn<int>(
      'assigned_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, categoryId, month, assignedCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('assigned_cents')) {
      context.handle(
          _assignedCentsMeta,
          assignedCents.isAcceptableOrUnknown(
              data['assigned_cents']!, _assignedCentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {categoryId, month},
      ];
  @override
  BudgetAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month'])!,
      assignedCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}assigned_cents'])!,
    );
  }

  @override
  $BudgetAllocationsTable createAlias(String alias) {
    return $BudgetAllocationsTable(attachedDatabase, alias);
  }
}

class BudgetAllocation extends DataClass
    implements Insertable<BudgetAllocation> {
  final int id;
  final int categoryId;
  final String month;
  final int assignedCents;
  const BudgetAllocation(
      {required this.id,
      required this.categoryId,
      required this.month,
      required this.assignedCents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['month'] = Variable<String>(month);
    map['assigned_cents'] = Variable<int>(assignedCents);
    return map;
  }

  BudgetAllocationsCompanion toCompanion(bool nullToAbsent) {
    return BudgetAllocationsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      month: Value(month),
      assignedCents: Value(assignedCents),
    );
  }

  factory BudgetAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetAllocation(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      month: serializer.fromJson<String>(json['month']),
      assignedCents: serializer.fromJson<int>(json['assignedCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'month': serializer.toJson<String>(month),
      'assignedCents': serializer.toJson<int>(assignedCents),
    };
  }

  BudgetAllocation copyWith(
          {int? id, int? categoryId, String? month, int? assignedCents}) =>
      BudgetAllocation(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        month: month ?? this.month,
        assignedCents: assignedCents ?? this.assignedCents,
      );
  BudgetAllocation copyWithCompanion(BudgetAllocationsCompanion data) {
    return BudgetAllocation(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      month: data.month.present ? data.month.value : this.month,
      assignedCents: data.assignedCents.present
          ? data.assignedCents.value
          : this.assignedCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetAllocation(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('month: $month, ')
          ..write('assignedCents: $assignedCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, month, assignedCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetAllocation &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.month == this.month &&
          other.assignedCents == this.assignedCents);
}

class BudgetAllocationsCompanion extends UpdateCompanion<BudgetAllocation> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> month;
  final Value<int> assignedCents;
  const BudgetAllocationsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.month = const Value.absent(),
    this.assignedCents = const Value.absent(),
  });
  BudgetAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String month,
    this.assignedCents = const Value.absent(),
  })  : categoryId = Value(categoryId),
        month = Value(month);
  static Insertable<BudgetAllocation> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? month,
    Expression<int>? assignedCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (month != null) 'month': month,
      if (assignedCents != null) 'assigned_cents': assignedCents,
    });
  }

  BudgetAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? month,
      Value<int>? assignedCents}) {
    return BudgetAllocationsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      month: month ?? this.month,
      assignedCents: assignedCents ?? this.assignedCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (assignedCents.present) {
      map['assigned_cents'] = Variable<int>(assignedCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('month: $month, ')
          ..write('assignedCents: $assignedCents')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, MoneyTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _transferAccountIdMeta =
      const VerificationMeta('transferAccountId');
  @override
  late final GeneratedColumn<int> transferAccountId = GeneratedColumn<int>(
      'transfer_account_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recurringItemIdMeta =
      const VerificationMeta('recurringItemId');
  @override
  late final GeneratedColumn<int> recurringItemId = GeneratedColumn<int>(
      'recurring_item_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
      'debt_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
      'payee', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isClearedMeta =
      const VerificationMeta('isCleared');
  @override
  late final GeneratedColumn<bool> isCleared = GeneratedColumn<bool>(
      'is_cleared', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_cleared" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        categoryId,
        transferAccountId,
        recurringItemId,
        debtId,
        type,
        amountCents,
        payee,
        note,
        date,
        isCleared,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<MoneyTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
          _transferAccountIdMeta,
          transferAccountId.isAcceptableOrUnknown(
              data['transfer_account_id']!, _transferAccountIdMeta));
    }
    if (data.containsKey('recurring_item_id')) {
      context.handle(
          _recurringItemIdMeta,
          recurringItemId.isAcceptableOrUnknown(
              data['recurring_item_id']!, _recurringItemIdMeta));
    }
    if (data.containsKey('debt_id')) {
      context.handle(_debtIdMeta,
          debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta));
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
          _payeeMeta, payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_cleared')) {
      context.handle(_isClearedMeta,
          isCleared.isAcceptableOrUnknown(data['is_cleared']!, _isClearedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoneyTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoneyTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      transferAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}transfer_account_id']),
      recurringItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurring_item_id']),
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id']),
      type: $TransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      payee: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payee']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      isCleared: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_cleared'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
}

class MoneyTransaction extends DataClass
    implements Insertable<MoneyTransaction> {
  final int id;
  final int accountId;
  final int? categoryId;

  /// For transfers: the other side of the transfer.
  final int? transferAccountId;

  /// Set when this payment was generated from a bill or subscription.
  final int? recurringItemId;

  /// Set when this payment was made toward a debt.
  final int? debtId;
  final TransactionType type;

  /// Signed: negative = money out of the account, positive = money in.
  final int amountCents;
  final String? payee;
  final String? note;
  final DateTime date;
  final bool isCleared;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MoneyTransaction(
      {required this.id,
      required this.accountId,
      this.categoryId,
      this.transferAccountId,
      this.recurringItemId,
      this.debtId,
      required this.type,
      required this.amountCents,
      this.payee,
      this.note,
      required this.date,
      required this.isCleared,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<int>(transferAccountId);
    }
    if (!nullToAbsent || recurringItemId != null) {
      map['recurring_item_id'] = Variable<int>(recurringItemId);
    }
    if (!nullToAbsent || debtId != null) {
      map['debt_id'] = Variable<int>(debtId);
    }
    {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type));
    }
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_cleared'] = Variable<bool>(isCleared);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
      recurringItemId: recurringItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringItemId),
      debtId:
          debtId == null && nullToAbsent ? const Value.absent() : Value(debtId),
      type: Value(type),
      amountCents: Value(amountCents),
      payee:
          payee == null && nullToAbsent ? const Value.absent() : Value(payee),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
      isCleared: Value(isCleared),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MoneyTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoneyTransaction(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      transferAccountId: serializer.fromJson<int?>(json['transferAccountId']),
      recurringItemId: serializer.fromJson<int?>(json['recurringItemId']),
      debtId: serializer.fromJson<int?>(json['debtId']),
      type: $TransactionsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      payee: serializer.fromJson<String?>(json['payee']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      isCleared: serializer.fromJson<bool>(json['isCleared']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'transferAccountId': serializer.toJson<int?>(transferAccountId),
      'recurringItemId': serializer.toJson<int?>(recurringItemId),
      'debtId': serializer.toJson<int?>(debtId),
      'type': serializer
          .toJson<String>($TransactionsTable.$convertertype.toJson(type)),
      'amountCents': serializer.toJson<int>(amountCents),
      'payee': serializer.toJson<String?>(payee),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
      'isCleared': serializer.toJson<bool>(isCleared),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MoneyTransaction copyWith(
          {int? id,
          int? accountId,
          Value<int?> categoryId = const Value.absent(),
          Value<int?> transferAccountId = const Value.absent(),
          Value<int?> recurringItemId = const Value.absent(),
          Value<int?> debtId = const Value.absent(),
          TransactionType? type,
          int? amountCents,
          Value<String?> payee = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? date,
          bool? isCleared,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MoneyTransaction(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        transferAccountId: transferAccountId.present
            ? transferAccountId.value
            : this.transferAccountId,
        recurringItemId: recurringItemId.present
            ? recurringItemId.value
            : this.recurringItemId,
        debtId: debtId.present ? debtId.value : this.debtId,
        type: type ?? this.type,
        amountCents: amountCents ?? this.amountCents,
        payee: payee.present ? payee.value : this.payee,
        note: note.present ? note.value : this.note,
        date: date ?? this.date,
        isCleared: isCleared ?? this.isCleared,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MoneyTransaction copyWithCompanion(TransactionsCompanion data) {
    return MoneyTransaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
      recurringItemId: data.recurringItemId.present
          ? data.recurringItemId.value
          : this.recurringItemId,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      type: data.type.present ? data.type.value : this.type,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      payee: data.payee.present ? data.payee.value : this.payee,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      isCleared: data.isCleared.present ? data.isCleared.value : this.isCleared,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoneyTransaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('recurringItemId: $recurringItemId, ')
          ..write('debtId: $debtId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('payee: $payee, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isCleared: $isCleared, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      categoryId,
      transferAccountId,
      recurringItemId,
      debtId,
      type,
      amountCents,
      payee,
      note,
      date,
      isCleared,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoneyTransaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.transferAccountId == this.transferAccountId &&
          other.recurringItemId == this.recurringItemId &&
          other.debtId == this.debtId &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.payee == this.payee &&
          other.note == this.note &&
          other.date == this.date &&
          other.isCleared == this.isCleared &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<MoneyTransaction> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<int?> transferAccountId;
  final Value<int?> recurringItemId;
  final Value<int?> debtId;
  final Value<TransactionType> type;
  final Value<int> amountCents;
  final Value<String?> payee;
  final Value<String?> note;
  final Value<DateTime> date;
  final Value<bool> isCleared;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.recurringItemId = const Value.absent(),
    this.debtId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.payee = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.isCleared = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.categoryId = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.recurringItemId = const Value.absent(),
    this.debtId = const Value.absent(),
    required TransactionType type,
    required int amountCents,
    this.payee = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime date,
    this.isCleared = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : accountId = Value(accountId),
        type = Value(type),
        amountCents = Value(amountCents),
        date = Value(date);
  static Insertable<MoneyTransaction> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? transferAccountId,
    Expression<int>? recurringItemId,
    Expression<int>? debtId,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<String>? payee,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<bool>? isCleared,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (recurringItemId != null) 'recurring_item_id': recurringItemId,
      if (debtId != null) 'debt_id': debtId,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (payee != null) 'payee': payee,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (isCleared != null) 'is_cleared': isCleared,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<int?>? categoryId,
      Value<int?>? transferAccountId,
      Value<int?>? recurringItemId,
      Value<int?>? debtId,
      Value<TransactionType>? type,
      Value<int>? amountCents,
      Value<String?>? payee,
      Value<String?>? note,
      Value<DateTime>? date,
      Value<bool>? isCleared,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      recurringItemId: recurringItemId ?? this.recurringItemId,
      debtId: debtId ?? this.debtId,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      payee: payee ?? this.payee,
      note: note ?? this.note,
      date: date ?? this.date,
      isCleared: isCleared ?? this.isCleared,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<int>(transferAccountId.value);
    }
    if (recurringItemId.present) {
      map['recurring_item_id'] = Variable<int>(recurringItemId.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type.value));
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isCleared.present) {
      map['is_cleared'] = Variable<bool>(isCleared.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('recurringItemId: $recurringItemId, ')
          ..write('debtId: $debtId, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('payee: $payee, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isCleared: $isCleared, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RecurringItemsTable extends RecurringItems
    with TableInfo<$RecurringItemsTable, RecurringItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<RecurringKind, String> kind =
      GeneratedColumn<String>('kind', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<RecurringKind>($RecurringItemsTable.$converterkind);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, String> frequency =
      GeneratedColumn<String>('frequency', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Frequency>($RecurringItemsTable.$converterfrequency);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _trialEndsAtMeta =
      const VerificationMeta('trialEndsAt');
  @override
  late final GeneratedColumn<DateTime> trialEndsAt = GeneratedColumn<DateTime>(
      'trial_ends_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _remindDaysBeforeMeta =
      const VerificationMeta('remindDaysBefore');
  @override
  late final GeneratedColumn<int> remindDaysBefore = GeneratedColumn<int>(
      'remind_days_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _autoPayMeta =
      const VerificationMeta('autoPay');
  @override
  late final GeneratedColumn<bool> autoPay = GeneratedColumn<bool>(
      'auto_pay', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("auto_pay" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _cancelUrlMeta =
      const VerificationMeta('cancelUrl');
  @override
  late final GeneratedColumn<String> cancelUrl = GeneratedColumn<String>(
      'cancel_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        kind,
        amountCents,
        frequency,
        nextDueDate,
        trialEndsAt,
        accountId,
        categoryId,
        remindDaysBefore,
        autoPay,
        isActive,
        cancelUrl,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_items';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('trial_ends_at')) {
      context.handle(
          _trialEndsAtMeta,
          trialEndsAt.isAcceptableOrUnknown(
              data['trial_ends_at']!, _trialEndsAtMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('remind_days_before')) {
      context.handle(
          _remindDaysBeforeMeta,
          remindDaysBefore.isAcceptableOrUnknown(
              data['remind_days_before']!, _remindDaysBeforeMeta));
    }
    if (data.containsKey('auto_pay')) {
      context.handle(_autoPayMeta,
          autoPay.isAcceptableOrUnknown(data['auto_pay']!, _autoPayMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('cancel_url')) {
      context.handle(_cancelUrlMeta,
          cancelUrl.isAcceptableOrUnknown(data['cancel_url']!, _cancelUrlMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      kind: $RecurringItemsTable.$converterkind.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!),
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      frequency: $RecurringItemsTable.$converterfrequency.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!),
      nextDueDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_due_date'])!,
      trialEndsAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trial_ends_at']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      remindDaysBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}remind_days_before'])!,
      autoPay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_pay'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      cancelUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cancel_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RecurringItemsTable createAlias(String alias) {
    return $RecurringItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecurringKind, String, String> $converterkind =
      const EnumNameConverter<RecurringKind>(RecurringKind.values);
  static JsonTypeConverter2<Frequency, String, String> $converterfrequency =
      const EnumNameConverter<Frequency>(Frequency.values);
}

class RecurringItem extends DataClass implements Insertable<RecurringItem> {
  final int id;
  final String name;
  final RecurringKind kind;
  final int amountCents;
  final Frequency frequency;
  final DateTime nextDueDate;

  /// Free-trial end date — reminder fires before the first charge.
  final DateTime? trialEndsAt;
  final int? accountId;
  final int? categoryId;
  final int remindDaysBefore;
  final bool autoPay;
  final bool isActive;
  final String? cancelUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurringItem(
      {required this.id,
      required this.name,
      required this.kind,
      required this.amountCents,
      required this.frequency,
      required this.nextDueDate,
      this.trialEndsAt,
      this.accountId,
      this.categoryId,
      required this.remindDaysBefore,
      required this.autoPay,
      required this.isActive,
      this.cancelUrl,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] =
          Variable<String>($RecurringItemsTable.$converterkind.toSql(kind));
    }
    map['amount_cents'] = Variable<int>(amountCents);
    {
      map['frequency'] = Variable<String>(
          $RecurringItemsTable.$converterfrequency.toSql(frequency));
    }
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    if (!nullToAbsent || trialEndsAt != null) {
      map['trial_ends_at'] = Variable<DateTime>(trialEndsAt);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['remind_days_before'] = Variable<int>(remindDaysBefore);
    map['auto_pay'] = Variable<bool>(autoPay);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || cancelUrl != null) {
      map['cancel_url'] = Variable<String>(cancelUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringItemsCompanion toCompanion(bool nullToAbsent) {
    return RecurringItemsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      amountCents: Value(amountCents),
      frequency: Value(frequency),
      nextDueDate: Value(nextDueDate),
      trialEndsAt: trialEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trialEndsAt),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      remindDaysBefore: Value(remindDaysBefore),
      autoPay: Value(autoPay),
      isActive: Value(isActive),
      cancelUrl: cancelUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $RecurringItemsTable.$converterkind
          .fromJson(serializer.fromJson<String>(json['kind'])),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      frequency: $RecurringItemsTable.$converterfrequency
          .fromJson(serializer.fromJson<String>(json['frequency'])),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      trialEndsAt: serializer.fromJson<DateTime?>(json['trialEndsAt']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      remindDaysBefore: serializer.fromJson<int>(json['remindDaysBefore']),
      autoPay: serializer.fromJson<bool>(json['autoPay']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      cancelUrl: serializer.fromJson<String?>(json['cancelUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer
          .toJson<String>($RecurringItemsTable.$converterkind.toJson(kind)),
      'amountCents': serializer.toJson<int>(amountCents),
      'frequency': serializer.toJson<String>(
          $RecurringItemsTable.$converterfrequency.toJson(frequency)),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'trialEndsAt': serializer.toJson<DateTime?>(trialEndsAt),
      'accountId': serializer.toJson<int?>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'remindDaysBefore': serializer.toJson<int>(remindDaysBefore),
      'autoPay': serializer.toJson<bool>(autoPay),
      'isActive': serializer.toJson<bool>(isActive),
      'cancelUrl': serializer.toJson<String?>(cancelUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringItem copyWith(
          {int? id,
          String? name,
          RecurringKind? kind,
          int? amountCents,
          Frequency? frequency,
          DateTime? nextDueDate,
          Value<DateTime?> trialEndsAt = const Value.absent(),
          Value<int?> accountId = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          int? remindDaysBefore,
          bool? autoPay,
          bool? isActive,
          Value<String?> cancelUrl = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RecurringItem(
        id: id ?? this.id,
        name: name ?? this.name,
        kind: kind ?? this.kind,
        amountCents: amountCents ?? this.amountCents,
        frequency: frequency ?? this.frequency,
        nextDueDate: nextDueDate ?? this.nextDueDate,
        trialEndsAt: trialEndsAt.present ? trialEndsAt.value : this.trialEndsAt,
        accountId: accountId.present ? accountId.value : this.accountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
        autoPay: autoPay ?? this.autoPay,
        isActive: isActive ?? this.isActive,
        cancelUrl: cancelUrl.present ? cancelUrl.value : this.cancelUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RecurringItem copyWithCompanion(RecurringItemsCompanion data) {
    return RecurringItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      trialEndsAt:
          data.trialEndsAt.present ? data.trialEndsAt.value : this.trialEndsAt,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      remindDaysBefore: data.remindDaysBefore.present
          ? data.remindDaysBefore.value
          : this.remindDaysBefore,
      autoPay: data.autoPay.present ? data.autoPay.value : this.autoPay,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      cancelUrl: data.cancelUrl.present ? data.cancelUrl.value : this.cancelUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('trialEndsAt: $trialEndsAt, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('autoPay: $autoPay, ')
          ..write('isActive: $isActive, ')
          ..write('cancelUrl: $cancelUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      kind,
      amountCents,
      frequency,
      nextDueDate,
      trialEndsAt,
      accountId,
      categoryId,
      remindDaysBefore,
      autoPay,
      isActive,
      cancelUrl,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.amountCents == this.amountCents &&
          other.frequency == this.frequency &&
          other.nextDueDate == this.nextDueDate &&
          other.trialEndsAt == this.trialEndsAt &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.remindDaysBefore == this.remindDaysBefore &&
          other.autoPay == this.autoPay &&
          other.isActive == this.isActive &&
          other.cancelUrl == this.cancelUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringItemsCompanion extends UpdateCompanion<RecurringItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<RecurringKind> kind;
  final Value<int> amountCents;
  final Value<Frequency> frequency;
  final Value<DateTime> nextDueDate;
  final Value<DateTime?> trialEndsAt;
  final Value<int?> accountId;
  final Value<int?> categoryId;
  final Value<int> remindDaysBefore;
  final Value<bool> autoPay;
  final Value<bool> isActive;
  final Value<String?> cancelUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RecurringItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.frequency = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.trialEndsAt = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.autoPay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.cancelUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecurringItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required RecurringKind kind,
    required int amountCents,
    required Frequency frequency,
    required DateTime nextDueDate,
    this.trialEndsAt = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.autoPay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.cancelUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        kind = Value(kind),
        amountCents = Value(amountCents),
        frequency = Value(frequency),
        nextDueDate = Value(nextDueDate);
  static Insertable<RecurringItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? amountCents,
    Expression<String>? frequency,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? trialEndsAt,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? remindDaysBefore,
    Expression<bool>? autoPay,
    Expression<bool>? isActive,
    Expression<String>? cancelUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (amountCents != null) 'amount_cents': amountCents,
      if (frequency != null) 'frequency': frequency,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (trialEndsAt != null) 'trial_ends_at': trialEndsAt,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (remindDaysBefore != null) 'remind_days_before': remindDaysBefore,
      if (autoPay != null) 'auto_pay': autoPay,
      if (isActive != null) 'is_active': isActive,
      if (cancelUrl != null) 'cancel_url': cancelUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecurringItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<RecurringKind>? kind,
      Value<int>? amountCents,
      Value<Frequency>? frequency,
      Value<DateTime>? nextDueDate,
      Value<DateTime?>? trialEndsAt,
      Value<int?>? accountId,
      Value<int?>? categoryId,
      Value<int>? remindDaysBefore,
      Value<bool>? autoPay,
      Value<bool>? isActive,
      Value<String?>? cancelUrl,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return RecurringItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      amountCents: amountCents ?? this.amountCents,
      frequency: frequency ?? this.frequency,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      autoPay: autoPay ?? this.autoPay,
      isActive: isActive ?? this.isActive,
      cancelUrl: cancelUrl ?? this.cancelUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
          $RecurringItemsTable.$converterkind.toSql(kind.value));
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
          $RecurringItemsTable.$converterfrequency.toSql(frequency.value));
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (trialEndsAt.present) {
      map['trial_ends_at'] = Variable<DateTime>(trialEndsAt.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (remindDaysBefore.present) {
      map['remind_days_before'] = Variable<int>(remindDaysBefore.value);
    }
    if (autoPay.present) {
      map['auto_pay'] = Variable<bool>(autoPay.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (cancelUrl.present) {
      map['cancel_url'] = Variable<String>(cancelUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('trialEndsAt: $trialEndsAt, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('autoPay: $autoPay, ')
          ..write('isActive: $isActive, ')
          ..write('cancelUrl: $cancelUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _startingBalanceCentsMeta =
      const VerificationMeta('startingBalanceCents');
  @override
  late final GeneratedColumn<int> startingBalanceCents = GeneratedColumn<int>(
      'starting_balance_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentBalanceCentsMeta =
      const VerificationMeta('currentBalanceCents');
  @override
  late final GeneratedColumn<int> currentBalanceCents = GeneratedColumn<int>(
      'current_balance_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _aprBasisPointsMeta =
      const VerificationMeta('aprBasisPoints');
  @override
  late final GeneratedColumn<int> aprBasisPoints = GeneratedColumn<int>(
      'apr_basis_points', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minimumPaymentCentsMeta =
      const VerificationMeta('minimumPaymentCents');
  @override
  late final GeneratedColumn<int> minimumPaymentCents = GeneratedColumn<int>(
      'minimum_payment_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dueDayOfMonthMeta =
      const VerificationMeta('dueDayOfMonth');
  @override
  late final GeneratedColumn<int> dueDayOfMonth = GeneratedColumn<int>(
      'due_day_of_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _customOrderMeta =
      const VerificationMeta('customOrder');
  @override
  late final GeneratedColumn<int> customOrder = GeneratedColumn<int>(
      'custom_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isPaidOffMeta =
      const VerificationMeta('isPaidOff');
  @override
  late final GeneratedColumn<bool> isPaidOff = GeneratedColumn<bool>(
      'is_paid_off', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid_off" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _paidOffAtMeta =
      const VerificationMeta('paidOffAt');
  @override
  late final GeneratedColumn<DateTime> paidOffAt = GeneratedColumn<DateTime>(
      'paid_off_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        accountId,
        startingBalanceCents,
        currentBalanceCents,
        aprBasisPoints,
        minimumPaymentCents,
        dueDayOfMonth,
        customOrder,
        isPaidOff,
        paidOffAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('starting_balance_cents')) {
      context.handle(
          _startingBalanceCentsMeta,
          startingBalanceCents.isAcceptableOrUnknown(
              data['starting_balance_cents']!, _startingBalanceCentsMeta));
    } else if (isInserting) {
      context.missing(_startingBalanceCentsMeta);
    }
    if (data.containsKey('current_balance_cents')) {
      context.handle(
          _currentBalanceCentsMeta,
          currentBalanceCents.isAcceptableOrUnknown(
              data['current_balance_cents']!, _currentBalanceCentsMeta));
    } else if (isInserting) {
      context.missing(_currentBalanceCentsMeta);
    }
    if (data.containsKey('apr_basis_points')) {
      context.handle(
          _aprBasisPointsMeta,
          aprBasisPoints.isAcceptableOrUnknown(
              data['apr_basis_points']!, _aprBasisPointsMeta));
    } else if (isInserting) {
      context.missing(_aprBasisPointsMeta);
    }
    if (data.containsKey('minimum_payment_cents')) {
      context.handle(
          _minimumPaymentCentsMeta,
          minimumPaymentCents.isAcceptableOrUnknown(
              data['minimum_payment_cents']!, _minimumPaymentCentsMeta));
    } else if (isInserting) {
      context.missing(_minimumPaymentCentsMeta);
    }
    if (data.containsKey('due_day_of_month')) {
      context.handle(
          _dueDayOfMonthMeta,
          dueDayOfMonth.isAcceptableOrUnknown(
              data['due_day_of_month']!, _dueDayOfMonthMeta));
    }
    if (data.containsKey('custom_order')) {
      context.handle(
          _customOrderMeta,
          customOrder.isAcceptableOrUnknown(
              data['custom_order']!, _customOrderMeta));
    }
    if (data.containsKey('is_paid_off')) {
      context.handle(
          _isPaidOffMeta,
          isPaidOff.isAcceptableOrUnknown(
              data['is_paid_off']!, _isPaidOffMeta));
    }
    if (data.containsKey('paid_off_at')) {
      context.handle(
          _paidOffAtMeta,
          paidOffAt.isAcceptableOrUnknown(
              data['paid_off_at']!, _paidOffAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id']),
      startingBalanceCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}starting_balance_cents'])!,
      currentBalanceCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_balance_cents'])!,
      aprBasisPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}apr_basis_points'])!,
      minimumPaymentCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}minimum_payment_cents'])!,
      dueDayOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_day_of_month']),
      customOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}custom_order'])!,
      isPaidOff: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid_off'])!,
      paidOffAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_off_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final int id;
  final String name;

  /// Optional link to the credit-card/loan account so balances stay in sync
  /// with Net Worth.
  final int? accountId;
  final int startingBalanceCents;
  final int currentBalanceCents;
  final int aprBasisPoints;
  final int minimumPaymentCents;
  final int? dueDayOfMonth;

  /// Position when strategy == custom.
  final int customOrder;
  final bool isPaidOff;
  final DateTime? paidOffAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Debt(
      {required this.id,
      required this.name,
      this.accountId,
      required this.startingBalanceCents,
      required this.currentBalanceCents,
      required this.aprBasisPoints,
      required this.minimumPaymentCents,
      this.dueDayOfMonth,
      required this.customOrder,
      required this.isPaidOff,
      this.paidOffAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['starting_balance_cents'] = Variable<int>(startingBalanceCents);
    map['current_balance_cents'] = Variable<int>(currentBalanceCents);
    map['apr_basis_points'] = Variable<int>(aprBasisPoints);
    map['minimum_payment_cents'] = Variable<int>(minimumPaymentCents);
    if (!nullToAbsent || dueDayOfMonth != null) {
      map['due_day_of_month'] = Variable<int>(dueDayOfMonth);
    }
    map['custom_order'] = Variable<int>(customOrder);
    map['is_paid_off'] = Variable<bool>(isPaidOff);
    if (!nullToAbsent || paidOffAt != null) {
      map['paid_off_at'] = Variable<DateTime>(paidOffAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      name: Value(name),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      startingBalanceCents: Value(startingBalanceCents),
      currentBalanceCents: Value(currentBalanceCents),
      aprBasisPoints: Value(aprBasisPoints),
      minimumPaymentCents: Value(minimumPaymentCents),
      dueDayOfMonth: dueDayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDayOfMonth),
      customOrder: Value(customOrder),
      isPaidOff: Value(isPaidOff),
      paidOffAt: paidOffAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidOffAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      startingBalanceCents:
          serializer.fromJson<int>(json['startingBalanceCents']),
      currentBalanceCents:
          serializer.fromJson<int>(json['currentBalanceCents']),
      aprBasisPoints: serializer.fromJson<int>(json['aprBasisPoints']),
      minimumPaymentCents:
          serializer.fromJson<int>(json['minimumPaymentCents']),
      dueDayOfMonth: serializer.fromJson<int?>(json['dueDayOfMonth']),
      customOrder: serializer.fromJson<int>(json['customOrder']),
      isPaidOff: serializer.fromJson<bool>(json['isPaidOff']),
      paidOffAt: serializer.fromJson<DateTime?>(json['paidOffAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'accountId': serializer.toJson<int?>(accountId),
      'startingBalanceCents': serializer.toJson<int>(startingBalanceCents),
      'currentBalanceCents': serializer.toJson<int>(currentBalanceCents),
      'aprBasisPoints': serializer.toJson<int>(aprBasisPoints),
      'minimumPaymentCents': serializer.toJson<int>(minimumPaymentCents),
      'dueDayOfMonth': serializer.toJson<int?>(dueDayOfMonth),
      'customOrder': serializer.toJson<int>(customOrder),
      'isPaidOff': serializer.toJson<bool>(isPaidOff),
      'paidOffAt': serializer.toJson<DateTime?>(paidOffAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Debt copyWith(
          {int? id,
          String? name,
          Value<int?> accountId = const Value.absent(),
          int? startingBalanceCents,
          int? currentBalanceCents,
          int? aprBasisPoints,
          int? minimumPaymentCents,
          Value<int?> dueDayOfMonth = const Value.absent(),
          int? customOrder,
          bool? isPaidOff,
          Value<DateTime?> paidOffAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Debt(
        id: id ?? this.id,
        name: name ?? this.name,
        accountId: accountId.present ? accountId.value : this.accountId,
        startingBalanceCents: startingBalanceCents ?? this.startingBalanceCents,
        currentBalanceCents: currentBalanceCents ?? this.currentBalanceCents,
        aprBasisPoints: aprBasisPoints ?? this.aprBasisPoints,
        minimumPaymentCents: minimumPaymentCents ?? this.minimumPaymentCents,
        dueDayOfMonth:
            dueDayOfMonth.present ? dueDayOfMonth.value : this.dueDayOfMonth,
        customOrder: customOrder ?? this.customOrder,
        isPaidOff: isPaidOff ?? this.isPaidOff,
        paidOffAt: paidOffAt.present ? paidOffAt.value : this.paidOffAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      startingBalanceCents: data.startingBalanceCents.present
          ? data.startingBalanceCents.value
          : this.startingBalanceCents,
      currentBalanceCents: data.currentBalanceCents.present
          ? data.currentBalanceCents.value
          : this.currentBalanceCents,
      aprBasisPoints: data.aprBasisPoints.present
          ? data.aprBasisPoints.value
          : this.aprBasisPoints,
      minimumPaymentCents: data.minimumPaymentCents.present
          ? data.minimumPaymentCents.value
          : this.minimumPaymentCents,
      dueDayOfMonth: data.dueDayOfMonth.present
          ? data.dueDayOfMonth.value
          : this.dueDayOfMonth,
      customOrder:
          data.customOrder.present ? data.customOrder.value : this.customOrder,
      isPaidOff: data.isPaidOff.present ? data.isPaidOff.value : this.isPaidOff,
      paidOffAt: data.paidOffAt.present ? data.paidOffAt.value : this.paidOffAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountId: $accountId, ')
          ..write('startingBalanceCents: $startingBalanceCents, ')
          ..write('currentBalanceCents: $currentBalanceCents, ')
          ..write('aprBasisPoints: $aprBasisPoints, ')
          ..write('minimumPaymentCents: $minimumPaymentCents, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('customOrder: $customOrder, ')
          ..write('isPaidOff: $isPaidOff, ')
          ..write('paidOffAt: $paidOffAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      accountId,
      startingBalanceCents,
      currentBalanceCents,
      aprBasisPoints,
      minimumPaymentCents,
      dueDayOfMonth,
      customOrder,
      isPaidOff,
      paidOffAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.name == this.name &&
          other.accountId == this.accountId &&
          other.startingBalanceCents == this.startingBalanceCents &&
          other.currentBalanceCents == this.currentBalanceCents &&
          other.aprBasisPoints == this.aprBasisPoints &&
          other.minimumPaymentCents == this.minimumPaymentCents &&
          other.dueDayOfMonth == this.dueDayOfMonth &&
          other.customOrder == this.customOrder &&
          other.isPaidOff == this.isPaidOff &&
          other.paidOffAt == this.paidOffAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> accountId;
  final Value<int> startingBalanceCents;
  final Value<int> currentBalanceCents;
  final Value<int> aprBasisPoints;
  final Value<int> minimumPaymentCents;
  final Value<int?> dueDayOfMonth;
  final Value<int> customOrder;
  final Value<bool> isPaidOff;
  final Value<DateTime?> paidOffAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.accountId = const Value.absent(),
    this.startingBalanceCents = const Value.absent(),
    this.currentBalanceCents = const Value.absent(),
    this.aprBasisPoints = const Value.absent(),
    this.minimumPaymentCents = const Value.absent(),
    this.dueDayOfMonth = const Value.absent(),
    this.customOrder = const Value.absent(),
    this.isPaidOff = const Value.absent(),
    this.paidOffAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.accountId = const Value.absent(),
    required int startingBalanceCents,
    required int currentBalanceCents,
    required int aprBasisPoints,
    required int minimumPaymentCents,
    this.dueDayOfMonth = const Value.absent(),
    this.customOrder = const Value.absent(),
    this.isPaidOff = const Value.absent(),
    this.paidOffAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        startingBalanceCents = Value(startingBalanceCents),
        currentBalanceCents = Value(currentBalanceCents),
        aprBasisPoints = Value(aprBasisPoints),
        minimumPaymentCents = Value(minimumPaymentCents);
  static Insertable<Debt> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? accountId,
    Expression<int>? startingBalanceCents,
    Expression<int>? currentBalanceCents,
    Expression<int>? aprBasisPoints,
    Expression<int>? minimumPaymentCents,
    Expression<int>? dueDayOfMonth,
    Expression<int>? customOrder,
    Expression<bool>? isPaidOff,
    Expression<DateTime>? paidOffAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (accountId != null) 'account_id': accountId,
      if (startingBalanceCents != null)
        'starting_balance_cents': startingBalanceCents,
      if (currentBalanceCents != null)
        'current_balance_cents': currentBalanceCents,
      if (aprBasisPoints != null) 'apr_basis_points': aprBasisPoints,
      if (minimumPaymentCents != null)
        'minimum_payment_cents': minimumPaymentCents,
      if (dueDayOfMonth != null) 'due_day_of_month': dueDayOfMonth,
      if (customOrder != null) 'custom_order': customOrder,
      if (isPaidOff != null) 'is_paid_off': isPaidOff,
      if (paidOffAt != null) 'paid_off_at': paidOffAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DebtsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? accountId,
      Value<int>? startingBalanceCents,
      Value<int>? currentBalanceCents,
      Value<int>? aprBasisPoints,
      Value<int>? minimumPaymentCents,
      Value<int?>? dueDayOfMonth,
      Value<int>? customOrder,
      Value<bool>? isPaidOff,
      Value<DateTime?>? paidOffAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DebtsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      accountId: accountId ?? this.accountId,
      startingBalanceCents: startingBalanceCents ?? this.startingBalanceCents,
      currentBalanceCents: currentBalanceCents ?? this.currentBalanceCents,
      aprBasisPoints: aprBasisPoints ?? this.aprBasisPoints,
      minimumPaymentCents: minimumPaymentCents ?? this.minimumPaymentCents,
      dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
      customOrder: customOrder ?? this.customOrder,
      isPaidOff: isPaidOff ?? this.isPaidOff,
      paidOffAt: paidOffAt ?? this.paidOffAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (startingBalanceCents.present) {
      map['starting_balance_cents'] = Variable<int>(startingBalanceCents.value);
    }
    if (currentBalanceCents.present) {
      map['current_balance_cents'] = Variable<int>(currentBalanceCents.value);
    }
    if (aprBasisPoints.present) {
      map['apr_basis_points'] = Variable<int>(aprBasisPoints.value);
    }
    if (minimumPaymentCents.present) {
      map['minimum_payment_cents'] = Variable<int>(minimumPaymentCents.value);
    }
    if (dueDayOfMonth.present) {
      map['due_day_of_month'] = Variable<int>(dueDayOfMonth.value);
    }
    if (customOrder.present) {
      map['custom_order'] = Variable<int>(customOrder.value);
    }
    if (isPaidOff.present) {
      map['is_paid_off'] = Variable<bool>(isPaidOff.value);
    }
    if (paidOffAt.present) {
      map['paid_off_at'] = Variable<DateTime>(paidOffAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountId: $accountId, ')
          ..write('startingBalanceCents: $startingBalanceCents, ')
          ..write('currentBalanceCents: $currentBalanceCents, ')
          ..write('aprBasisPoints: $aprBasisPoints, ')
          ..write('minimumPaymentCents: $minimumPaymentCents, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('customOrder: $customOrder, ')
          ..write('isPaidOff: $isPaidOff, ')
          ..write('paidOffAt: $paidOffAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DebtPlansTable extends DebtPlans
    with TableInfo<$DebtPlansTable, DebtPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<DebtStrategy, String> strategy =
      GeneratedColumn<String>('strategy', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DebtStrategy>($DebtPlansTable.$converterstrategy);
  static const VerificationMeta _extraMonthlyCentsMeta =
      const VerificationMeta('extraMonthlyCents');
  @override
  late final GeneratedColumn<int> extraMonthlyCents = GeneratedColumn<int>(
      'extra_monthly_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, strategy, extraMonthlyCents, startDate, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_plans';
  @override
  VerificationContext validateIntegrity(Insertable<DebtPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('extra_monthly_cents')) {
      context.handle(
          _extraMonthlyCentsMeta,
          extraMonthlyCents.isAcceptableOrUnknown(
              data['extra_monthly_cents']!, _extraMonthlyCentsMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      strategy: $DebtPlansTable.$converterstrategy.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strategy'])!),
      extraMonthlyCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}extra_monthly_cents'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DebtPlansTable createAlias(String alias) {
    return $DebtPlansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DebtStrategy, String, String> $converterstrategy =
      const EnumNameConverter<DebtStrategy>(DebtStrategy.values);
}

class DebtPlan extends DataClass implements Insertable<DebtPlan> {
  final int id;
  final DebtStrategy strategy;

  /// Extra money per month on top of all minimum payments.
  final int extraMonthlyCents;
  final DateTime startDate;
  final DateTime updatedAt;
  const DebtPlan(
      {required this.id,
      required this.strategy,
      required this.extraMonthlyCents,
      required this.startDate,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['strategy'] =
          Variable<String>($DebtPlansTable.$converterstrategy.toSql(strategy));
    }
    map['extra_monthly_cents'] = Variable<int>(extraMonthlyCents);
    map['start_date'] = Variable<DateTime>(startDate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DebtPlansCompanion toCompanion(bool nullToAbsent) {
    return DebtPlansCompanion(
      id: Value(id),
      strategy: Value(strategy),
      extraMonthlyCents: Value(extraMonthlyCents),
      startDate: Value(startDate),
      updatedAt: Value(updatedAt),
    );
  }

  factory DebtPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtPlan(
      id: serializer.fromJson<int>(json['id']),
      strategy: $DebtPlansTable.$converterstrategy
          .fromJson(serializer.fromJson<String>(json['strategy'])),
      extraMonthlyCents: serializer.fromJson<int>(json['extraMonthlyCents']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'strategy': serializer
          .toJson<String>($DebtPlansTable.$converterstrategy.toJson(strategy)),
      'extraMonthlyCents': serializer.toJson<int>(extraMonthlyCents),
      'startDate': serializer.toJson<DateTime>(startDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DebtPlan copyWith(
          {int? id,
          DebtStrategy? strategy,
          int? extraMonthlyCents,
          DateTime? startDate,
          DateTime? updatedAt}) =>
      DebtPlan(
        id: id ?? this.id,
        strategy: strategy ?? this.strategy,
        extraMonthlyCents: extraMonthlyCents ?? this.extraMonthlyCents,
        startDate: startDate ?? this.startDate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DebtPlan copyWithCompanion(DebtPlansCompanion data) {
    return DebtPlan(
      id: data.id.present ? data.id.value : this.id,
      strategy: data.strategy.present ? data.strategy.value : this.strategy,
      extraMonthlyCents: data.extraMonthlyCents.present
          ? data.extraMonthlyCents.value
          : this.extraMonthlyCents,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtPlan(')
          ..write('id: $id, ')
          ..write('strategy: $strategy, ')
          ..write('extraMonthlyCents: $extraMonthlyCents, ')
          ..write('startDate: $startDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, strategy, extraMonthlyCents, startDate, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtPlan &&
          other.id == this.id &&
          other.strategy == this.strategy &&
          other.extraMonthlyCents == this.extraMonthlyCents &&
          other.startDate == this.startDate &&
          other.updatedAt == this.updatedAt);
}

class DebtPlansCompanion extends UpdateCompanion<DebtPlan> {
  final Value<int> id;
  final Value<DebtStrategy> strategy;
  final Value<int> extraMonthlyCents;
  final Value<DateTime> startDate;
  final Value<DateTime> updatedAt;
  const DebtPlansCompanion({
    this.id = const Value.absent(),
    this.strategy = const Value.absent(),
    this.extraMonthlyCents = const Value.absent(),
    this.startDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DebtPlansCompanion.insert({
    this.id = const Value.absent(),
    required DebtStrategy strategy,
    this.extraMonthlyCents = const Value.absent(),
    required DateTime startDate,
    this.updatedAt = const Value.absent(),
  })  : strategy = Value(strategy),
        startDate = Value(startDate);
  static Insertable<DebtPlan> custom({
    Expression<int>? id,
    Expression<String>? strategy,
    Expression<int>? extraMonthlyCents,
    Expression<DateTime>? startDate,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (strategy != null) 'strategy': strategy,
      if (extraMonthlyCents != null) 'extra_monthly_cents': extraMonthlyCents,
      if (startDate != null) 'start_date': startDate,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DebtPlansCompanion copyWith(
      {Value<int>? id,
      Value<DebtStrategy>? strategy,
      Value<int>? extraMonthlyCents,
      Value<DateTime>? startDate,
      Value<DateTime>? updatedAt}) {
    return DebtPlansCompanion(
      id: id ?? this.id,
      strategy: strategy ?? this.strategy,
      extraMonthlyCents: extraMonthlyCents ?? this.extraMonthlyCents,
      startDate: startDate ?? this.startDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (strategy.present) {
      map['strategy'] = Variable<String>(
          $DebtPlansTable.$converterstrategy.toSql(strategy.value));
    }
    if (extraMonthlyCents.present) {
      map['extra_monthly_cents'] = Variable<int>(extraMonthlyCents.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtPlansCompanion(')
          ..write('id: $id, ')
          ..write('strategy: $strategy, ')
          ..write('extraMonthlyCents: $extraMonthlyCents, ')
          ..write('startDate: $startDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $HoldingsTable extends Holdings with TableInfo<$HoldingsTable, Holding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costBasisCentsMeta =
      const VerificationMeta('costBasisCents');
  @override
  late final GeneratedColumn<int> costBasisCents = GeneratedColumn<int>(
      'cost_basis_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastPriceCentsMeta =
      const VerificationMeta('lastPriceCents');
  @override
  late final GeneratedColumn<int> lastPriceCents = GeneratedColumn<int>(
      'last_price_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastPriceAtMeta =
      const VerificationMeta('lastPriceAt');
  @override
  late final GeneratedColumn<DateTime> lastPriceAt = GeneratedColumn<DateTime>(
      'last_price_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        symbol,
        name,
        quantity,
        costBasisCents,
        lastPriceCents,
        lastPriceAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'holdings';
  @override
  VerificationContext validateIntegrity(Insertable<Holding> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost_basis_cents')) {
      context.handle(
          _costBasisCentsMeta,
          costBasisCents.isAcceptableOrUnknown(
              data['cost_basis_cents']!, _costBasisCentsMeta));
    }
    if (data.containsKey('last_price_cents')) {
      context.handle(
          _lastPriceCentsMeta,
          lastPriceCents.isAcceptableOrUnknown(
              data['last_price_cents']!, _lastPriceCentsMeta));
    }
    if (data.containsKey('last_price_at')) {
      context.handle(
          _lastPriceAtMeta,
          lastPriceAt.isAcceptableOrUnknown(
              data['last_price_at']!, _lastPriceAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Holding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Holding(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      costBasisCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost_basis_cents']),
      lastPriceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_price_cents']),
      lastPriceAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_price_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HoldingsTable createAlias(String alias) {
    return $HoldingsTable(attachedDatabase, alias);
  }
}

class Holding extends DataClass implements Insertable<Holding> {
  final int id;
  final int accountId;
  final String symbol;
  final String? name;
  final double quantity;
  final int? costBasisCents;
  final int? lastPriceCents;
  final DateTime? lastPriceAt;
  final DateTime updatedAt;
  const Holding(
      {required this.id,
      required this.accountId,
      required this.symbol,
      this.name,
      required this.quantity,
      this.costBasisCents,
      this.lastPriceCents,
      this.lastPriceAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['symbol'] = Variable<String>(symbol);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || costBasisCents != null) {
      map['cost_basis_cents'] = Variable<int>(costBasisCents);
    }
    if (!nullToAbsent || lastPriceCents != null) {
      map['last_price_cents'] = Variable<int>(lastPriceCents);
    }
    if (!nullToAbsent || lastPriceAt != null) {
      map['last_price_at'] = Variable<DateTime>(lastPriceAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HoldingsCompanion toCompanion(bool nullToAbsent) {
    return HoldingsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      symbol: Value(symbol),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      quantity: Value(quantity),
      costBasisCents: costBasisCents == null && nullToAbsent
          ? const Value.absent()
          : Value(costBasisCents),
      lastPriceCents: lastPriceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPriceCents),
      lastPriceAt: lastPriceAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPriceAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Holding.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Holding(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      name: serializer.fromJson<String?>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      costBasisCents: serializer.fromJson<int?>(json['costBasisCents']),
      lastPriceCents: serializer.fromJson<int?>(json['lastPriceCents']),
      lastPriceAt: serializer.fromJson<DateTime?>(json['lastPriceAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'symbol': serializer.toJson<String>(symbol),
      'name': serializer.toJson<String?>(name),
      'quantity': serializer.toJson<double>(quantity),
      'costBasisCents': serializer.toJson<int?>(costBasisCents),
      'lastPriceCents': serializer.toJson<int?>(lastPriceCents),
      'lastPriceAt': serializer.toJson<DateTime?>(lastPriceAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Holding copyWith(
          {int? id,
          int? accountId,
          String? symbol,
          Value<String?> name = const Value.absent(),
          double? quantity,
          Value<int?> costBasisCents = const Value.absent(),
          Value<int?> lastPriceCents = const Value.absent(),
          Value<DateTime?> lastPriceAt = const Value.absent(),
          DateTime? updatedAt}) =>
      Holding(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        symbol: symbol ?? this.symbol,
        name: name.present ? name.value : this.name,
        quantity: quantity ?? this.quantity,
        costBasisCents:
            costBasisCents.present ? costBasisCents.value : this.costBasisCents,
        lastPriceCents:
            lastPriceCents.present ? lastPriceCents.value : this.lastPriceCents,
        lastPriceAt: lastPriceAt.present ? lastPriceAt.value : this.lastPriceAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Holding copyWithCompanion(HoldingsCompanion data) {
    return Holding(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      costBasisCents: data.costBasisCents.present
          ? data.costBasisCents.value
          : this.costBasisCents,
      lastPriceCents: data.lastPriceCents.present
          ? data.lastPriceCents.value
          : this.lastPriceCents,
      lastPriceAt:
          data.lastPriceAt.present ? data.lastPriceAt.value : this.lastPriceAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Holding(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('costBasisCents: $costBasisCents, ')
          ..write('lastPriceCents: $lastPriceCents, ')
          ..write('lastPriceAt: $lastPriceAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, symbol, name, quantity,
      costBasisCents, lastPriceCents, lastPriceAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Holding &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.symbol == this.symbol &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.costBasisCents == this.costBasisCents &&
          other.lastPriceCents == this.lastPriceCents &&
          other.lastPriceAt == this.lastPriceAt &&
          other.updatedAt == this.updatedAt);
}

class HoldingsCompanion extends UpdateCompanion<Holding> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> symbol;
  final Value<String?> name;
  final Value<double> quantity;
  final Value<int?> costBasisCents;
  final Value<int?> lastPriceCents;
  final Value<DateTime?> lastPriceAt;
  final Value<DateTime> updatedAt;
  const HoldingsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.costBasisCents = const Value.absent(),
    this.lastPriceCents = const Value.absent(),
    this.lastPriceAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HoldingsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String symbol,
    this.name = const Value.absent(),
    required double quantity,
    this.costBasisCents = const Value.absent(),
    this.lastPriceCents = const Value.absent(),
    this.lastPriceAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : accountId = Value(accountId),
        symbol = Value(symbol),
        quantity = Value(quantity);
  static Insertable<Holding> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? symbol,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<int>? costBasisCents,
    Expression<int>? lastPriceCents,
    Expression<DateTime>? lastPriceAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (symbol != null) 'symbol': symbol,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (costBasisCents != null) 'cost_basis_cents': costBasisCents,
      if (lastPriceCents != null) 'last_price_cents': lastPriceCents,
      if (lastPriceAt != null) 'last_price_at': lastPriceAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HoldingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? accountId,
      Value<String>? symbol,
      Value<String?>? name,
      Value<double>? quantity,
      Value<int?>? costBasisCents,
      Value<int?>? lastPriceCents,
      Value<DateTime?>? lastPriceAt,
      Value<DateTime>? updatedAt}) {
    return HoldingsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      costBasisCents: costBasisCents ?? this.costBasisCents,
      lastPriceCents: lastPriceCents ?? this.lastPriceCents,
      lastPriceAt: lastPriceAt ?? this.lastPriceAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (costBasisCents.present) {
      map['cost_basis_cents'] = Variable<int>(costBasisCents.value);
    }
    if (lastPriceCents.present) {
      map['last_price_cents'] = Variable<int>(lastPriceCents.value);
    }
    if (lastPriceAt.present) {
      map['last_price_at'] = Variable<DateTime>(lastPriceAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HoldingsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('costBasisCents: $costBasisCents, ')
          ..write('lastPriceCents: $lastPriceCents, ')
          ..write('lastPriceAt: $lastPriceAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NetWorthSnapshotsTable extends NetWorthSnapshots
    with TableInfo<$NetWorthSnapshotsTable, NetWorthSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NetWorthSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _assetsCentsMeta =
      const VerificationMeta('assetsCents');
  @override
  late final GeneratedColumn<int> assetsCents = GeneratedColumn<int>(
      'assets_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _liabilitiesCentsMeta =
      const VerificationMeta('liabilitiesCents');
  @override
  late final GeneratedColumn<int> liabilitiesCents = GeneratedColumn<int>(
      'liabilities_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _netWorthCentsMeta =
      const VerificationMeta('netWorthCents');
  @override
  late final GeneratedColumn<int> netWorthCents = GeneratedColumn<int>(
      'net_worth_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, assetsCents, liabilitiesCents, netWorthCents];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'net_worth_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<NetWorthSnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('assets_cents')) {
      context.handle(
          _assetsCentsMeta,
          assetsCents.isAcceptableOrUnknown(
              data['assets_cents']!, _assetsCentsMeta));
    } else if (isInserting) {
      context.missing(_assetsCentsMeta);
    }
    if (data.containsKey('liabilities_cents')) {
      context.handle(
          _liabilitiesCentsMeta,
          liabilitiesCents.isAcceptableOrUnknown(
              data['liabilities_cents']!, _liabilitiesCentsMeta));
    } else if (isInserting) {
      context.missing(_liabilitiesCentsMeta);
    }
    if (data.containsKey('net_worth_cents')) {
      context.handle(
          _netWorthCentsMeta,
          netWorthCents.isAcceptableOrUnknown(
              data['net_worth_cents']!, _netWorthCentsMeta));
    } else if (isInserting) {
      context.missing(_netWorthCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NetWorthSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NetWorthSnapshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      assetsCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}assets_cents'])!,
      liabilitiesCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}liabilities_cents'])!,
      netWorthCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}net_worth_cents'])!,
    );
  }

  @override
  $NetWorthSnapshotsTable createAlias(String alias) {
    return $NetWorthSnapshotsTable(attachedDatabase, alias);
  }
}

class NetWorthSnapshot extends DataClass
    implements Insertable<NetWorthSnapshot> {
  final int id;
  final DateTime date;
  final int assetsCents;
  final int liabilitiesCents;
  final int netWorthCents;
  const NetWorthSnapshot(
      {required this.id,
      required this.date,
      required this.assetsCents,
      required this.liabilitiesCents,
      required this.netWorthCents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['assets_cents'] = Variable<int>(assetsCents);
    map['liabilities_cents'] = Variable<int>(liabilitiesCents);
    map['net_worth_cents'] = Variable<int>(netWorthCents);
    return map;
  }

  NetWorthSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return NetWorthSnapshotsCompanion(
      id: Value(id),
      date: Value(date),
      assetsCents: Value(assetsCents),
      liabilitiesCents: Value(liabilitiesCents),
      netWorthCents: Value(netWorthCents),
    );
  }

  factory NetWorthSnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NetWorthSnapshot(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      assetsCents: serializer.fromJson<int>(json['assetsCents']),
      liabilitiesCents: serializer.fromJson<int>(json['liabilitiesCents']),
      netWorthCents: serializer.fromJson<int>(json['netWorthCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'assetsCents': serializer.toJson<int>(assetsCents),
      'liabilitiesCents': serializer.toJson<int>(liabilitiesCents),
      'netWorthCents': serializer.toJson<int>(netWorthCents),
    };
  }

  NetWorthSnapshot copyWith(
          {int? id,
          DateTime? date,
          int? assetsCents,
          int? liabilitiesCents,
          int? netWorthCents}) =>
      NetWorthSnapshot(
        id: id ?? this.id,
        date: date ?? this.date,
        assetsCents: assetsCents ?? this.assetsCents,
        liabilitiesCents: liabilitiesCents ?? this.liabilitiesCents,
        netWorthCents: netWorthCents ?? this.netWorthCents,
      );
  NetWorthSnapshot copyWithCompanion(NetWorthSnapshotsCompanion data) {
    return NetWorthSnapshot(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      assetsCents:
          data.assetsCents.present ? data.assetsCents.value : this.assetsCents,
      liabilitiesCents: data.liabilitiesCents.present
          ? data.liabilitiesCents.value
          : this.liabilitiesCents,
      netWorthCents: data.netWorthCents.present
          ? data.netWorthCents.value
          : this.netWorthCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NetWorthSnapshot(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('assetsCents: $assetsCents, ')
          ..write('liabilitiesCents: $liabilitiesCents, ')
          ..write('netWorthCents: $netWorthCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, assetsCents, liabilitiesCents, netWorthCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetWorthSnapshot &&
          other.id == this.id &&
          other.date == this.date &&
          other.assetsCents == this.assetsCents &&
          other.liabilitiesCents == this.liabilitiesCents &&
          other.netWorthCents == this.netWorthCents);
}

class NetWorthSnapshotsCompanion extends UpdateCompanion<NetWorthSnapshot> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> assetsCents;
  final Value<int> liabilitiesCents;
  final Value<int> netWorthCents;
  const NetWorthSnapshotsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.assetsCents = const Value.absent(),
    this.liabilitiesCents = const Value.absent(),
    this.netWorthCents = const Value.absent(),
  });
  NetWorthSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int assetsCents,
    required int liabilitiesCents,
    required int netWorthCents,
  })  : date = Value(date),
        assetsCents = Value(assetsCents),
        liabilitiesCents = Value(liabilitiesCents),
        netWorthCents = Value(netWorthCents);
  static Insertable<NetWorthSnapshot> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? assetsCents,
    Expression<int>? liabilitiesCents,
    Expression<int>? netWorthCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (assetsCents != null) 'assets_cents': assetsCents,
      if (liabilitiesCents != null) 'liabilities_cents': liabilitiesCents,
      if (netWorthCents != null) 'net_worth_cents': netWorthCents,
    });
  }

  NetWorthSnapshotsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? assetsCents,
      Value<int>? liabilitiesCents,
      Value<int>? netWorthCents}) {
    return NetWorthSnapshotsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      assetsCents: assetsCents ?? this.assetsCents,
      liabilitiesCents: liabilitiesCents ?? this.liabilitiesCents,
      netWorthCents: netWorthCents ?? this.netWorthCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (assetsCents.present) {
      map['assets_cents'] = Variable<int>(assetsCents.value);
    }
    if (liabilitiesCents.present) {
      map['liabilities_cents'] = Variable<int>(liabilitiesCents.value);
    }
    if (netWorthCents.present) {
      map['net_worth_cents'] = Variable<int>(netWorthCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetWorthSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('assetsCents: $assetsCents, ')
          ..write('liabilitiesCents: $liabilitiesCents, ')
          ..write('netWorthCents: $netWorthCents')
          ..write(')'))
        .toString();
  }
}

class $SavedCalculationsTable extends SavedCalculations
    with TableInfo<$SavedCalculationsTable, SavedCalculation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedCalculationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<CalculatorType, String>
      calculator = GeneratedColumn<String>('calculator', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CalculatorType>(
              $SavedCalculationsTable.$convertercalculator);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _inputsJsonMeta =
      const VerificationMeta('inputsJson');
  @override
  late final GeneratedColumn<String> inputsJson = GeneratedColumn<String>(
      'inputs_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resultSummaryMeta =
      const VerificationMeta('resultSummary');
  @override
  late final GeneratedColumn<String> resultSummary = GeneratedColumn<String>(
      'result_summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPinnedToHomeMeta =
      const VerificationMeta('isPinnedToHome');
  @override
  late final GeneratedColumn<bool> isPinnedToHome = GeneratedColumn<bool>(
      'is_pinned_to_home', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_pinned_to_home" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        calculator,
        title,
        inputsJson,
        resultSummary,
        isPinnedToHome,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_calculations';
  @override
  VerificationContext validateIntegrity(Insertable<SavedCalculation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('inputs_json')) {
      context.handle(
          _inputsJsonMeta,
          inputsJson.isAcceptableOrUnknown(
              data['inputs_json']!, _inputsJsonMeta));
    } else if (isInserting) {
      context.missing(_inputsJsonMeta);
    }
    if (data.containsKey('result_summary')) {
      context.handle(
          _resultSummaryMeta,
          resultSummary.isAcceptableOrUnknown(
              data['result_summary']!, _resultSummaryMeta));
    }
    if (data.containsKey('is_pinned_to_home')) {
      context.handle(
          _isPinnedToHomeMeta,
          isPinnedToHome.isAcceptableOrUnknown(
              data['is_pinned_to_home']!, _isPinnedToHomeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedCalculation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedCalculation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      calculator: $SavedCalculationsTable.$convertercalculator.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}calculator'])!),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      inputsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inputs_json'])!,
      resultSummary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result_summary']),
      isPinnedToHome: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_pinned_to_home'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SavedCalculationsTable createAlias(String alias) {
    return $SavedCalculationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CalculatorType, String, String>
      $convertercalculator =
      const EnumNameConverter<CalculatorType>(CalculatorType.values);
}

class SavedCalculation extends DataClass
    implements Insertable<SavedCalculation> {
  final int id;
  final CalculatorType calculator;
  final String title;

  /// Raw inputs as JSON, e.g. {"principal":1000000,"monthly":50000,"rateBp":700,"years":30}
  final String inputsJson;

  /// Cached headline result for list views, e.g. "$612,438 after 30 years".
  final String? resultSummary;
  final bool isPinnedToHome;
  final DateTime createdAt;
  const SavedCalculation(
      {required this.id,
      required this.calculator,
      required this.title,
      required this.inputsJson,
      this.resultSummary,
      required this.isPinnedToHome,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['calculator'] = Variable<String>(
          $SavedCalculationsTable.$convertercalculator.toSql(calculator));
    }
    map['title'] = Variable<String>(title);
    map['inputs_json'] = Variable<String>(inputsJson);
    if (!nullToAbsent || resultSummary != null) {
      map['result_summary'] = Variable<String>(resultSummary);
    }
    map['is_pinned_to_home'] = Variable<bool>(isPinnedToHome);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavedCalculationsCompanion toCompanion(bool nullToAbsent) {
    return SavedCalculationsCompanion(
      id: Value(id),
      calculator: Value(calculator),
      title: Value(title),
      inputsJson: Value(inputsJson),
      resultSummary: resultSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(resultSummary),
      isPinnedToHome: Value(isPinnedToHome),
      createdAt: Value(createdAt),
    );
  }

  factory SavedCalculation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedCalculation(
      id: serializer.fromJson<int>(json['id']),
      calculator: $SavedCalculationsTable.$convertercalculator
          .fromJson(serializer.fromJson<String>(json['calculator'])),
      title: serializer.fromJson<String>(json['title']),
      inputsJson: serializer.fromJson<String>(json['inputsJson']),
      resultSummary: serializer.fromJson<String?>(json['resultSummary']),
      isPinnedToHome: serializer.fromJson<bool>(json['isPinnedToHome']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'calculator': serializer.toJson<String>(
          $SavedCalculationsTable.$convertercalculator.toJson(calculator)),
      'title': serializer.toJson<String>(title),
      'inputsJson': serializer.toJson<String>(inputsJson),
      'resultSummary': serializer.toJson<String?>(resultSummary),
      'isPinnedToHome': serializer.toJson<bool>(isPinnedToHome),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavedCalculation copyWith(
          {int? id,
          CalculatorType? calculator,
          String? title,
          String? inputsJson,
          Value<String?> resultSummary = const Value.absent(),
          bool? isPinnedToHome,
          DateTime? createdAt}) =>
      SavedCalculation(
        id: id ?? this.id,
        calculator: calculator ?? this.calculator,
        title: title ?? this.title,
        inputsJson: inputsJson ?? this.inputsJson,
        resultSummary:
            resultSummary.present ? resultSummary.value : this.resultSummary,
        isPinnedToHome: isPinnedToHome ?? this.isPinnedToHome,
        createdAt: createdAt ?? this.createdAt,
      );
  SavedCalculation copyWithCompanion(SavedCalculationsCompanion data) {
    return SavedCalculation(
      id: data.id.present ? data.id.value : this.id,
      calculator:
          data.calculator.present ? data.calculator.value : this.calculator,
      title: data.title.present ? data.title.value : this.title,
      inputsJson:
          data.inputsJson.present ? data.inputsJson.value : this.inputsJson,
      resultSummary: data.resultSummary.present
          ? data.resultSummary.value
          : this.resultSummary,
      isPinnedToHome: data.isPinnedToHome.present
          ? data.isPinnedToHome.value
          : this.isPinnedToHome,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedCalculation(')
          ..write('id: $id, ')
          ..write('calculator: $calculator, ')
          ..write('title: $title, ')
          ..write('inputsJson: $inputsJson, ')
          ..write('resultSummary: $resultSummary, ')
          ..write('isPinnedToHome: $isPinnedToHome, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, calculator, title, inputsJson,
      resultSummary, isPinnedToHome, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedCalculation &&
          other.id == this.id &&
          other.calculator == this.calculator &&
          other.title == this.title &&
          other.inputsJson == this.inputsJson &&
          other.resultSummary == this.resultSummary &&
          other.isPinnedToHome == this.isPinnedToHome &&
          other.createdAt == this.createdAt);
}

class SavedCalculationsCompanion extends UpdateCompanion<SavedCalculation> {
  final Value<int> id;
  final Value<CalculatorType> calculator;
  final Value<String> title;
  final Value<String> inputsJson;
  final Value<String?> resultSummary;
  final Value<bool> isPinnedToHome;
  final Value<DateTime> createdAt;
  const SavedCalculationsCompanion({
    this.id = const Value.absent(),
    this.calculator = const Value.absent(),
    this.title = const Value.absent(),
    this.inputsJson = const Value.absent(),
    this.resultSummary = const Value.absent(),
    this.isPinnedToHome = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavedCalculationsCompanion.insert({
    this.id = const Value.absent(),
    required CalculatorType calculator,
    required String title,
    required String inputsJson,
    this.resultSummary = const Value.absent(),
    this.isPinnedToHome = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : calculator = Value(calculator),
        title = Value(title),
        inputsJson = Value(inputsJson);
  static Insertable<SavedCalculation> custom({
    Expression<int>? id,
    Expression<String>? calculator,
    Expression<String>? title,
    Expression<String>? inputsJson,
    Expression<String>? resultSummary,
    Expression<bool>? isPinnedToHome,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calculator != null) 'calculator': calculator,
      if (title != null) 'title': title,
      if (inputsJson != null) 'inputs_json': inputsJson,
      if (resultSummary != null) 'result_summary': resultSummary,
      if (isPinnedToHome != null) 'is_pinned_to_home': isPinnedToHome,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavedCalculationsCompanion copyWith(
      {Value<int>? id,
      Value<CalculatorType>? calculator,
      Value<String>? title,
      Value<String>? inputsJson,
      Value<String?>? resultSummary,
      Value<bool>? isPinnedToHome,
      Value<DateTime>? createdAt}) {
    return SavedCalculationsCompanion(
      id: id ?? this.id,
      calculator: calculator ?? this.calculator,
      title: title ?? this.title,
      inputsJson: inputsJson ?? this.inputsJson,
      resultSummary: resultSummary ?? this.resultSummary,
      isPinnedToHome: isPinnedToHome ?? this.isPinnedToHome,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (calculator.present) {
      map['calculator'] = Variable<String>(
          $SavedCalculationsTable.$convertercalculator.toSql(calculator.value));
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (inputsJson.present) {
      map['inputs_json'] = Variable<String>(inputsJson.value);
    }
    if (resultSummary.present) {
      map['result_summary'] = Variable<String>(resultSummary.value);
    }
    if (isPinnedToHome.present) {
      map['is_pinned_to_home'] = Variable<bool>(isPinnedToHome.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedCalculationsCompanion(')
          ..write('id: $id, ')
          ..write('calculator: $calculator, ')
          ..write('title: $title, ')
          ..write('inputsJson: $inputsJson, ')
          ..write('resultSummary: $resultSummary, ')
          ..write('isPinnedToHome: $isPinnedToHome, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTable extends LessonProgress
    with TableInfo<$LessonProgressTable, LessonProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _bestQuizScoreMeta =
      const VerificationMeta('bestQuizScore');
  @override
  late final GeneratedColumn<int> bestQuizScore = GeneratedColumn<int>(
      'best_quiz_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [lessonId, startedAt, completedAt, bestQuizScore, attempts];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<LessonProgressEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('best_quiz_score')) {
      context.handle(
          _bestQuizScoreMeta,
          bestQuizScore.isAcceptableOrUnknown(
              data['best_quiz_score']!, _bestQuizScoreMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  LessonProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressEntry(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      bestQuizScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}best_quiz_score']),
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
    );
  }

  @override
  $LessonProgressTable createAlias(String alias) {
    return $LessonProgressTable(attachedDatabase, alias);
  }
}

class LessonProgressEntry extends DataClass
    implements Insertable<LessonProgressEntry> {
  final String lessonId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? bestQuizScore;
  final int attempts;
  const LessonProgressEntry(
      {required this.lessonId,
      required this.startedAt,
      this.completedAt,
      this.bestQuizScore,
      required this.attempts});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || bestQuizScore != null) {
      map['best_quiz_score'] = Variable<int>(bestQuizScore);
    }
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  LessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCompanion(
      lessonId: Value(lessonId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      bestQuizScore: bestQuizScore == null && nullToAbsent
          ? const Value.absent()
          : Value(bestQuizScore),
      attempts: Value(attempts),
    );
  }

  factory LessonProgressEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressEntry(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      bestQuizScore: serializer.fromJson<int?>(json['bestQuizScore']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'bestQuizScore': serializer.toJson<int?>(bestQuizScore),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  LessonProgressEntry copyWith(
          {String? lessonId,
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<int?> bestQuizScore = const Value.absent(),
          int? attempts}) =>
      LessonProgressEntry(
        lessonId: lessonId ?? this.lessonId,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        bestQuizScore:
            bestQuizScore.present ? bestQuizScore.value : this.bestQuizScore,
        attempts: attempts ?? this.attempts,
      );
  LessonProgressEntry copyWithCompanion(LessonProgressCompanion data) {
    return LessonProgressEntry(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      bestQuizScore: data.bestQuizScore.present
          ? data.bestQuizScore.value
          : this.bestQuizScore,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressEntry(')
          ..write('lessonId: $lessonId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('bestQuizScore: $bestQuizScore, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(lessonId, startedAt, completedAt, bestQuizScore, attempts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressEntry &&
          other.lessonId == this.lessonId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.bestQuizScore == this.bestQuizScore &&
          other.attempts == this.attempts);
}

class LessonProgressCompanion extends UpdateCompanion<LessonProgressEntry> {
  final Value<String> lessonId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> bestQuizScore;
  final Value<int> attempts;
  final Value<int> rowid;
  const LessonProgressCompanion({
    this.lessonId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.bestQuizScore = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressCompanion.insert({
    required String lessonId,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.bestQuizScore = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<LessonProgressEntry> custom({
    Expression<String>? lessonId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? bestQuizScore,
    Expression<int>? attempts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (bestQuizScore != null) 'best_quiz_score': bestQuizScore,
      if (attempts != null) 'attempts': attempts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressCompanion copyWith(
      {Value<String>? lessonId,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<int?>? bestQuizScore,
      Value<int>? attempts,
      Value<int>? rowid}) {
    return LessonProgressCompanion(
      lessonId: lessonId ?? this.lessonId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      bestQuizScore: bestQuizScore ?? this.bestQuizScore,
      attempts: attempts ?? this.attempts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (bestQuizScore.present) {
      map['best_quiz_score'] = Variable<int>(bestQuizScore.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('bestQuizScore: $bestQuizScore, ')
          ..write('attempts: $attempts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityDaysTable extends ActivityDays
    with TableInfo<$ActivityDaysTable, ActivityDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
      'day', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [day, xpEarned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_days';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  ActivityDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityDay(
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day'])!,
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
    );
  }

  @override
  $ActivityDaysTable createAlias(String alias) {
    return $ActivityDaysTable(attachedDatabase, alias);
  }
}

class ActivityDay extends DataClass implements Insertable<ActivityDay> {
  final String day;
  final int xpEarned;
  const ActivityDay({required this.day, required this.xpEarned});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['xp_earned'] = Variable<int>(xpEarned);
    return map;
  }

  ActivityDaysCompanion toCompanion(bool nullToAbsent) {
    return ActivityDaysCompanion(
      day: Value(day),
      xpEarned: Value(xpEarned),
    );
  }

  factory ActivityDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityDay(
      day: serializer.fromJson<String>(json['day']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'xpEarned': serializer.toJson<int>(xpEarned),
    };
  }

  ActivityDay copyWith({String? day, int? xpEarned}) => ActivityDay(
        day: day ?? this.day,
        xpEarned: xpEarned ?? this.xpEarned,
      );
  ActivityDay copyWithCompanion(ActivityDaysCompanion data) {
    return ActivityDay(
      day: data.day.present ? data.day.value : this.day,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityDay(')
          ..write('day: $day, ')
          ..write('xpEarned: $xpEarned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, xpEarned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityDay &&
          other.day == this.day &&
          other.xpEarned == this.xpEarned);
}

class ActivityDaysCompanion extends UpdateCompanion<ActivityDay> {
  final Value<String> day;
  final Value<int> xpEarned;
  final Value<int> rowid;
  const ActivityDaysCompanion({
    this.day = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityDaysCompanion.insert({
    required String day,
    this.xpEarned = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day);
  static Insertable<ActivityDay> custom({
    Expression<String>? day,
    Expression<int>? xpEarned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityDaysCompanion copyWith(
      {Value<String>? day, Value<int>? xpEarned, Value<int>? rowid}) {
    return ActivityDaysCompanion(
      day: day ?? this.day,
      xpEarned: xpEarned ?? this.xpEarned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityDaysCompanion(')
          ..write('day: $day, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $CategoryGroupsTable categoryGroups = $CategoryGroupsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BudgetAllocationsTable budgetAllocations =
      $BudgetAllocationsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $RecurringItemsTable recurringItems = $RecurringItemsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $DebtPlansTable debtPlans = $DebtPlansTable(this);
  late final $HoldingsTable holdings = $HoldingsTable(this);
  late final $NetWorthSnapshotsTable netWorthSnapshots =
      $NetWorthSnapshotsTable(this);
  late final $SavedCalculationsTable savedCalculations =
      $SavedCalculationsTable(this);
  late final $LessonProgressTable lessonProgress = $LessonProgressTable(this);
  late final $ActivityDaysTable activityDays = $ActivityDaysTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        appSettings,
        categoryGroups,
        categories,
        budgetAllocations,
        transactions,
        recurringItems,
        debts,
        debtPlans,
        holdings,
        netWorthSnapshots,
        savedCalculations,
        lessonProgress,
        activityDays
      ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String name,
  required AccountType type,
  Value<String> currency,
  Value<int> balanceCents,
  Value<bool> includeInNetWorth,
  Value<bool> includeInBudget,
  Value<bool> isArchived,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<AccountType> type,
  Value<String> currency,
  Value<int> balanceCents,
  Value<bool> includeInNetWorth,
  Value<bool> includeInBudget,
  Value<bool> isArchived,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balanceCents => $composableBuilder(
      column: $table.balanceCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get includeInNetWorth => $composableBuilder(
      column: $table.includeInNetWorth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get includeInBudget => $composableBuilder(
      column: $table.includeInBudget,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balanceCents => $composableBuilder(
      column: $table.balanceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get includeInNetWorth => $composableBuilder(
      column: $table.includeInNetWorth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get includeInBudget => $composableBuilder(
      column: $table.includeInBudget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
      column: $table.balanceCents, builder: (column) => column);

  GeneratedColumn<bool> get includeInNetWorth => $composableBuilder(
      column: $table.includeInNetWorth, builder: (column) => column);

  GeneratedColumn<bool> get includeInBudget => $composableBuilder(
      column: $table.includeInBudget, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<AccountType> type = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<int> balanceCents = const Value.absent(),
            Value<bool> includeInNetWorth = const Value.absent(),
            Value<bool> includeInBudget = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            type: type,
            currency: currency,
            balanceCents: balanceCents,
            includeInNetWorth: includeInNetWorth,
            includeInBudget: includeInBudget,
            isArchived: isArchived,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required AccountType type,
            Value<String> currency = const Value.absent(),
            Value<int> balanceCents = const Value.absent(),
            Value<bool> includeInNetWorth = const Value.absent(),
            Value<bool> includeInBudget = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            currency: currency,
            balanceCents: balanceCents,
            includeInNetWorth: includeInNetWorth,
            includeInBudget: includeInBudget,
            isArchived: isArchived,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;
typedef $$CategoryGroupsTableCreateCompanionBuilder = CategoryGroupsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int> sortOrder,
  Value<bool> isHidden,
});
typedef $$CategoryGroupsTableUpdateCompanionBuilder = CategoryGroupsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> sortOrder,
  Value<bool> isHidden,
});

class $$CategoryGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryGroupsTable> {
  $$CategoryGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnFilters(column));
}

class $$CategoryGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryGroupsTable> {
  $$CategoryGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnOrderings(column));
}

class $$CategoryGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryGroupsTable> {
  $$CategoryGroupsTableAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);
}

class $$CategoryGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryGroupsTable,
    CategoryGroup,
    $$CategoryGroupsTableFilterComposer,
    $$CategoryGroupsTableOrderingComposer,
    $$CategoryGroupsTableAnnotationComposer,
    $$CategoryGroupsTableCreateCompanionBuilder,
    $$CategoryGroupsTableUpdateCompanionBuilder,
    (
      CategoryGroup,
      BaseReferences<_$AppDatabase, $CategoryGroupsTable, CategoryGroup>
    ),
    CategoryGroup,
    PrefetchHooks Function()> {
  $$CategoryGroupsTableTableManager(
      _$AppDatabase db, $CategoryGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
          }) =>
              CategoryGroupsCompanion(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isHidden: isHidden,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
          }) =>
              CategoryGroupsCompanion.insert(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isHidden: isHidden,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoryGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoryGroupsTable,
    CategoryGroup,
    $$CategoryGroupsTableFilterComposer,
    $$CategoryGroupsTableOrderingComposer,
    $$CategoryGroupsTableAnnotationComposer,
    $$CategoryGroupsTableCreateCompanionBuilder,
    $$CategoryGroupsTableUpdateCompanionBuilder,
    (
      CategoryGroup,
      BaseReferences<_$AppDatabase, $CategoryGroupsTable, CategoryGroup>
    ),
    CategoryGroup,
    PrefetchHooks Function()>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required int groupId,
  required String name,
  Value<String?> icon,
  Value<int?> color,
  Value<int> sortOrder,
  Value<bool> isHidden,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<String> name,
  Value<String?> icon,
  Value<int?> color,
  Value<int> sortOrder,
  Value<bool> isHidden,
});

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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnFilters(column));
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            groupId: groupId,
            name: name,
            icon: icon,
            color: color,
            sortOrder: sortOrder,
            isHidden: isHidden,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required String name,
            Value<String?> icon = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            groupId: groupId,
            name: name,
            icon: icon,
            color: color,
            sortOrder: sortOrder,
            isHidden: isHidden,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()>;
typedef $$BudgetAllocationsTableCreateCompanionBuilder
    = BudgetAllocationsCompanion Function({
  Value<int> id,
  required int categoryId,
  required String month,
  Value<int> assignedCents,
});
typedef $$BudgetAllocationsTableUpdateCompanionBuilder
    = BudgetAllocationsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> month,
  Value<int> assignedCents,
});

class $$BudgetAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetAllocationsTable> {
  $$BudgetAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assignedCents => $composableBuilder(
      column: $table.assignedCents, builder: (column) => ColumnFilters(column));
}

class $$BudgetAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetAllocationsTable> {
  $$BudgetAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assignedCents => $composableBuilder(
      column: $table.assignedCents,
      builder: (column) => ColumnOrderings(column));
}

class $$BudgetAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetAllocationsTable> {
  $$BudgetAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get assignedCents => $composableBuilder(
      column: $table.assignedCents, builder: (column) => column);
}

class $$BudgetAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetAllocationsTable,
    BudgetAllocation,
    $$BudgetAllocationsTableFilterComposer,
    $$BudgetAllocationsTableOrderingComposer,
    $$BudgetAllocationsTableAnnotationComposer,
    $$BudgetAllocationsTableCreateCompanionBuilder,
    $$BudgetAllocationsTableUpdateCompanionBuilder,
    (
      BudgetAllocation,
      BaseReferences<_$AppDatabase, $BudgetAllocationsTable, BudgetAllocation>
    ),
    BudgetAllocation,
    PrefetchHooks Function()> {
  $$BudgetAllocationsTableTableManager(
      _$AppDatabase db, $BudgetAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> month = const Value.absent(),
            Value<int> assignedCents = const Value.absent(),
          }) =>
              BudgetAllocationsCompanion(
            id: id,
            categoryId: categoryId,
            month: month,
            assignedCents: assignedCents,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String month,
            Value<int> assignedCents = const Value.absent(),
          }) =>
              BudgetAllocationsCompanion.insert(
            id: id,
            categoryId: categoryId,
            month: month,
            assignedCents: assignedCents,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetAllocationsTable,
    BudgetAllocation,
    $$BudgetAllocationsTableFilterComposer,
    $$BudgetAllocationsTableOrderingComposer,
    $$BudgetAllocationsTableAnnotationComposer,
    $$BudgetAllocationsTableCreateCompanionBuilder,
    $$BudgetAllocationsTableUpdateCompanionBuilder,
    (
      BudgetAllocation,
      BaseReferences<_$AppDatabase, $BudgetAllocationsTable, BudgetAllocation>
    ),
    BudgetAllocation,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int accountId,
  Value<int?> categoryId,
  Value<int?> transferAccountId,
  Value<int?> recurringItemId,
  Value<int?> debtId,
  required TransactionType type,
  required int amountCents,
  Value<String?> payee,
  Value<String?> note,
  required DateTime date,
  Value<bool> isCleared,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> accountId,
  Value<int?> categoryId,
  Value<int?> transferAccountId,
  Value<int?> recurringItemId,
  Value<int?> debtId,
  Value<TransactionType> type,
  Value<int> amountCents,
  Value<String?> payee,
  Value<String?> note,
  Value<DateTime> date,
  Value<bool> isCleared,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transferAccountId => $composableBuilder(
      column: $table.transferAccountId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recurringItemId => $composableBuilder(
      column: $table.recurringItemId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get debtId => $composableBuilder(
      column: $table.debtId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payee => $composableBuilder(
      column: $table.payee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCleared => $composableBuilder(
      column: $table.isCleared, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transferAccountId => $composableBuilder(
      column: $table.transferAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recurringItemId => $composableBuilder(
      column: $table.recurringItemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get debtId => $composableBuilder(
      column: $table.debtId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payee => $composableBuilder(
      column: $table.payee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCleared => $composableBuilder(
      column: $table.isCleared, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get transferAccountId => $composableBuilder(
      column: $table.transferAccountId, builder: (column) => column);

  GeneratedColumn<int> get recurringItemId => $composableBuilder(
      column: $table.recurringItemId, builder: (column) => column);

  GeneratedColumn<int> get debtId =>
      $composableBuilder(column: $table.debtId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isCleared =>
      $composableBuilder(column: $table.isCleared, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    MoneyTransaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      MoneyTransaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, MoneyTransaction>
    ),
    MoneyTransaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int?> transferAccountId = const Value.absent(),
            Value<int?> recurringItemId = const Value.absent(),
            Value<int?> debtId = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<String?> payee = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<bool> isCleared = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            transferAccountId: transferAccountId,
            recurringItemId: recurringItemId,
            debtId: debtId,
            type: type,
            amountCents: amountCents,
            payee: payee,
            note: note,
            date: date,
            isCleared: isCleared,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            Value<int?> categoryId = const Value.absent(),
            Value<int?> transferAccountId = const Value.absent(),
            Value<int?> recurringItemId = const Value.absent(),
            Value<int?> debtId = const Value.absent(),
            required TransactionType type,
            required int amountCents,
            Value<String?> payee = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime date,
            Value<bool> isCleared = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            transferAccountId: transferAccountId,
            recurringItemId: recurringItemId,
            debtId: debtId,
            type: type,
            amountCents: amountCents,
            payee: payee,
            note: note,
            date: date,
            isCleared: isCleared,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    MoneyTransaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      MoneyTransaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, MoneyTransaction>
    ),
    MoneyTransaction,
    PrefetchHooks Function()>;
typedef $$RecurringItemsTableCreateCompanionBuilder = RecurringItemsCompanion
    Function({
  Value<int> id,
  required String name,
  required RecurringKind kind,
  required int amountCents,
  required Frequency frequency,
  required DateTime nextDueDate,
  Value<DateTime?> trialEndsAt,
  Value<int?> accountId,
  Value<int?> categoryId,
  Value<int> remindDaysBefore,
  Value<bool> autoPay,
  Value<bool> isActive,
  Value<String?> cancelUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$RecurringItemsTableUpdateCompanionBuilder = RecurringItemsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<RecurringKind> kind,
  Value<int> amountCents,
  Value<Frequency> frequency,
  Value<DateTime> nextDueDate,
  Value<DateTime?> trialEndsAt,
  Value<int?> accountId,
  Value<int?> categoryId,
  Value<int> remindDaysBefore,
  Value<bool> autoPay,
  Value<bool> isActive,
  Value<String?> cancelUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$RecurringItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringItemsTable> {
  $$RecurringItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RecurringKind, RecurringKind, String>
      get kind => $composableBuilder(
          column: $table.kind,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Frequency, Frequency, String> get frequency =>
      $composableBuilder(
          column: $table.frequency,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get trialEndsAt => $composableBuilder(
      column: $table.trialEndsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remindDaysBefore => $composableBuilder(
      column: $table.remindDaysBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoPay => $composableBuilder(
      column: $table.autoPay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cancelUrl => $composableBuilder(
      column: $table.cancelUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RecurringItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringItemsTable> {
  $$RecurringItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get trialEndsAt => $composableBuilder(
      column: $table.trialEndsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remindDaysBefore => $composableBuilder(
      column: $table.remindDaysBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoPay => $composableBuilder(
      column: $table.autoPay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cancelUrl => $composableBuilder(
      column: $table.cancelUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecurringItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringItemsTable> {
  $$RecurringItemsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<RecurringKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Frequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get trialEndsAt => $composableBuilder(
      column: $table.trialEndsAt, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get remindDaysBefore => $composableBuilder(
      column: $table.remindDaysBefore, builder: (column) => column);

  GeneratedColumn<bool> get autoPay =>
      $composableBuilder(column: $table.autoPay, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get cancelUrl =>
      $composableBuilder(column: $table.cancelUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringItemsTable,
    RecurringItem,
    $$RecurringItemsTableFilterComposer,
    $$RecurringItemsTableOrderingComposer,
    $$RecurringItemsTableAnnotationComposer,
    $$RecurringItemsTableCreateCompanionBuilder,
    $$RecurringItemsTableUpdateCompanionBuilder,
    (
      RecurringItem,
      BaseReferences<_$AppDatabase, $RecurringItemsTable, RecurringItem>
    ),
    RecurringItem,
    PrefetchHooks Function()> {
  $$RecurringItemsTableTableManager(
      _$AppDatabase db, $RecurringItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<RecurringKind> kind = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<Frequency> frequency = const Value.absent(),
            Value<DateTime> nextDueDate = const Value.absent(),
            Value<DateTime?> trialEndsAt = const Value.absent(),
            Value<int?> accountId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int> remindDaysBefore = const Value.absent(),
            Value<bool> autoPay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> cancelUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RecurringItemsCompanion(
            id: id,
            name: name,
            kind: kind,
            amountCents: amountCents,
            frequency: frequency,
            nextDueDate: nextDueDate,
            trialEndsAt: trialEndsAt,
            accountId: accountId,
            categoryId: categoryId,
            remindDaysBefore: remindDaysBefore,
            autoPay: autoPay,
            isActive: isActive,
            cancelUrl: cancelUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required RecurringKind kind,
            required int amountCents,
            required Frequency frequency,
            required DateTime nextDueDate,
            Value<DateTime?> trialEndsAt = const Value.absent(),
            Value<int?> accountId = const Value.absent(),
            Value<int?> categoryId = const Value.absent(),
            Value<int> remindDaysBefore = const Value.absent(),
            Value<bool> autoPay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> cancelUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RecurringItemsCompanion.insert(
            id: id,
            name: name,
            kind: kind,
            amountCents: amountCents,
            frequency: frequency,
            nextDueDate: nextDueDate,
            trialEndsAt: trialEndsAt,
            accountId: accountId,
            categoryId: categoryId,
            remindDaysBefore: remindDaysBefore,
            autoPay: autoPay,
            isActive: isActive,
            cancelUrl: cancelUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringItemsTable,
    RecurringItem,
    $$RecurringItemsTableFilterComposer,
    $$RecurringItemsTableOrderingComposer,
    $$RecurringItemsTableAnnotationComposer,
    $$RecurringItemsTableCreateCompanionBuilder,
    $$RecurringItemsTableUpdateCompanionBuilder,
    (
      RecurringItem,
      BaseReferences<_$AppDatabase, $RecurringItemsTable, RecurringItem>
    ),
    RecurringItem,
    PrefetchHooks Function()>;
typedef $$DebtsTableCreateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> accountId,
  required int startingBalanceCents,
  required int currentBalanceCents,
  required int aprBasisPoints,
  required int minimumPaymentCents,
  Value<int?> dueDayOfMonth,
  Value<int> customOrder,
  Value<bool> isPaidOff,
  Value<DateTime?> paidOffAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DebtsTableUpdateCompanionBuilder = DebtsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> accountId,
  Value<int> startingBalanceCents,
  Value<int> currentBalanceCents,
  Value<int> aprBasisPoints,
  Value<int> minimumPaymentCents,
  Value<int?> dueDayOfMonth,
  Value<int> customOrder,
  Value<bool> isPaidOff,
  Value<DateTime?> paidOffAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startingBalanceCents => $composableBuilder(
      column: $table.startingBalanceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentBalanceCents => $composableBuilder(
      column: $table.currentBalanceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aprBasisPoints => $composableBuilder(
      column: $table.aprBasisPoints,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minimumPaymentCents => $composableBuilder(
      column: $table.minimumPaymentCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDayOfMonth => $composableBuilder(
      column: $table.dueDayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get customOrder => $composableBuilder(
      column: $table.customOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaidOff => $composableBuilder(
      column: $table.isPaidOff, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidOffAt => $composableBuilder(
      column: $table.paidOffAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startingBalanceCents => $composableBuilder(
      column: $table.startingBalanceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentBalanceCents => $composableBuilder(
      column: $table.currentBalanceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aprBasisPoints => $composableBuilder(
      column: $table.aprBasisPoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minimumPaymentCents => $composableBuilder(
      column: $table.minimumPaymentCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDayOfMonth => $composableBuilder(
      column: $table.dueDayOfMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get customOrder => $composableBuilder(
      column: $table.customOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaidOff => $composableBuilder(
      column: $table.isPaidOff, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidOffAt => $composableBuilder(
      column: $table.paidOffAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
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

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get startingBalanceCents => $composableBuilder(
      column: $table.startingBalanceCents, builder: (column) => column);

  GeneratedColumn<int> get currentBalanceCents => $composableBuilder(
      column: $table.currentBalanceCents, builder: (column) => column);

  GeneratedColumn<int> get aprBasisPoints => $composableBuilder(
      column: $table.aprBasisPoints, builder: (column) => column);

  GeneratedColumn<int> get minimumPaymentCents => $composableBuilder(
      column: $table.minimumPaymentCents, builder: (column) => column);

  GeneratedColumn<int> get dueDayOfMonth => $composableBuilder(
      column: $table.dueDayOfMonth, builder: (column) => column);

  GeneratedColumn<int> get customOrder => $composableBuilder(
      column: $table.customOrder, builder: (column) => column);

  GeneratedColumn<bool> get isPaidOff =>
      $composableBuilder(column: $table.isPaidOff, builder: (column) => column);

  GeneratedColumn<DateTime> get paidOffAt =>
      $composableBuilder(column: $table.paidOffAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DebtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
    Debt,
    PrefetchHooks Function()> {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> accountId = const Value.absent(),
            Value<int> startingBalanceCents = const Value.absent(),
            Value<int> currentBalanceCents = const Value.absent(),
            Value<int> aprBasisPoints = const Value.absent(),
            Value<int> minimumPaymentCents = const Value.absent(),
            Value<int?> dueDayOfMonth = const Value.absent(),
            Value<int> customOrder = const Value.absent(),
            Value<bool> isPaidOff = const Value.absent(),
            Value<DateTime?> paidOffAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DebtsCompanion(
            id: id,
            name: name,
            accountId: accountId,
            startingBalanceCents: startingBalanceCents,
            currentBalanceCents: currentBalanceCents,
            aprBasisPoints: aprBasisPoints,
            minimumPaymentCents: minimumPaymentCents,
            dueDayOfMonth: dueDayOfMonth,
            customOrder: customOrder,
            isPaidOff: isPaidOff,
            paidOffAt: paidOffAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int?> accountId = const Value.absent(),
            required int startingBalanceCents,
            required int currentBalanceCents,
            required int aprBasisPoints,
            required int minimumPaymentCents,
            Value<int?> dueDayOfMonth = const Value.absent(),
            Value<int> customOrder = const Value.absent(),
            Value<bool> isPaidOff = const Value.absent(),
            Value<DateTime?> paidOffAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DebtsCompanion.insert(
            id: id,
            name: name,
            accountId: accountId,
            startingBalanceCents: startingBalanceCents,
            currentBalanceCents: currentBalanceCents,
            aprBasisPoints: aprBasisPoints,
            minimumPaymentCents: minimumPaymentCents,
            dueDayOfMonth: dueDayOfMonth,
            customOrder: customOrder,
            isPaidOff: isPaidOff,
            paidOffAt: paidOffAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DebtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
    Debt,
    PrefetchHooks Function()>;
typedef $$DebtPlansTableCreateCompanionBuilder = DebtPlansCompanion Function({
  Value<int> id,
  required DebtStrategy strategy,
  Value<int> extraMonthlyCents,
  required DateTime startDate,
  Value<DateTime> updatedAt,
});
typedef $$DebtPlansTableUpdateCompanionBuilder = DebtPlansCompanion Function({
  Value<int> id,
  Value<DebtStrategy> strategy,
  Value<int> extraMonthlyCents,
  Value<DateTime> startDate,
  Value<DateTime> updatedAt,
});

class $$DebtPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DebtPlansTable> {
  $$DebtPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DebtStrategy, DebtStrategy, String>
      get strategy => $composableBuilder(
          column: $table.strategy,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get extraMonthlyCents => $composableBuilder(
      column: $table.extraMonthlyCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DebtPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtPlansTable> {
  $$DebtPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strategy => $composableBuilder(
      column: $table.strategy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get extraMonthlyCents => $composableBuilder(
      column: $table.extraMonthlyCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DebtPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtPlansTable> {
  $$DebtPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DebtStrategy, String> get strategy =>
      $composableBuilder(column: $table.strategy, builder: (column) => column);

  GeneratedColumn<int> get extraMonthlyCents => $composableBuilder(
      column: $table.extraMonthlyCents, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DebtPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtPlansTable,
    DebtPlan,
    $$DebtPlansTableFilterComposer,
    $$DebtPlansTableOrderingComposer,
    $$DebtPlansTableAnnotationComposer,
    $$DebtPlansTableCreateCompanionBuilder,
    $$DebtPlansTableUpdateCompanionBuilder,
    (DebtPlan, BaseReferences<_$AppDatabase, $DebtPlansTable, DebtPlan>),
    DebtPlan,
    PrefetchHooks Function()> {
  $$DebtPlansTableTableManager(_$AppDatabase db, $DebtPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DebtStrategy> strategy = const Value.absent(),
            Value<int> extraMonthlyCents = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DebtPlansCompanion(
            id: id,
            strategy: strategy,
            extraMonthlyCents: extraMonthlyCents,
            startDate: startDate,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DebtStrategy strategy,
            Value<int> extraMonthlyCents = const Value.absent(),
            required DateTime startDate,
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DebtPlansCompanion.insert(
            id: id,
            strategy: strategy,
            extraMonthlyCents: extraMonthlyCents,
            startDate: startDate,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DebtPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtPlansTable,
    DebtPlan,
    $$DebtPlansTableFilterComposer,
    $$DebtPlansTableOrderingComposer,
    $$DebtPlansTableAnnotationComposer,
    $$DebtPlansTableCreateCompanionBuilder,
    $$DebtPlansTableUpdateCompanionBuilder,
    (DebtPlan, BaseReferences<_$AppDatabase, $DebtPlansTable, DebtPlan>),
    DebtPlan,
    PrefetchHooks Function()>;
typedef $$HoldingsTableCreateCompanionBuilder = HoldingsCompanion Function({
  Value<int> id,
  required int accountId,
  required String symbol,
  Value<String?> name,
  required double quantity,
  Value<int?> costBasisCents,
  Value<int?> lastPriceCents,
  Value<DateTime?> lastPriceAt,
  Value<DateTime> updatedAt,
});
typedef $$HoldingsTableUpdateCompanionBuilder = HoldingsCompanion Function({
  Value<int> id,
  Value<int> accountId,
  Value<String> symbol,
  Value<String?> name,
  Value<double> quantity,
  Value<int?> costBasisCents,
  Value<int?> lastPriceCents,
  Value<DateTime?> lastPriceAt,
  Value<DateTime> updatedAt,
});

class $$HoldingsTableFilterComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get costBasisCents => $composableBuilder(
      column: $table.costBasisCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPriceCents => $composableBuilder(
      column: $table.lastPriceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPriceAt => $composableBuilder(
      column: $table.lastPriceAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HoldingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get costBasisCents => $composableBuilder(
      column: $table.costBasisCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPriceCents => $composableBuilder(
      column: $table.lastPriceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPriceAt => $composableBuilder(
      column: $table.lastPriceAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HoldingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HoldingsTable> {
  $$HoldingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get costBasisCents => $composableBuilder(
      column: $table.costBasisCents, builder: (column) => column);

  GeneratedColumn<int> get lastPriceCents => $composableBuilder(
      column: $table.lastPriceCents, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPriceAt => $composableBuilder(
      column: $table.lastPriceAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HoldingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HoldingsTable,
    Holding,
    $$HoldingsTableFilterComposer,
    $$HoldingsTableOrderingComposer,
    $$HoldingsTableAnnotationComposer,
    $$HoldingsTableCreateCompanionBuilder,
    $$HoldingsTableUpdateCompanionBuilder,
    (Holding, BaseReferences<_$AppDatabase, $HoldingsTable, Holding>),
    Holding,
    PrefetchHooks Function()> {
  $$HoldingsTableTableManager(_$AppDatabase db, $HoldingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HoldingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HoldingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HoldingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<int?> costBasisCents = const Value.absent(),
            Value<int?> lastPriceCents = const Value.absent(),
            Value<DateTime?> lastPriceAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HoldingsCompanion(
            id: id,
            accountId: accountId,
            symbol: symbol,
            name: name,
            quantity: quantity,
            costBasisCents: costBasisCents,
            lastPriceCents: lastPriceCents,
            lastPriceAt: lastPriceAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int accountId,
            required String symbol,
            Value<String?> name = const Value.absent(),
            required double quantity,
            Value<int?> costBasisCents = const Value.absent(),
            Value<int?> lastPriceCents = const Value.absent(),
            Value<DateTime?> lastPriceAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HoldingsCompanion.insert(
            id: id,
            accountId: accountId,
            symbol: symbol,
            name: name,
            quantity: quantity,
            costBasisCents: costBasisCents,
            lastPriceCents: lastPriceCents,
            lastPriceAt: lastPriceAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HoldingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HoldingsTable,
    Holding,
    $$HoldingsTableFilterComposer,
    $$HoldingsTableOrderingComposer,
    $$HoldingsTableAnnotationComposer,
    $$HoldingsTableCreateCompanionBuilder,
    $$HoldingsTableUpdateCompanionBuilder,
    (Holding, BaseReferences<_$AppDatabase, $HoldingsTable, Holding>),
    Holding,
    PrefetchHooks Function()>;
typedef $$NetWorthSnapshotsTableCreateCompanionBuilder
    = NetWorthSnapshotsCompanion Function({
  Value<int> id,
  required DateTime date,
  required int assetsCents,
  required int liabilitiesCents,
  required int netWorthCents,
});
typedef $$NetWorthSnapshotsTableUpdateCompanionBuilder
    = NetWorthSnapshotsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> assetsCents,
  Value<int> liabilitiesCents,
  Value<int> netWorthCents,
});

class $$NetWorthSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assetsCents => $composableBuilder(
      column: $table.assetsCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get liabilitiesCents => $composableBuilder(
      column: $table.liabilitiesCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get netWorthCents => $composableBuilder(
      column: $table.netWorthCents, builder: (column) => ColumnFilters(column));
}

class $$NetWorthSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assetsCents => $composableBuilder(
      column: $table.assetsCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get liabilitiesCents => $composableBuilder(
      column: $table.liabilitiesCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get netWorthCents => $composableBuilder(
      column: $table.netWorthCents,
      builder: (column) => ColumnOrderings(column));
}

class $$NetWorthSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get assetsCents => $composableBuilder(
      column: $table.assetsCents, builder: (column) => column);

  GeneratedColumn<int> get liabilitiesCents => $composableBuilder(
      column: $table.liabilitiesCents, builder: (column) => column);

  GeneratedColumn<int> get netWorthCents => $composableBuilder(
      column: $table.netWorthCents, builder: (column) => column);
}

class $$NetWorthSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NetWorthSnapshotsTable,
    NetWorthSnapshot,
    $$NetWorthSnapshotsTableFilterComposer,
    $$NetWorthSnapshotsTableOrderingComposer,
    $$NetWorthSnapshotsTableAnnotationComposer,
    $$NetWorthSnapshotsTableCreateCompanionBuilder,
    $$NetWorthSnapshotsTableUpdateCompanionBuilder,
    (
      NetWorthSnapshot,
      BaseReferences<_$AppDatabase, $NetWorthSnapshotsTable, NetWorthSnapshot>
    ),
    NetWorthSnapshot,
    PrefetchHooks Function()> {
  $$NetWorthSnapshotsTableTableManager(
      _$AppDatabase db, $NetWorthSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NetWorthSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NetWorthSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NetWorthSnapshotsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> assetsCents = const Value.absent(),
            Value<int> liabilitiesCents = const Value.absent(),
            Value<int> netWorthCents = const Value.absent(),
          }) =>
              NetWorthSnapshotsCompanion(
            id: id,
            date: date,
            assetsCents: assetsCents,
            liabilitiesCents: liabilitiesCents,
            netWorthCents: netWorthCents,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int assetsCents,
            required int liabilitiesCents,
            required int netWorthCents,
          }) =>
              NetWorthSnapshotsCompanion.insert(
            id: id,
            date: date,
            assetsCents: assetsCents,
            liabilitiesCents: liabilitiesCents,
            netWorthCents: netWorthCents,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NetWorthSnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NetWorthSnapshotsTable,
    NetWorthSnapshot,
    $$NetWorthSnapshotsTableFilterComposer,
    $$NetWorthSnapshotsTableOrderingComposer,
    $$NetWorthSnapshotsTableAnnotationComposer,
    $$NetWorthSnapshotsTableCreateCompanionBuilder,
    $$NetWorthSnapshotsTableUpdateCompanionBuilder,
    (
      NetWorthSnapshot,
      BaseReferences<_$AppDatabase, $NetWorthSnapshotsTable, NetWorthSnapshot>
    ),
    NetWorthSnapshot,
    PrefetchHooks Function()>;
typedef $$SavedCalculationsTableCreateCompanionBuilder
    = SavedCalculationsCompanion Function({
  Value<int> id,
  required CalculatorType calculator,
  required String title,
  required String inputsJson,
  Value<String?> resultSummary,
  Value<bool> isPinnedToHome,
  Value<DateTime> createdAt,
});
typedef $$SavedCalculationsTableUpdateCompanionBuilder
    = SavedCalculationsCompanion Function({
  Value<int> id,
  Value<CalculatorType> calculator,
  Value<String> title,
  Value<String> inputsJson,
  Value<String?> resultSummary,
  Value<bool> isPinnedToHome,
  Value<DateTime> createdAt,
});

class $$SavedCalculationsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedCalculationsTable> {
  $$SavedCalculationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CalculatorType, CalculatorType, String>
      get calculator => $composableBuilder(
          column: $table.calculator,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputsJson => $composableBuilder(
      column: $table.inputsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resultSummary => $composableBuilder(
      column: $table.resultSummary, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinnedToHome => $composableBuilder(
      column: $table.isPinnedToHome,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SavedCalculationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedCalculationsTable> {
  $$SavedCalculationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get calculator => $composableBuilder(
      column: $table.calculator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputsJson => $composableBuilder(
      column: $table.inputsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resultSummary => $composableBuilder(
      column: $table.resultSummary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinnedToHome => $composableBuilder(
      column: $table.isPinnedToHome,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SavedCalculationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedCalculationsTable> {
  $$SavedCalculationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CalculatorType, String> get calculator =>
      $composableBuilder(
          column: $table.calculator, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get inputsJson => $composableBuilder(
      column: $table.inputsJson, builder: (column) => column);

  GeneratedColumn<String> get resultSummary => $composableBuilder(
      column: $table.resultSummary, builder: (column) => column);

  GeneratedColumn<bool> get isPinnedToHome => $composableBuilder(
      column: $table.isPinnedToHome, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavedCalculationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavedCalculationsTable,
    SavedCalculation,
    $$SavedCalculationsTableFilterComposer,
    $$SavedCalculationsTableOrderingComposer,
    $$SavedCalculationsTableAnnotationComposer,
    $$SavedCalculationsTableCreateCompanionBuilder,
    $$SavedCalculationsTableUpdateCompanionBuilder,
    (
      SavedCalculation,
      BaseReferences<_$AppDatabase, $SavedCalculationsTable, SavedCalculation>
    ),
    SavedCalculation,
    PrefetchHooks Function()> {
  $$SavedCalculationsTableTableManager(
      _$AppDatabase db, $SavedCalculationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedCalculationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedCalculationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedCalculationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<CalculatorType> calculator = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> inputsJson = const Value.absent(),
            Value<String?> resultSummary = const Value.absent(),
            Value<bool> isPinnedToHome = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SavedCalculationsCompanion(
            id: id,
            calculator: calculator,
            title: title,
            inputsJson: inputsJson,
            resultSummary: resultSummary,
            isPinnedToHome: isPinnedToHome,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required CalculatorType calculator,
            required String title,
            required String inputsJson,
            Value<String?> resultSummary = const Value.absent(),
            Value<bool> isPinnedToHome = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SavedCalculationsCompanion.insert(
            id: id,
            calculator: calculator,
            title: title,
            inputsJson: inputsJson,
            resultSummary: resultSummary,
            isPinnedToHome: isPinnedToHome,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SavedCalculationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavedCalculationsTable,
    SavedCalculation,
    $$SavedCalculationsTableFilterComposer,
    $$SavedCalculationsTableOrderingComposer,
    $$SavedCalculationsTableAnnotationComposer,
    $$SavedCalculationsTableCreateCompanionBuilder,
    $$SavedCalculationsTableUpdateCompanionBuilder,
    (
      SavedCalculation,
      BaseReferences<_$AppDatabase, $SavedCalculationsTable, SavedCalculation>
    ),
    SavedCalculation,
    PrefetchHooks Function()>;
typedef $$LessonProgressTableCreateCompanionBuilder = LessonProgressCompanion
    Function({
  required String lessonId,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int?> bestQuizScore,
  Value<int> attempts,
  Value<int> rowid,
});
typedef $$LessonProgressTableUpdateCompanionBuilder = LessonProgressCompanion
    Function({
  Value<String> lessonId,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int?> bestQuizScore,
  Value<int> attempts,
  Value<int> rowid,
});

class $$LessonProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bestQuizScore => $composableBuilder(
      column: $table.bestQuizScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));
}

class $$LessonProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bestQuizScore => $composableBuilder(
      column: $table.bestQuizScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));
}

class $$LessonProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get bestQuizScore => $composableBuilder(
      column: $table.bestQuizScore, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$LessonProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonProgressTable,
    LessonProgressEntry,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (
      LessonProgressEntry,
      BaseReferences<_$AppDatabase, $LessonProgressTable, LessonProgressEntry>
    ),
    LessonProgressEntry,
    PrefetchHooks Function()> {
  $$LessonProgressTableTableManager(
      _$AppDatabase db, $LessonProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int?> bestQuizScore = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressCompanion(
            lessonId: lessonId,
            startedAt: startedAt,
            completedAt: completedAt,
            bestQuizScore: bestQuizScore,
            attempts: attempts,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int?> bestQuizScore = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressCompanion.insert(
            lessonId: lessonId,
            startedAt: startedAt,
            completedAt: completedAt,
            bestQuizScore: bestQuizScore,
            attempts: attempts,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonProgressTable,
    LessonProgressEntry,
    $$LessonProgressTableFilterComposer,
    $$LessonProgressTableOrderingComposer,
    $$LessonProgressTableAnnotationComposer,
    $$LessonProgressTableCreateCompanionBuilder,
    $$LessonProgressTableUpdateCompanionBuilder,
    (
      LessonProgressEntry,
      BaseReferences<_$AppDatabase, $LessonProgressTable, LessonProgressEntry>
    ),
    LessonProgressEntry,
    PrefetchHooks Function()>;
typedef $$ActivityDaysTableCreateCompanionBuilder = ActivityDaysCompanion
    Function({
  required String day,
  Value<int> xpEarned,
  Value<int> rowid,
});
typedef $$ActivityDaysTableUpdateCompanionBuilder = ActivityDaysCompanion
    Function({
  Value<String> day,
  Value<int> xpEarned,
  Value<int> rowid,
});

class $$ActivityDaysTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityDaysTable> {
  $$ActivityDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));
}

class $$ActivityDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityDaysTable> {
  $$ActivityDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));
}

class $$ActivityDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityDaysTable> {
  $$ActivityDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);
}

class $$ActivityDaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActivityDaysTable,
    ActivityDay,
    $$ActivityDaysTableFilterComposer,
    $$ActivityDaysTableOrderingComposer,
    $$ActivityDaysTableAnnotationComposer,
    $$ActivityDaysTableCreateCompanionBuilder,
    $$ActivityDaysTableUpdateCompanionBuilder,
    (
      ActivityDay,
      BaseReferences<_$AppDatabase, $ActivityDaysTable, ActivityDay>
    ),
    ActivityDay,
    PrefetchHooks Function()> {
  $$ActivityDaysTableTableManager(_$AppDatabase db, $ActivityDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> day = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityDaysCompanion(
            day: day,
            xpEarned: xpEarned,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String day,
            Value<int> xpEarned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityDaysCompanion.insert(
            day: day,
            xpEarned: xpEarned,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivityDaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActivityDaysTable,
    ActivityDay,
    $$ActivityDaysTableFilterComposer,
    $$ActivityDaysTableOrderingComposer,
    $$ActivityDaysTableAnnotationComposer,
    $$ActivityDaysTableCreateCompanionBuilder,
    $$ActivityDaysTableUpdateCompanionBuilder,
    (
      ActivityDay,
      BaseReferences<_$AppDatabase, $ActivityDaysTable, ActivityDay>
    ),
    ActivityDay,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$CategoryGroupsTableTableManager get categoryGroups =>
      $$CategoryGroupsTableTableManager(_db, _db.categoryGroups);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BudgetAllocationsTableTableManager get budgetAllocations =>
      $$BudgetAllocationsTableTableManager(_db, _db.budgetAllocations);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$RecurringItemsTableTableManager get recurringItems =>
      $$RecurringItemsTableTableManager(_db, _db.recurringItems);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$DebtPlansTableTableManager get debtPlans =>
      $$DebtPlansTableTableManager(_db, _db.debtPlans);
  $$HoldingsTableTableManager get holdings =>
      $$HoldingsTableTableManager(_db, _db.holdings);
  $$NetWorthSnapshotsTableTableManager get netWorthSnapshots =>
      $$NetWorthSnapshotsTableTableManager(_db, _db.netWorthSnapshots);
  $$SavedCalculationsTableTableManager get savedCalculations =>
      $$SavedCalculationsTableTableManager(_db, _db.savedCalculations);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(_db, _db.lessonProgress);
  $$ActivityDaysTableTableManager get activityDays =>
      $$ActivityDaysTableTableManager(_db, _db.activityDays);
}
