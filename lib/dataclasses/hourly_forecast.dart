class HourlyForecast {
  final DateTime timeOfForecast;
  final double temperature;
  final int rainProbability;
  final String weatherIconPath;
  final String weatherCondition;

  HourlyForecast({
    required this.timeOfForecast, 
    required this.temperature, 
    required this.rainProbability, 
    required this.weatherIconPath, 
    required this.weatherCondition});

    factory HourlyForecast.fromJson(Map<String, dynamic> json){
      return HourlyForecast(
        timeOfForecast: DateTime.parse(json['time']), 
        temperature: (json['temp_c'] ?? 0.0).toDouble(), 
        rainProbability: json['chance_of_rain'] ?? 0, 
        weatherIconPath: "https:${json['condition']['icon']}", 
        weatherCondition: json['condition']['text'] ?? '');
    }

}