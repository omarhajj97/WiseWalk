import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wise_walk/dataclasses/alert.dart';
import 'package:wise_walk/dataclasses/route_details.dart';
import 'package:wise_walk/services/location_service.dart';
import 'package:wise_walk/services/ors_routing_service.dart';
import 'package:wise_walk/services/tomtom_service.dart';
import 'package:wise_walk/services/weather_service.dart';
import 'package:wise_walk/viewmodels/settings_view_model.dart';

class AlertsViewmodel extends ChangeNotifier {
  final SettingsViewModel settingsViewModel;

  AlertsViewmodel({required this.settingsViewModel});

  final WeatherService _weatherService = WeatherService();
  final TomTomService _tomTomService = TomTomService();
  final OrsRoutingService _orsRoutingService = OrsRoutingService();

  final MapController mapController = MapController();

  List<Alert> _alerts = [];
  List<Alert> get alerts => _alerts;

  bool _isLoadingAlerts = false;
  bool get isLoadingAlerts => _isLoadingAlerts;

  List<Alert> _governmentAlerts = [];
  List<Alert> get governmentAlerts => _governmentAlerts;

  List<Alert> _roadAlerts = [];
  List<Alert> get roadAlerts => _roadAlerts;

  List<Alert> _weatherAlerts = [];
  List<Alert> get weatherAlerts => _weatherAlerts;

  List<Alert> _filteredAlerts = [];
  List<Alert> get filteredAlerts => _filteredAlerts;

  String? errorMessage;

  String _sortOption = 'Most Recent';
  String get sortOption => _sortOption;

  Set<String> _filterOptions = {'All Alerts'};
  Set<String> get filterOptions => _filterOptions;

  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;

  StreamSubscription<Position>? _positionStreamSubscription;

  bool showNotification = false;

  bool get hasUnreadAlerts => _alerts.isNotEmpty;

  String? _lastNotifiedAlertKey;

  bool _isDisposed = false;

  bool _dialogShown = false;
  bool get dialogShown => _dialogShown;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  Alert? _selectedAlert;
  Alert? get selectedAlert => _selectedAlert;

  Alert? get latestAlert => _alerts.isNotEmpty ? _alerts.first : null;
  int get alertCount => _alerts.length;

  final double _zoomLevel = 14;
  double get zoomLevel => _zoomLevel;

  List<LatLng> _routePoints = [];
  List<LatLng> get routePoints => _routePoints;

  LatLng? _searchMarker;
  LatLng? get searchMarker => _searchMarker;

  LatLng? _pendingDestination;
  LatLng? get pendingDestination => _pendingDestination;

  bool _fetchingRoute = false;
  bool get fetchingRoute => _fetchingRoute;

  LatLng? get userLocationMarker => _userLocation;

  List<Alert> _selectedWeatherAlerts = [];
  List<Alert> get selectedWeatherAlerts => _selectedWeatherAlerts;

  List<Alert> get markerAlerts => filteredMapAlerts
      .where((a) => a.type != 'weather' && a.type != 'government')
      .toList();

  double? _routeDistanceKm;
  double? get routeDistanceKm => _routeDistanceKm;

  double? _routeDurationMin;
  double? get routeDurationMin => _routeDurationMin;

  final Set<String> _selectedMapFilters = {
    'Road Disruptions',
    'Weather Alerts',
    'Emergency Alerts',
  };

  Set<String> get selectedMapFilters => _selectedMapFilters;

  final List<String> _mapFilterTypes = [
    'All Alerts',
    'Road Disruptions',
    'Weather Alerts',
    'Emergency Alerts',
  ];

  List<String> get mapFilterTypes => _mapFilterTypes;

