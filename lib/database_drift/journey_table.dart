import 'package:drift/drift.dart';
import 'package:wise_walk/dataclasses/journey.dart';

@UseRowClass(Journey,constructor: 'fromDb')
class JourneyTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dateWithTime => dateTime()();
  IntColumn get duration => integer()(); 
  RealColumn get distance => real()();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  RealColumn get calories => real().withDefault(const Constant(0))();
  TextColumn get mode => text().withDefault(const Constant('walking'))();

}
