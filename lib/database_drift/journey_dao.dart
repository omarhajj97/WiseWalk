import 'package:drift/drift.dart';
import 'package:wise_walk/database_drift/app_database.dart';
import 'package:wise_walk/database_drift/journey_table.dart';
import 'package:wise_walk/dataclasses/journey.dart';

part 'journey_dao.g.dart';

@DriftAccessor(tables: [JourneyTable])
class JourneyDao extends DatabaseAccessor<AppDatabase> with _$JourneyDaoMixin {
  JourneyDao(super.db);

  Future<void> insertJourney(Journey journey) {
    return into(journeyTable).insert(
      JourneyTableCompanion.insert(
        dateWithTime: journey.dateWithTime,
        duration: journey.duration.inSeconds,
        distance: journey.distance,
        steps: journey.steps != null
            ? Value(journey.steps!)
            : const Value.absent(),
        calories: journey.calories != null
            ? Value(journey.calories!)
            : const Value.absent(),
        mode: journey.mode != null
            ? Value(journey.mode!)
            : const Value.absent(),
      ),
    );
  }

  Future<List<Journey>> getAllJourneys() async {
    final rows = await select(journeyTable).get();
    return rows
        .map(
          (row) => Journey(
            id: row.id,
            dateWithTime: row.dateWithTime,
            duration: Duration(seconds: row.duration.inSeconds),
            distance: row.distance,
            steps: row.steps,
            calories: row.calories,
            mode: row.mode,
          ),
        )
        .toList();
  }

  Future<List<Journey>> sortJourneysBy(String sortOption) async {
    final selectQuery = select(journeyTable);

    switch (sortOption) {
      case 'Date(Newest First)':
        selectQuery.orderBy([
          (tbl) => OrderingTerm(
            expression: tbl.dateWithTime,
            mode: OrderingMode.desc,
          ),
        ]);
        break;
      case 'Date(Oldest First)':
        selectQuery.orderBy([
          (tbl) => OrderingTerm(
            expression: tbl.dateWithTime,
            mode: OrderingMode.asc,
          ),
        ]);
        break;

      case 'Duration(Longest First)':
        selectQuery.orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.duration, mode: OrderingMode.desc),
        ]);
        break;

      case 'Duration(Shortest First)':
        selectQuery.orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.duration, mode: OrderingMode.asc),
        ]);
        break;

      case 'Distance(Longest First)':
        selectQuery.orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.distance, mode: OrderingMode.desc),
        ]);
        break;

      case 'Distance(Shortest First)':
        selectQuery.orderBy([
          (tbl) =>
              OrderingTerm(expression: tbl.distance, mode: OrderingMode.asc),
        ]);
        break;
      default:
        selectQuery.orderBy([
          (tbl) => OrderingTerm(
            expression: tbl.dateWithTime,
            mode: OrderingMode.desc,
          ),
        ]);
    }
    return (await selectQuery.get()).map((journey) => Journey(
            id: journey.id,
            dateWithTime: journey.dateWithTime,
            duration: journey.duration,
            distance: journey.distance,
            steps: journey.steps,
            calories: journey.calories,
            mode: journey.mode,
          ))
      .toList();

  }

  Future<void> deleteJourneyById(int id) {
    return (delete(journeyTable)..where((tbl) => tbl.id.equals(id))).go();
  }

    Future<Journey> getLastJourneyByDate(DateTime date) async {
    return (select(journeyTable)
      ..where((tbl) => tbl.dateWithTime.equals(date)))
      .getSingle();
  } 
}
