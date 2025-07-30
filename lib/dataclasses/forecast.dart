import 'package:wise_walk/dataclasses/trackingData.dart';

class Forecast {
  double temperature;
  String location;
  String weather;
  double? windSpeed;
  int? humidity;
  int? visibility;
  double? uvIndex;
  String? uvLevel;
  ActivityMode? mode;
  double? rain;

  Forecast({
    required this.temperature,
    required this.location,
    required this.weather,
    this.windSpeed,
    this.humidity,
    this.visibility,
    this.uvIndex,
    this.uvLevel,
    this.mode,
    this.rain,
  });

  Forecast copyWith({
    double? temperature,
    String? location,
    String? weather,
    double? windSpeed,
    int? humidity,
    int? visibility,
    double? uvIndex,
    String? uvLevel,
    ActivityMode? mode,
    double? rain,
  }) {
    return Forecast(
      temperature: temperature ?? this.temperature,
      location: location ?? this.location,
      weather: weather ?? this.weather,
      windSpeed: windSpeed ?? this.windSpeed,
      humidity: humidity ?? this.humidity,
      visibility: visibility ?? this.visibility,
      uvIndex: uvIndex ?? this.uvIndex,
      uvLevel: uvLevel ?? this.uvLevel,
      rain: rain ?? this.rain,
    );
  }
}