  Future<void> fetchUserLocationAndNearbyAlerts() async {
    _isLoadingAlerts = true;
    safeNotifyListeners();
    try {
      final position = await getCurrentLocation();
      _userLocation = LatLng(position.latitude, position.longitude);
      _weatherAlerts.clear();
      _roadAlerts.clear();
      _governmentAlerts.clear();
      _alerts.clear();
      _filteredAlerts.clear();

      if (settingsViewModel.userSettings!.weatherAlertsEnabled) {
        final weatherData = await _weatherService.getWeatherData(
          position.latitude,
          position.longitude,
        );

        final rain = weatherData['current']['rain']?['1h'] ?? 0.0;
        final wind = weatherData['current']['wind_speed'] ?? 0.0;
        final visibility = weatherData['current']['visibility'] / 1000.0;
        final uvIndex = weatherData['current']['uvi'] ?? 0.0;
        final cityName = await LocationService.getCityName(
          position.latitude,
          position.longitude,
        );
        final rainThreshold = settingsViewModel.userSettings!.rainThreshold;
        final windThreshold = settingsViewModel.userSettings!.windThreshold;
        final visibilityThreshold =
            settingsViewModel.userSettings!.visibilityThreshold;
        final uvThreshold = settingsViewModel.userSettings!.uvThreshold;

        final List<Alert> newWeatherAlerts = [];
        if (rain >= rainThreshold) {
          final jsonAlerts = (weatherData['alerts'] ?? []);
          final List<Alert> parsedAlerts = jsonAlerts.map<Alert>((alertJson) {
            return Alert(
              type: 'weather',
              title: alertJson['event'] ?? 'Weather Alert',
              location: 'Weather Alert Area',
              latitude: position.latitude,
              longitude: position.longitude,
              description: alertJson['description'],
              startTime: DateTime.now(),
            );
          }).toList();
          newWeatherAlerts.addAll(parsedAlerts);
        }

        if (wind >= windThreshold) {
          newWeatherAlerts.add(
            Alert(
              type: 'weather',
              title: 'High Wind Speed',
              location: cityName,
              latitude: position.latitude,
              longitude: position.longitude,
              description:
                  'Wind speed is ${wind.toStringAsFixed(1)} m/s. Be cautious when walking or cycling.',
              startTime: DateTime.now(),
            ),
          );
        }

        if (visibility <= visibilityThreshold) {
          newWeatherAlerts.add(
            Alert(
              type: 'weather',
              title: 'Low Visibility',
              location: cityName,
              latitude: position.latitude,
              longitude: position.longitude,
              description:
                  'Visibility is low (${visibility.toStringAsFixed(1)} km). Consider delaying your commute.',
              startTime: DateTime.now(),
            ),
          );
        }

        if (uvIndex >= uvThreshold) {
          newWeatherAlerts.add(
            Alert(
              type: 'weather',
              title: 'High UV Index',
              location: cityName,
              latitude: position.latitude,
              longitude: position.longitude,
              description:
                  'UV index is $uvIndex. Use sun protection and stay hydrated.',
              startTime: DateTime.now(),
            ),
          );
        }

        if (rain >= rainThreshold) {
          newWeatherAlerts.add(
            Alert(
              type: 'weather',
              title: 'Heavy Rain',
              location: cityName,
              latitude: position.latitude,
              longitude: position.longitude,
              description:
                  'Rainfall is ${rain.toStringAsFixed(1)} mm. Consider taking precautions.',
              startTime: DateTime.now(),
            ),
          );
        }
        _weatherAlerts = newWeatherAlerts;
      }

      if (settingsViewModel.userSettings!.roadAlertsEnabled) {
        _roadAlerts = await _tomTomService.fetchNearbyDisruptions(
          latitude: position.latitude,
          longitude: position.longitude,
          radiusInKm: settingsViewModel.userSettings!.roadAlertsRadius,
        );
      }

      _governmentAlerts = await _weatherService.getGovernmentAlerts(
        position.latitude,
        position.longitude,
      );

      _alerts = [..._weatherAlerts, ..._roadAlerts, ..._governmentAlerts];
      _sortAndFilterAlerts();
      if (_triggerAlert(alerts)) {
        showNotification = true;
        safeNotifyListeners();
      }
      safeNotifyListeners();
    } catch (e) {
      print('Error getting location or alerts');
    } finally{
      _isLoadingAlerts = false;
      safeNotifyListeners();
    }
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

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  int _getSeverityScore(String title) {
    if (title.toLowerCase().contains('extreme') ||
        title.toLowerCase().contains('closed'))
      return 3;
    if (title.toLowerCase().contains('high') ||
        title.toLowerCase().contains('disruption'))
      return 2;
    return 1;
  }

  double _distanceFromUser(Alert alert) {
    if (_userLocation == null) return double.infinity;
    return Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      alert.latitude,
      alert.longitude,
    );
  }

