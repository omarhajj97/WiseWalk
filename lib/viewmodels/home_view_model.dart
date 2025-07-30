import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wise_walk/dataclasses/forecast.dart';
import 'package:wise_walk/dataclasses/hourly_forecast.dart';
import 'package:wise_walk/services/location_service.dart';
import 'package:wise_walk/services/weather_service.dart';

class HomeViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Forecast _currentForecast = Forecast(
    temperature: 0,
    location: "Unknown",
    weather: "Loading...",
    windSpeed: null,
    humidity: null,
    visibility: null,
    uvIndex: null,
    uvLevel: null,
    rain: null,
  );

  bool _showPermissionErrorDialog = false;
  bool get showPermissionErrorDialog => _showPermissionErrorDialog;

  List<HourlyForecast> _hourlyForecasts = [];
  List<HourlyForecast> get hourlyForecasts => _hourlyForecasts;

  Forecast get cuurentForecast => _currentForecast;
  String? errorMessage;

  Future<void> fetchForecast() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      _currentForecast = Forecast(
        temperature: 10,
        location: "Glasgow",
        weather: "Thunderstorm",
      );
    } catch (e) {
      errorMessage = "Failed to load forecast";
    }
    notifyListeners();
  }

  void updateTemperature(double temp) {
    _currentForecast = _currentForecast.copyWith(temperature: temp);
    notifyListeners();
  }

  void updateWeather(String weather) {
    _currentForecast = _currentForecast.copyWith(weather: weather);
    notifyListeners();
  }

  void updateLocation(String location) {
    _currentForecast = _currentForecast.copyWith(location: location);
    notifyListeners();
  }

  Future<bool> ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _showPermissionErrorDialog = true;
      notifyListeners();
      return false;
    }
    _showPermissionErrorDialog = false;
    return true;
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    try {
      await ensureLocationPermission();
      final position = await Geolocator.getCurrentPosition();
      final currentWeatherData = await _weatherService
          .fetchCurrentWeatherForecast(position.latitude, position.longitude);

      _hourlyForecasts = await _weatherService.getHourlyForecast(
        position.latitude,
        position.longitude,
      );

      _currentForecast = _currentForecast.copyWith(
        weather: currentWeatherData['condition'],
        temperature: currentWeatherData['temperature'],
        location: await LocationService.getCityName(
          position.latitude,
          position.longitude,
        ),
        windSpeed: currentWeatherData['wind'],
        humidity: currentWeatherData['humidity'],
        visibility: currentWeatherData['visibility'],
        uvIndex: currentWeatherData['uvIndex'],
        uvLevel: currentWeatherData['uvLevel'],
        rain: currentWeatherData['rain'],
      );
      notifyListeners();
    } catch (e) {
      print('Failed to fetch weather');
      _hourlyForecasts = [];
    }
  }

  Future<void> checkPermissionsBeforeFetchWeather() async {
    final grantedLocationPermission = await ensureLocationPermission();
    if (!grantedLocationPermission) {
      return;
    }
    await fetchWeatherForCurrentLocation();
  }

  Widget get weatherIcon {
    return _weatherService.getWeatherIcon(cuurentForecast.weather);
  }

  String getAlertIconPath(String type) {
    switch (type.toLowerCase()) {
      case 'road':
        return 'assets/icons/road-closed.png';
      case 'weather':
        return 'assets/icons/warning (2).png';
      case 'construction':
        return 'assets/icons/roadworks.png';
      case 'government':
        return 'assets/icons/alarm.png';
      default:
        return 'assets/icons/warning (2).png';
    }
  }
}
