import 'package:drift/drift.dart';

@UseRowClass(JourneyCoordinates,constructor: 'fromDb')
class JourneyCoordinatesTable extends Table{
    IntColumn get id => integer().autoIncrement()();
    IntColumn get journeyId => integer()(); 
    RealColumn get latitude => real()();
    RealColumn get longitude => real()();
}

class JourneyCoordinates {
  final int? id;
  final int journeyId;
  final double latitude;
  final double longitude;
JourneyCoordinates(
  {
    this.id,
    required this.journeyId,
    required this.latitude,
    required this.longitude
  }
);

JourneyCoordinates copyWith({
  int? id,
  int? journeyId,
  double? latitude,
  double? longitude,
}) {
  return JourneyCoordinates(
    id: id ?? this.id,
    journeyId: journeyId ?? this.journeyId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );
}

factory JourneyCoordinates.fromDb({
  required int id,
  required int journeyId,
  required double latitude,
  required double longitude,
}) {
  return JourneyCoordinates(
    id: id,
    journeyId: journeyId,
    latitude: latitude,
    longitude: longitude,
  );
}

}