  void _sortAndFilterAlerts() {
    List<Alert> updated = [
      if (_filterOptions.contains("Weather Alerts Only") ||
          _filterOptions.contains("All Alerts"))
        ..._weatherAlerts,
      if (_filterOptions.contains("Emergency Alerts Only") ||
          _filterOptions.contains("All Alerts"))
        ..._governmentAlerts,
      if (_filterOptions.contains('Road Disruptions Only') ||
          _filterOptions.contains('All Alerts'))
        ..._roadAlerts,
    ];

    if (_userLocation != null) {
      if (_filterOptions.contains('Alerts Within 2km')) {
        updated = updated.where((a) => _distanceFromUser(a) <= 2000).toList();
      } else if (_filterOptions.contains('Alerts Within 5km')) {
        updated = updated.where((a) => _distanceFromUser(a) <= 5000).toList();
      }
    }

    updated.sort((a, b) {
      switch (_sortOption) {
        case 'Most Recent':
          return (b.startTime ?? DateTime.now()).compareTo(
            a.startTime ?? DateTime.now(),
          );
        case 'Least Recent':
          return (a.startTime ?? DateTime.now()).compareTo(
            b.startTime ?? DateTime.now(),
          );
        case 'Highest Severity':
          return _getSeverityScore(
            b.title,
          ).compareTo(_getSeverityScore(a.title));
        case 'Lowest Severity':
          return _getSeverityScore(
            a.title,
          ).compareTo(_getSeverityScore(b.title));
        case 'Nearest to Me':
          return _distanceFromUser(a).compareTo(_distanceFromUser(b));
        case 'Farthest from Me':
          return _distanceFromUser(b).compareTo(_distanceFromUser(a));
        default:
          return 0;
      }
    });

    _filteredAlerts = updated;
    safeNotifyListeners();
  }

  void updateSortOption(String newOption) {
    _sortOption = newOption;
    _sortAndFilterAlerts();
    safeNotifyListeners();
  }

  void updateFilterOptions(Set<String> newFilter) {
    if (newFilter.contains("All Alerts")) {
      _filterOptions
        ..clear()
        ..addAll({
          "All Alerts",
          "Weather Alerts Only",
          "Road Disruptions Only",
          "Emergency Alerts Only",
        });
    } else {
      _filterOptions
        ..clear()
        ..addAll(newFilter);
    }
    if (_filterOptions.containsAll({
      "All Alerts",
      "Weather Alerts Only",
      "Road Disruptions Only",
      "Emergency Alerts Only",
    })) {
      _filterOptions.add("All Alerts");
    }
    _sortAndFilterAlerts();
    safeNotifyListeners();
  }

  void dismissDialog() {
    _selectedAlert = null;
    _selectedWeatherAlerts = [];
    _dialogShown = false;
    safeNotifyListeners();
  }

  void incrementZoom() {
    final newZoom = mapController.camera.zoom + 0.5;
    mapController.move(mapController.camera.center, newZoom);
  }

  void decrementZoom() {
    final newZoom = mapController.camera.zoom - 0.5;
    mapController.move(mapController.camera.center, newZoom);
  }

  void recenterMapToUserLocation() {
    if (_userLocation != null) {
      mapController.move(_userLocation!, zoomLevel);
      safeNotifyListeners();
    }
  }

  void selectAlert(Alert alert) {
    _selectedAlert = alert;
    _dialogShown = true;
    safeNotifyListeners();
  }

