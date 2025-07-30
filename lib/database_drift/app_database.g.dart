// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $JourneyTableTable extends JourneyTable
    with TableInfo<$JourneyTableTable, Journey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateWithTimeMeta = const VerificationMeta(
    'dateWithTime',
  );
  @override
  late final GeneratedColumn<DateTime> dateWithTime = GeneratedColumn<DateTime>(
    'date_with_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMeta = const VerificationMeta(
    'distance',
  );
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
    'distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('walking'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateWithTime,
    duration,
    distance,
    steps,
    calories,
    mode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Journey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_with_time')) {
      context.handle(
        _dateWithTimeMeta,
        dateWithTime.isAcceptableOrUnknown(
          data['date_with_time']!,
          _dateWithTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateWithTimeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(
        _distanceMeta,
        distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Journey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Journey.fromDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dateWithTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_with_time'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      distance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
    );
  }

  @override
  $JourneyTableTable createAlias(String alias) {
    return $JourneyTableTable(attachedDatabase, alias);
  }
}

class JourneyTableCompanion extends UpdateCompanion<Journey> {
  final Value<int> id;
  final Value<DateTime> dateWithTime;
  final Value<int> duration;
  final Value<double> distance;
  final Value<int> steps;
  final Value<double> calories;
  final Value<String> mode;
  const JourneyTableCompanion({
    this.id = const Value.absent(),
    this.dateWithTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.distance = const Value.absent(),
    this.steps = const Value.absent(),
    this.calories = const Value.absent(),
    this.mode = const Value.absent(),
  });
  JourneyTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime dateWithTime,
    required int duration,
    required double distance,
    this.steps = const Value.absent(),
    this.calories = const Value.absent(),
    this.mode = const Value.absent(),
  }) : dateWithTime = Value(dateWithTime),
       duration = Value(duration),
       distance = Value(distance);
  static Insertable<Journey> custom({
    Expression<int>? id,
    Expression<DateTime>? dateWithTime,
    Expression<int>? duration,
    Expression<double>? distance,
    Expression<int>? steps,
    Expression<double>? calories,
    Expression<String>? mode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateWithTime != null) 'date_with_time': dateWithTime,
      if (duration != null) 'duration': duration,
      if (distance != null) 'distance': distance,
      if (steps != null) 'steps': steps,
      if (calories != null) 'calories': calories,
      if (mode != null) 'mode': mode,
    });
  }

  JourneyTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? dateWithTime,
    Value<int>? duration,
    Value<double>? distance,
    Value<int>? steps,
    Value<double>? calories,
    Value<String>? mode,
  }) {
    return JourneyTableCompanion(
      id: id ?? this.id,
      dateWithTime: dateWithTime ?? this.dateWithTime,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      mode: mode ?? this.mode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateWithTime.present) {
      map['date_with_time'] = Variable<DateTime>(dateWithTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneyTableCompanion(')
          ..write('id: $id, ')
          ..write('dateWithTime: $dateWithTime, ')
          ..write('duration: $duration, ')
          ..write('distance: $distance, ')
          ..write('steps: $steps, ')
          ..write('calories: $calories, ')
          ..write('mode: $mode')
          ..write(')'))
        .toString();
  }
}

class $JourneyCoordinatesTableTable extends JourneyCoordinatesTable
    with TableInfo<$JourneyCoordinatesTableTable, JourneyCoordinates> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyCoordinatesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _journeyIdMeta = const VerificationMeta(
    'journeyId',
  );
  @override
  late final GeneratedColumn<int> journeyId = GeneratedColumn<int>(
    'journey_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, journeyId, latitude, longitude];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_coordinates_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<JourneyCoordinates> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('journey_id')) {
      context.handle(
        _journeyIdMeta,
        journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JourneyCoordinates map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JourneyCoordinates.fromDb(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      journeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journey_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
    );
  }

  @override
  $JourneyCoordinatesTableTable createAlias(String alias) {
    return $JourneyCoordinatesTableTable(attachedDatabase, alias);
  }
}

class JourneyCoordinatesTableCompanion
    extends UpdateCompanion<JourneyCoordinates> {
  final Value<int> id;
  final Value<int> journeyId;
  final Value<double> latitude;
  final Value<double> longitude;
  const JourneyCoordinatesTableCompanion({
    this.id = const Value.absent(),
    this.journeyId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  JourneyCoordinatesTableCompanion.insert({
    this.id = const Value.absent(),
    required int journeyId,
    required double latitude,
    required double longitude,
  }) : journeyId = Value(journeyId),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<JourneyCoordinates> custom({
    Expression<int>? id,
    Expression<int>? journeyId,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journeyId != null) 'journey_id': journeyId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  JourneyCoordinatesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? journeyId,
    Value<double>? latitude,
    Value<double>? longitude,
  }) {
    return JourneyCoordinatesTableCompanion(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (journeyId.present) {
      map['journey_id'] = Variable<int>(journeyId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneyCoordinatesTableCompanion(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JourneyTableTable journeyTable = $JourneyTableTable(this);
  late final $JourneyCoordinatesTableTable journeyCoordinatesTable =
      $JourneyCoordinatesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    journeyTable,
    journeyCoordinatesTable,
  ];
}

typedef $$JourneyTableTableCreateCompanionBuilder =
    JourneyTableCompanion Function({
      Value<int> id,
      required DateTime dateWithTime,
      required int duration,
      required double distance,
      Value<int> steps,
      Value<double> calories,
      Value<String> mode,
    });
typedef $$JourneyTableTableUpdateCompanionBuilder =
    JourneyTableCompanion Function({
      Value<int> id,
      Value<DateTime> dateWithTime,
      Value<int> duration,
      Value<double> distance,
      Value<int> steps,
      Value<double> calories,
      Value<String> mode,
    });

class $$JourneyTableTableFilterComposer
    extends Composer<_$AppDatabase, $JourneyTableTable> {
  $$JourneyTableTableFilterComposer({
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

  ColumnFilters<DateTime> get dateWithTime => $composableBuilder(
    column: $table.dateWithTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JourneyTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneyTableTable> {
  $$JourneyTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dateWithTime => $composableBuilder(
    column: $table.dateWithTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JourneyTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneyTableTable> {
  $$JourneyTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dateWithTime => $composableBuilder(
    column: $table.dateWithTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);
}

class $$JourneyTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneyTableTable,
          Journey,
          $$JourneyTableTableFilterComposer,
          $$JourneyTableTableOrderingComposer,
          $$JourneyTableTableAnnotationComposer,
          $$JourneyTableTableCreateCompanionBuilder,
          $$JourneyTableTableUpdateCompanionBuilder,
          (Journey, BaseReferences<_$AppDatabase, $JourneyTableTable, Journey>),
          Journey,
          PrefetchHooks Function()
        > {
  $$JourneyTableTableTableManager(_$AppDatabase db, $JourneyTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JourneyTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JourneyTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> dateWithTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<double> distance = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<String> mode = const Value.absent(),
              }) => JourneyTableCompanion(
                id: id,
                dateWithTime: dateWithTime,
                duration: duration,
                distance: distance,
                steps: steps,
                calories: calories,
                mode: mode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime dateWithTime,
                required int duration,
                required double distance,
                Value<int> steps = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<String> mode = const Value.absent(),
              }) => JourneyTableCompanion.insert(
                id: id,
                dateWithTime: dateWithTime,
                duration: duration,
                distance: distance,
                steps: steps,
                calories: calories,
                mode: mode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JourneyTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneyTableTable,
      Journey,
      $$JourneyTableTableFilterComposer,
      $$JourneyTableTableOrderingComposer,
      $$JourneyTableTableAnnotationComposer,
      $$JourneyTableTableCreateCompanionBuilder,
      $$JourneyTableTableUpdateCompanionBuilder,
      (Journey, BaseReferences<_$AppDatabase, $JourneyTableTable, Journey>),
      Journey,
      PrefetchHooks Function()
    >;
typedef $$JourneyCoordinatesTableTableCreateCompanionBuilder =
    JourneyCoordinatesTableCompanion Function({
      Value<int> id,
      required int journeyId,
      required double latitude,
      required double longitude,
    });
typedef $$JourneyCoordinatesTableTableUpdateCompanionBuilder =
    JourneyCoordinatesTableCompanion Function({
      Value<int> id,
      Value<int> journeyId,
      Value<double> latitude,
      Value<double> longitude,
    });

class $$JourneyCoordinatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $JourneyCoordinatesTableTable> {
  $$JourneyCoordinatesTableTableFilterComposer({
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

  ColumnFilters<int> get journeyId => $composableBuilder(
    column: $table.journeyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JourneyCoordinatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneyCoordinatesTableTable> {
  $$JourneyCoordinatesTableTableOrderingComposer({
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

  ColumnOrderings<int> get journeyId => $composableBuilder(
    column: $table.journeyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JourneyCoordinatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneyCoordinatesTableTable> {
  $$JourneyCoordinatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get journeyId =>
      $composableBuilder(column: $table.journeyId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$JourneyCoordinatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneyCoordinatesTableTable,
          JourneyCoordinates,
          $$JourneyCoordinatesTableTableFilterComposer,
          $$JourneyCoordinatesTableTableOrderingComposer,
          $$JourneyCoordinatesTableTableAnnotationComposer,
          $$JourneyCoordinatesTableTableCreateCompanionBuilder,
          $$JourneyCoordinatesTableTableUpdateCompanionBuilder,
          (
            JourneyCoordinates,
            BaseReferences<
              _$AppDatabase,
              $JourneyCoordinatesTableTable,
              JourneyCoordinates
            >,
          ),
          JourneyCoordinates,
          PrefetchHooks Function()
        > {
  $$JourneyCoordinatesTableTableTableManager(
    _$AppDatabase db,
    $JourneyCoordinatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneyCoordinatesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$JourneyCoordinatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JourneyCoordinatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> journeyId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
              }) => JourneyCoordinatesTableCompanion(
                id: id,
                journeyId: journeyId,
                latitude: latitude,
                longitude: longitude,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int journeyId,
                required double latitude,
                required double longitude,
              }) => JourneyCoordinatesTableCompanion.insert(
                id: id,
                journeyId: journeyId,
                latitude: latitude,
                longitude: longitude,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JourneyCoordinatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneyCoordinatesTableTable,
      JourneyCoordinates,
      $$JourneyCoordinatesTableTableFilterComposer,
      $$JourneyCoordinatesTableTableOrderingComposer,
      $$JourneyCoordinatesTableTableAnnotationComposer,
      $$JourneyCoordinatesTableTableCreateCompanionBuilder,
      $$JourneyCoordinatesTableTableUpdateCompanionBuilder,
      (
        JourneyCoordinates,
        BaseReferences<
          _$AppDatabase,
          $JourneyCoordinatesTableTable,
          JourneyCoordinates
        >,
      ),
      JourneyCoordinates,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JourneyTableTableTableManager get journeyTable =>
      $$JourneyTableTableTableManager(_db, _db.journeyTable);
  $$JourneyCoordinatesTableTableTableManager get journeyCoordinatesTable =>
      $$JourneyCoordinatesTableTableTableManager(
        _db,
        _db.journeyCoordinatesTable,
      );
}
