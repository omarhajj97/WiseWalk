import 'package:wise_walk/formatters/distance_formatter.dart';
import 'package:wise_walk/formatters/duration_in_minutes.dart';
import 'package:wise_walk/formatters/month_day_formatter.dart';
import 'package:wise_walk/formatters/time_formatter.dart';

class Journey {

final int? id;
final DateTime dateWithTime;
final Duration duration;
final double distance;
final String? mode;
final int? steps;
final double? calories;

Journey(
  {
    this.id,
    required this.dateWithTime,
    required this.duration,
    required this.distance,
    this.mode,
    this.steps,
    this.calories
  }
);

factory Journey.fromDb({
  required int id,
  required DateTime dateWithTime,
  required int duration,
  required double distance,
  required String mode,
  required int steps,
  required double calories
}) {
  return Journey(
    id: id,
    dateWithTime: dateWithTime,
    duration: Duration(seconds: duration),
    distance: distance,
    mode: mode,
    steps: steps,
    calories: calories
  );
}

  int get durationInSeconds => duration.inSeconds;


  String get formattedDate => MonthDayFormatter.formatDate(dateWithTime);
  String get formattedTime => TimeFormatter.formatTime(dateWithTime);
  String get formattedDuration => DurationInMinutes.formatDuration(duration);
  String get formattedDistance => DistanceFormatter.formatDistance(distance);
}