  void trackCurrentLocation() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position position) {
          _userLocation = LatLng(position.latitude, position.longitude);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController.move(_userLocation!, zoomLevel);
          });
          _sortAndFilterAlerts();

          safeNotifyListeners();
        });
  }

  void stopTrackingCurrentLocation() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  void safeNotifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopTrackingCurrentLocation();
    super.dispose();
  }

  bool _triggerAlert(List<Alert> alerts) {
    const alertTypes = ['road', 'weather'];
    for (final alert in alerts) {
      if (alertTypes.contains(alert.type)) {
        final key = _generateAlertKey(alert);

        if (_lastNotifiedAlertKey != key) {
          _lastNotifiedAlertKey = key;
          return true;
        }
      }
    }
    return false;
  }

  void markNotificationHandled() {
    showNotification = false;
  }

  String _generateAlertKey(Alert alert) {
    return '${alert.title}_${alert.location}_${alert.startTime?.toIso8601String() ?? ''}';
  }

  Future<RouteDetails?> fetchRouteToDestination(
    LatLng destination, {
    String mode = 'foot-walking',
  }) async {
    if (_userLocation == null) return null;

    try {
      _fetchingRoute = true;
      safeNotifyListeners();

      final routeDetails = await _orsRoutingService.getRoute(
        _userLocation!,
        destination,
        mode: mode,
      );

      _routePoints = routeDetails.routePoints;

      _fetchingRoute = false;
      safeNotifyListeners();

      return routeDetails;
    } catch (e) {
      print('Failed to fetch route: $e');
      return null;
    }
  }

  void clearRoute() {
    _routePoints = [];
    safeNotifyListeners();
  }

  Future<void> searchLocation(String query) async {
    try {
      final result = await _tomTomService.searchLocation(query);
      if (result != null) {
        setPendingDestination(result);
        mapController.move(result, zoomLevel);
        safeNotifyListeners();
      }
    } catch (e) {
      print('Search failed: $e');
    }
  }

  void setPendingDestination(LatLng destination) {
    _pendingDestination = destination;
    mapController.move(destination, mapController.camera.zoom);
    notifyListeners();
  }

  void clearPendingDestination() {
    _pendingDestination = null;
    notifyListeners();
  }

  void selectWeatherAlerts() {
    _selectedWeatherAlerts = weatherAlerts;
    _dialogShown = true;
    notifyListeners();
  }

  Future<Map<String, RouteDetails?>> fetchAllRoutes(LatLng destination) async {
    final walking = await fetchRouteToDestination(
      destination,
      mode: "foot-walking",
    );
    final cycling = await fetchRouteToDestination(
      destination,
      mode: "cycling-regular",
    );

    return {"foot-walking": walking, "cycling-regular": cycling};
  }

  String showRouteInfo(RouteDetails? route) {
    if (route == null) return "Unavailable";
    return "Distance: ${route.distanceKm.toStringAsFixed(2)} km – Time: ${route.minutesDuration.toStringAsFixed(0)} mins";
  }

  Color getAlertCardBorderColor(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'weather':
        return Colors.amber;
      case 'government':
        return Colors.redAccent;
      case 'road':
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  void updateMapFilters(String type, bool? isSelected) {
    if (type == "All Alerts") {
      if (isSelected == true) {
        _selectedMapFilters
          ..clear()
          ..addAll(_mapFilterTypes);
      } else {
        _selectedMapFilters.clear();
      }
    } else {
      if (isSelected == true) {
        _selectedMapFilters.add(type);
      } else {
        _selectedMapFilters.remove(type);
      }

      final allAlertTypesSelected = _mapFilterTypes
          .where((filterType) => filterType != "All Alerts")
          .every((filterType) => _selectedMapFilters.contains(filterType));
      if (allAlertTypesSelected) {
        _selectedMapFilters.add('All Alerts');
      } else {
        _selectedMapFilters.remove('All Alerts');
      }
    }
    notifyListeners();
  }

  List<Alert> get filteredMapAlerts {
    if (selectedMapFilters.contains('All Alerts')) {
      return _alerts;
    }
    return _alerts.where((alert) {
      final type = alert.type.toLowerCase();
      return (_selectedMapFilters.contains('Road Disruptions') &&
              type == ('road')) ||
          (_selectedMapFilters.contains('Weather Alerts') &&
              type == ('weather')) ||
          (_selectedMapFilters.contains('Emergency Alerts') &&
              type == ('government'));
    }).toList();
  }

  List<Alert> get filteredWeatherAlerts =>
      _selectedMapFilters.contains('Weather Alerts') ? weatherAlerts : [];

  List<Alert> get filteredGovernmentAlerts =>
      _selectedMapFilters.contains('Emergency Alerts') ? governmentAlerts : [];

  void setAlerts(List<Alert> newAlerts) {
    _alerts
      ..clear()
      ..addAll(newAlerts);
    notifyListeners();
  }
}
