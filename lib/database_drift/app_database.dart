
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:wise_walk/database_drift/journey_coordinates_table.dart';
import 'package:wise_walk/database_drift/journey_dao.dart';
import 'package:wise_walk/database_drift/journey_table.dart';
import 'package:wise_walk/database_drift/route_coordinates_dao.dart';
import 'package:wise_walk/dataclasses/journey.dart';

part 'app_database.g.dart';
@DriftDatabase(tables: [JourneyTable, JourneyCoordinatesTable])
class AppDatabase extends _$AppDatabase{
    static AppDatabase? _instance;
    late final journeyDao = JourneyDao(this);
    late final routeCoordinatesDao = RouteCoordinatesDao(this);


    static Future<AppDatabase> instance() async {
    _instance ??= AppDatabase();
    return _instance!;
  }

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 9; //add +1 to version if changes made to db

 @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
         if (from < 9)  //change to from < *latest version*
         {   await m.addColumn(journeyTable, journeyTable.steps as GeneratedColumn<Object>);
await m.addColumn(journeyTable, journeyTable.calories as GeneratedColumn<Object>);
await m.addColumn(journeyTable, journeyTable.mode as GeneratedColumn<Object>); }  //use m.createTable(#tablename) in the condition if u are adding table
      },
      beforeOpen: (details) async {
         if (kDebugMode) {
              debugPrint("Database opened in debug mode");
        }
      },
    );
  }

}
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}