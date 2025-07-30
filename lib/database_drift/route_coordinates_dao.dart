import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:wise_walk/database_drift/app_database.dart';
import 'package:wise_walk/database_drift/journey_coordinates_table.dart';
import 'package:wise_walk/database_drift/journey_table.dart';

part 'route_coordinates_dao.g.dart';

@DriftAccessor(tables: [JourneyCoordinatesTable, JourneyTable])
class RouteCoordinatesDao extends DatabaseAccessor<AppDatabase>
    with _$RouteCoordinatesDaoMixin {
  RouteCoordinatesDao(super.db);

  Future<void> insertCoordinatePoint(int journeyId, double lat, double lng) {
    return into(journeyCoordinatesTable).insert(
      JourneyCoordinatesTableCompanion.insert(
        journeyId: journeyId,
        latitude: lat,
        longitude: lng,
      ),
    );
  }

  Future<List<LatLng>> getRouteForJourney(int journeyId) async {
    final rows =
        await (select(journeyCoordinatesTable)
              ..where((tbl) => tbl.journeyId.equals(journeyId))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.id)]))
            .get();

    return rows.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}
