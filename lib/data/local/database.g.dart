// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorksTable extends Works with TableInfo<$WorksTable, WorkItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workIdMeta = const VerificationMeta('workId');
  @override
  late final GeneratedColumn<int> workId = GeneratedColumn<int>(
      'work_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _workCodeMeta =
      const VerificationMeta('workCode');
  @override
  late final GeneratedColumn<String> workCode = GeneratedColumn<String>(
      'work_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workDescriptionMeta =
      const VerificationMeta('workDescription');
  @override
  late final GeneratedColumn<String> workDescription = GeneratedColumn<String>(
      'work_description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workStatusNameMeta =
      const VerificationMeta('workStatusName');
  @override
  late final GeneratedColumn<String> workStatusName = GeneratedColumn<String>(
      'work_status_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workStaffNameMeta =
      const VerificationMeta('workStaffName');
  @override
  late final GeneratedColumn<String> workStaffName = GeneratedColumn<String>(
      'work_staff_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workCreatedDateMeta =
      const VerificationMeta('workCreatedDate');
  @override
  late final GeneratedColumn<String> workCreatedDate = GeneratedColumn<String>(
      'work_created_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jsonContentMeta =
      const VerificationMeta('jsonContent');
  @override
  late final GeneratedColumn<String> jsonContent = GeneratedColumn<String>(
      'json_content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        workId,
        workCode,
        workDescription,
        workStatusName,
        workStaffName,
        workCreatedDate,
        jsonContent
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'works';
  @override
  VerificationContext validateIntegrity(Insertable<WorkItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('work_id')) {
      context.handle(_workIdMeta,
          workId.isAcceptableOrUnknown(data['work_id']!, _workIdMeta));
    }
    if (data.containsKey('work_code')) {
      context.handle(_workCodeMeta,
          workCode.isAcceptableOrUnknown(data['work_code']!, _workCodeMeta));
    } else if (isInserting) {
      context.missing(_workCodeMeta);
    }
    if (data.containsKey('work_description')) {
      context.handle(
          _workDescriptionMeta,
          workDescription.isAcceptableOrUnknown(
              data['work_description']!, _workDescriptionMeta));
    }
    if (data.containsKey('work_status_name')) {
      context.handle(
          _workStatusNameMeta,
          workStatusName.isAcceptableOrUnknown(
              data['work_status_name']!, _workStatusNameMeta));
    }
    if (data.containsKey('work_staff_name')) {
      context.handle(
          _workStaffNameMeta,
          workStaffName.isAcceptableOrUnknown(
              data['work_staff_name']!, _workStaffNameMeta));
    }
    if (data.containsKey('work_created_date')) {
      context.handle(
          _workCreatedDateMeta,
          workCreatedDate.isAcceptableOrUnknown(
              data['work_created_date']!, _workCreatedDateMeta));
    }
    if (data.containsKey('json_content')) {
      context.handle(
          _jsonContentMeta,
          jsonContent.isAcceptableOrUnknown(
              data['json_content']!, _jsonContentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workCode};
  @override
  WorkItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkItem(
      workId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_id']),
      workCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_code'])!,
      workDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}work_description']),
      workStatusName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}work_status_name']),
      workStaffName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_staff_name']),
      workCreatedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}work_created_date']),
      jsonContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_content']),
    );
  }

  @override
  $WorksTable createAlias(String alias) {
    return $WorksTable(attachedDatabase, alias);
  }
}

class WorkItem extends DataClass implements Insertable<WorkItem> {
  final int? workId;
  final String workCode;
  final String? workDescription;
  final String? workStatusName;
  final String? workStaffName;
  final String? workCreatedDate;
  final String? jsonContent;
  const WorkItem(
      {this.workId,
      required this.workCode,
      this.workDescription,
      this.workStatusName,
      this.workStaffName,
      this.workCreatedDate,
      this.jsonContent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || workId != null) {
      map['work_id'] = Variable<int>(workId);
    }
    map['work_code'] = Variable<String>(workCode);
    if (!nullToAbsent || workDescription != null) {
      map['work_description'] = Variable<String>(workDescription);
    }
    if (!nullToAbsent || workStatusName != null) {
      map['work_status_name'] = Variable<String>(workStatusName);
    }
    if (!nullToAbsent || workStaffName != null) {
      map['work_staff_name'] = Variable<String>(workStaffName);
    }
    if (!nullToAbsent || workCreatedDate != null) {
      map['work_created_date'] = Variable<String>(workCreatedDate);
    }
    if (!nullToAbsent || jsonContent != null) {
      map['json_content'] = Variable<String>(jsonContent);
    }
    return map;
  }

  WorksCompanion toCompanion(bool nullToAbsent) {
    return WorksCompanion(
      workId:
          workId == null && nullToAbsent ? const Value.absent() : Value(workId),
      workCode: Value(workCode),
      workDescription: workDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(workDescription),
      workStatusName: workStatusName == null && nullToAbsent
          ? const Value.absent()
          : Value(workStatusName),
      workStaffName: workStaffName == null && nullToAbsent
          ? const Value.absent()
          : Value(workStaffName),
      workCreatedDate: workCreatedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(workCreatedDate),
      jsonContent: jsonContent == null && nullToAbsent
          ? const Value.absent()
          : Value(jsonContent),
    );
  }

  factory WorkItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkItem(
      workId: serializer.fromJson<int?>(json['workId']),
      workCode: serializer.fromJson<String>(json['workCode']),
      workDescription: serializer.fromJson<String?>(json['workDescription']),
      workStatusName: serializer.fromJson<String?>(json['workStatusName']),
      workStaffName: serializer.fromJson<String?>(json['workStaffName']),
      workCreatedDate: serializer.fromJson<String?>(json['workCreatedDate']),
      jsonContent: serializer.fromJson<String?>(json['jsonContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workId': serializer.toJson<int?>(workId),
      'workCode': serializer.toJson<String>(workCode),
      'workDescription': serializer.toJson<String?>(workDescription),
      'workStatusName': serializer.toJson<String?>(workStatusName),
      'workStaffName': serializer.toJson<String?>(workStaffName),
      'workCreatedDate': serializer.toJson<String?>(workCreatedDate),
      'jsonContent': serializer.toJson<String?>(jsonContent),
    };
  }

  WorkItem copyWith(
          {Value<int?> workId = const Value.absent(),
          String? workCode,
          Value<String?> workDescription = const Value.absent(),
          Value<String?> workStatusName = const Value.absent(),
          Value<String?> workStaffName = const Value.absent(),
          Value<String?> workCreatedDate = const Value.absent(),
          Value<String?> jsonContent = const Value.absent()}) =>
      WorkItem(
        workId: workId.present ? workId.value : this.workId,
        workCode: workCode ?? this.workCode,
        workDescription: workDescription.present
            ? workDescription.value
            : this.workDescription,
        workStatusName:
            workStatusName.present ? workStatusName.value : this.workStatusName,
        workStaffName:
            workStaffName.present ? workStaffName.value : this.workStaffName,
        workCreatedDate: workCreatedDate.present
            ? workCreatedDate.value
            : this.workCreatedDate,
        jsonContent: jsonContent.present ? jsonContent.value : this.jsonContent,
      );
  WorkItem copyWithCompanion(WorksCompanion data) {
    return WorkItem(
      workId: data.workId.present ? data.workId.value : this.workId,
      workCode: data.workCode.present ? data.workCode.value : this.workCode,
      workDescription: data.workDescription.present
          ? data.workDescription.value
          : this.workDescription,
      workStatusName: data.workStatusName.present
          ? data.workStatusName.value
          : this.workStatusName,
      workStaffName: data.workStaffName.present
          ? data.workStaffName.value
          : this.workStaffName,
      workCreatedDate: data.workCreatedDate.present
          ? data.workCreatedDate.value
          : this.workCreatedDate,
      jsonContent:
          data.jsonContent.present ? data.jsonContent.value : this.jsonContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkItem(')
          ..write('workId: $workId, ')
          ..write('workCode: $workCode, ')
          ..write('workDescription: $workDescription, ')
          ..write('workStatusName: $workStatusName, ')
          ..write('workStaffName: $workStaffName, ')
          ..write('workCreatedDate: $workCreatedDate, ')
          ..write('jsonContent: $jsonContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workId, workCode, workDescription,
      workStatusName, workStaffName, workCreatedDate, jsonContent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkItem &&
          other.workId == this.workId &&
          other.workCode == this.workCode &&
          other.workDescription == this.workDescription &&
          other.workStatusName == this.workStatusName &&
          other.workStaffName == this.workStaffName &&
          other.workCreatedDate == this.workCreatedDate &&
          other.jsonContent == this.jsonContent);
}

class WorksCompanion extends UpdateCompanion<WorkItem> {
  final Value<int?> workId;
  final Value<String> workCode;
  final Value<String?> workDescription;
  final Value<String?> workStatusName;
  final Value<String?> workStaffName;
  final Value<String?> workCreatedDate;
  final Value<String?> jsonContent;
  final Value<int> rowid;
  const WorksCompanion({
    this.workId = const Value.absent(),
    this.workCode = const Value.absent(),
    this.workDescription = const Value.absent(),
    this.workStatusName = const Value.absent(),
    this.workStaffName = const Value.absent(),
    this.workCreatedDate = const Value.absent(),
    this.jsonContent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorksCompanion.insert({
    this.workId = const Value.absent(),
    required String workCode,
    this.workDescription = const Value.absent(),
    this.workStatusName = const Value.absent(),
    this.workStaffName = const Value.absent(),
    this.workCreatedDate = const Value.absent(),
    this.jsonContent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workCode = Value(workCode);
  static Insertable<WorkItem> custom({
    Expression<int>? workId,
    Expression<String>? workCode,
    Expression<String>? workDescription,
    Expression<String>? workStatusName,
    Expression<String>? workStaffName,
    Expression<String>? workCreatedDate,
    Expression<String>? jsonContent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workId != null) 'work_id': workId,
      if (workCode != null) 'work_code': workCode,
      if (workDescription != null) 'work_description': workDescription,
      if (workStatusName != null) 'work_status_name': workStatusName,
      if (workStaffName != null) 'work_staff_name': workStaffName,
      if (workCreatedDate != null) 'work_created_date': workCreatedDate,
      if (jsonContent != null) 'json_content': jsonContent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorksCompanion copyWith(
      {Value<int?>? workId,
      Value<String>? workCode,
      Value<String?>? workDescription,
      Value<String?>? workStatusName,
      Value<String?>? workStaffName,
      Value<String?>? workCreatedDate,
      Value<String?>? jsonContent,
      Value<int>? rowid}) {
    return WorksCompanion(
      workId: workId ?? this.workId,
      workCode: workCode ?? this.workCode,
      workDescription: workDescription ?? this.workDescription,
      workStatusName: workStatusName ?? this.workStatusName,
      workStaffName: workStaffName ?? this.workStaffName,
      workCreatedDate: workCreatedDate ?? this.workCreatedDate,
      jsonContent: jsonContent ?? this.jsonContent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workId.present) {
      map['work_id'] = Variable<int>(workId.value);
    }
    if (workCode.present) {
      map['work_code'] = Variable<String>(workCode.value);
    }
    if (workDescription.present) {
      map['work_description'] = Variable<String>(workDescription.value);
    }
    if (workStatusName.present) {
      map['work_status_name'] = Variable<String>(workStatusName.value);
    }
    if (workStaffName.present) {
      map['work_staff_name'] = Variable<String>(workStaffName.value);
    }
    if (workCreatedDate.present) {
      map['work_created_date'] = Variable<String>(workCreatedDate.value);
    }
    if (jsonContent.present) {
      map['json_content'] = Variable<String>(jsonContent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorksCompanion(')
          ..write('workId: $workId, ')
          ..write('workCode: $workCode, ')
          ..write('workDescription: $workDescription, ')
          ..write('workStatusName: $workStatusName, ')
          ..write('workStaffName: $workStaffName, ')
          ..write('workCreatedDate: $workCreatedDate, ')
          ..write('jsonContent: $jsonContent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorksTable works = $WorksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [works];
}

typedef $$WorksTableCreateCompanionBuilder = WorksCompanion Function({
  Value<int?> workId,
  required String workCode,
  Value<String?> workDescription,
  Value<String?> workStatusName,
  Value<String?> workStaffName,
  Value<String?> workCreatedDate,
  Value<String?> jsonContent,
  Value<int> rowid,
});
typedef $$WorksTableUpdateCompanionBuilder = WorksCompanion Function({
  Value<int?> workId,
  Value<String> workCode,
  Value<String?> workDescription,
  Value<String?> workStatusName,
  Value<String?> workStaffName,
  Value<String?> workCreatedDate,
  Value<String?> jsonContent,
  Value<int> rowid,
});

class $$WorksTableFilterComposer extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get workId => $composableBuilder(
      column: $table.workId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workCode => $composableBuilder(
      column: $table.workCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workDescription => $composableBuilder(
      column: $table.workDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workStatusName => $composableBuilder(
      column: $table.workStatusName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workStaffName => $composableBuilder(
      column: $table.workStaffName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workCreatedDate => $composableBuilder(
      column: $table.workCreatedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonContent => $composableBuilder(
      column: $table.jsonContent, builder: (column) => ColumnFilters(column));
}

class $$WorksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get workId => $composableBuilder(
      column: $table.workId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workCode => $composableBuilder(
      column: $table.workCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workDescription => $composableBuilder(
      column: $table.workDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workStatusName => $composableBuilder(
      column: $table.workStatusName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workStaffName => $composableBuilder(
      column: $table.workStaffName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workCreatedDate => $composableBuilder(
      column: $table.workCreatedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonContent => $composableBuilder(
      column: $table.jsonContent, builder: (column) => ColumnOrderings(column));
}

class $$WorksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorksTable> {
  $$WorksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get workId =>
      $composableBuilder(column: $table.workId, builder: (column) => column);

  GeneratedColumn<String> get workCode =>
      $composableBuilder(column: $table.workCode, builder: (column) => column);

  GeneratedColumn<String> get workDescription => $composableBuilder(
      column: $table.workDescription, builder: (column) => column);

  GeneratedColumn<String> get workStatusName => $composableBuilder(
      column: $table.workStatusName, builder: (column) => column);

  GeneratedColumn<String> get workStaffName => $composableBuilder(
      column: $table.workStaffName, builder: (column) => column);

  GeneratedColumn<String> get workCreatedDate => $composableBuilder(
      column: $table.workCreatedDate, builder: (column) => column);

  GeneratedColumn<String> get jsonContent => $composableBuilder(
      column: $table.jsonContent, builder: (column) => column);
}

class $$WorksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorksTable,
    WorkItem,
    $$WorksTableFilterComposer,
    $$WorksTableOrderingComposer,
    $$WorksTableAnnotationComposer,
    $$WorksTableCreateCompanionBuilder,
    $$WorksTableUpdateCompanionBuilder,
    (WorkItem, BaseReferences<_$AppDatabase, $WorksTable, WorkItem>),
    WorkItem,
    PrefetchHooks Function()> {
  $$WorksTableTableManager(_$AppDatabase db, $WorksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> workId = const Value.absent(),
            Value<String> workCode = const Value.absent(),
            Value<String?> workDescription = const Value.absent(),
            Value<String?> workStatusName = const Value.absent(),
            Value<String?> workStaffName = const Value.absent(),
            Value<String?> workCreatedDate = const Value.absent(),
            Value<String?> jsonContent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorksCompanion(
            workId: workId,
            workCode: workCode,
            workDescription: workDescription,
            workStatusName: workStatusName,
            workStaffName: workStaffName,
            workCreatedDate: workCreatedDate,
            jsonContent: jsonContent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> workId = const Value.absent(),
            required String workCode,
            Value<String?> workDescription = const Value.absent(),
            Value<String?> workStatusName = const Value.absent(),
            Value<String?> workStaffName = const Value.absent(),
            Value<String?> workCreatedDate = const Value.absent(),
            Value<String?> jsonContent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorksCompanion.insert(
            workId: workId,
            workCode: workCode,
            workDescription: workDescription,
            workStatusName: workStatusName,
            workStaffName: workStaffName,
            workCreatedDate: workCreatedDate,
            jsonContent: jsonContent,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorksTable,
    WorkItem,
    $$WorksTableFilterComposer,
    $$WorksTableOrderingComposer,
    $$WorksTableAnnotationComposer,
    $$WorksTableCreateCompanionBuilder,
    $$WorksTableUpdateCompanionBuilder,
    (WorkItem, BaseReferences<_$AppDatabase, $WorksTable, WorkItem>),
    WorkItem,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorksTableTableManager get works =>
      $$WorksTableTableManager(_db, _db.works);
}
