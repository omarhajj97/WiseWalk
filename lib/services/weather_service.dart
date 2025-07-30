import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wise_walk/dataclasses/alert.dart';
import 'package:wise_walk/dataclasses/hourly_forecast.dart';

class WeatherService {
  final String _apiKey = 'f66aa750a1ac3735c465e7b23288a366';
  final String _weatherApiKey = '8e7433101459428c97201102250907';
  final String _baseUrl = 'https://api.openweathermap.org/data/3.0/onecall';

  Future<Map<String, dynamic>> fetchCurrentWeatherForecast(
    double lat,
    double lon,
  ) async {
    final endpointUrl = Uri.parse(
      "$_baseUrl?lat=$lat&lon=$lon&units=metric&appid=$_apiKey",
    );

    final response = await http.get(endpointUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final condition = data['current']['weather']?[0]?['main'] ?? "Unknown";
      final temperature = (data['current']['temp'] ?? 0).toDouble();
      final wind = (data['current']['wind_speed'] ?? 0).toDouble();
      final humidity = data['current']['humidity'] ?? 0;
      final visibility = data['current']['visibility'] ?? 0;
      final uvIndex = (data['current']['uvi'] ?? 0).toDouble();
      final uvLevel = _classifyUvIndex(uvIndex);
      final rain = (data['current']['rain']?['1h'] ?? 0.0).toDouble();

      return {
        'condition': condition,
        'temperature': temperature,
        'wind': wind,
        'humidity': humidity,
        'visibility': visibility,
        'uvIndex': uvIndex,
        'uvLevel': uvLevel,
        'rain': rain,
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
    final endpointUrl = Uri.parse(
      "$_baseUrl?lat=$lat&lon=$lon&units=metric&appid=$_apiKey",
    );

    final response = await http.get(endpointUrl);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String _classifyUvIndex(double uv) {
    //based on https://www.who.int/news-room/questions-and-answers/item/radiation-the-ultraviolet-(uv)-index
    if (uv < 3) return "Low";
    if (uv < 6) return "Moderate";
    if (uv < 8) return "High";
    if (uv < 11) return "Very High";
    return "Extreme";
  }

  Widget getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('cloud'))
      return Image.asset('assets/icons/cloudy.png', height: 40, width: 40);
    if (lower.contains('rain'))
      return Image.asset('assets/icons/rain.png', height: 40, width: 40);
    if (lower.contains('storm') || lower.contains('thunder'))
      return Image.asset(
        'assets/icons/thunderstorm.png',
        height: 40,
        width: 40,
      );
    if (lower.contains('sun') || lower.contains('clear'))
      return Image.asset('assets/icons/sun.png', height: 40, width: 40);
    if (lower.contains('snow'))
      return Image.asset('assets/icons/snowy.png', height: 40, width: 40);
    return Image.asset('assets/icons/cloudy.png', height: 40, width: 40);
  }

  Future<List<Alert>> getGovernmentAlerts(double lat, double lon) async {
    final endpointUrl = Uri.parse(
      'https://api.weatherapi.com/v1/alerts.json?key=$_weatherApiKey&q=$lat,$lon',
    );

    final response = await http.get(endpointUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final alerts = data['alerts']['alert'] as List<dynamic>?;

      if (alerts == null || alerts.isEmpty) return [];

      return alerts.map<Alert>((alert) {
        return Alert(
          type: 'government',
          title: alert['event'] ?? 'Government Alert',
          location: alert['areas'] ?? 'Unknown Area',
          latitude: lat,
          longitude: lon,
          description: alert['headline'] ?? 'No description provided.',
          startTime: alert['effective'] != null
              ? DateTime.tryParse(alert['effective'])
              : null,
          endTime: alert['expires'] != null
              ? DateTime.tryParse(alert['expires'])
              : null,
          instruction: alert['instruction']
        );
      }).toList();
    } else {
      throw Exception('Failed to get weather alerts.');
    }
  }

  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lon) async {
    final endpointUrl = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$_weatherApiKey&q=$lat,$lon&days=1&aqi=no&alerts=no',
    );

    final response = await http.get(endpointUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final forecastHours = data['forecast']['forecastday'][0]['hour'] as List;
      final currentTime = DateTime.now();
      final nextHour = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentTime.hour + 1,
      );

      return forecastHours
          .map((forecastData) => HourlyForecast.fromJson(forecastData))
          .where(
            (forecast) =>
                forecast.timeOfForecast.isAtSameMomentAs(nextHour) ||
                forecast.timeOfForecast.isAfter(nextHour),
          )
          .take(6)
          .toList();
    } else {
      throw Exception('Failed to fetch hourly weather forecast');
    }
  }
}
