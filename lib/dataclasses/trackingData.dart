enum ActivityMode {walking,cycling}
class TrackingData {
  final double distance;
  final Duration duration;
  final String weather;
  final double measure;
  final int? steps;
  final double? calories;
  final double? windSpeed;
  final int? humidity;
  final int? visibility;
  final double? uvIndex;
  final String? uvLevel;
  final ActivityMode mode;
  final double? rain;

  TrackingData({
    required this.distance,
    required this.duration,
    required this.weather,
    required this.measure,
    this.steps = 0,
    this.calories= 0,
    this.windSpeed,
    this.humidity,
    this.visibility,
    this.uvIndex,
    this.uvLevel,
    this.mode = ActivityMode.walking,
    this.rain

  });

  TrackingData copyWith({
    double? distance,
    Duration? duration,
    String? weather,
    double? measure,
    int? steps,
    double? calories,
    double? windSpeed,
    int? humidity,
    int? visibility,
    double? uvIndex,
    String? uvLevel,
    ActivityMode? mode,
    double? rain
  }) {
    return TrackingData(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      weather: weather ?? this.weather,
      measure: measure ?? this.measure,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      windSpeed: windSpeed ?? this.windSpeed,
      humidity: humidity ?? this.humidity,
      visibility: visibility ?? this.visibility,
      uvIndex: uvIndex ?? this.uvIndex,
      uvLevel: uvLevel ?? this.uvLevel,
      mode: mode ?? this.mode,
      rain: rain ?? this.rain
    );
  }

}