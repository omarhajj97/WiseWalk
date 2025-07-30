import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/database_drift/journey_coordinates_table.dart';
import 'package:wise_walk/database_drift/journey_dao.dart';
import 'package:wise_walk/database_drift/route_coordinates_dao.dart';
import 'package:wise_walk/dataclasses/journey.dart';
import 'package:wise_walk/dataclasses/trackingData.dart';
import 'package:wise_walk/viewmodels/home_view_model.dart';
import 'package:wise_walk/viewmodels/past_journeys_view_model.dart';
import 'package:wise_walk/viewmodels/settings_view_model.dart';

class TrackingViewModel extends ChangeNotifier {
  final RouteCoordinatesDao _routeCoordinatesDao;
  final JourneyDao _journeyDao;
  final SettingsViewModel? _settingsViewModel;
  final HomeViewModel? _homeViewModel;
  TrackingViewModel(
    this._routeCoordinatesDao,
    this._journeyDao,
    this._settingsViewModel,
    this._homeViewModel,
  ) {
    _trackingData = TrackingData(
      distance: 0.0,
      duration: Duration.zero,
      weather: _homeViewModel?.cuurentForecast.weather ?? "Loading...",
      measure: _homeViewModel?.cuurentForecast.temperature ?? 0.0,
      mode: _mode,
      windSpeed: _homeViewModel?.cuurentForecast.windSpeed,
      humidity: _homeViewModel?.cuurentForecast.humidity,
      visibility: _homeViewModel?.cuurentForecast.visibility,
      uvIndex: _homeViewModel?.cuurentForecast.uvIndex,
      uvLevel: _homeViewModel?.cuurentForecast.uvLevel,
      rain: _homeViewModel?.cuurentForecast.rain,
    );
  }

  final List<JourneyCoordinates> _routePoints = [];
  late TrackingData _trackingData;
  TrackingData get trackingData => _trackingData;

  Timer? _timer;
  bool _isTracking = false;
  bool _isPaused = false;
  bool _isDisposed = false;

  bool get isTracking => _isTracking;
  bool get isPaused => _isPaused;

  DateTime? _timerStartTime;
  Duration _pauseDuration = Duration.zero;
  DateTime? _pauseStartTime;

  ActivityMode _mode = ActivityMode.walking;
  ActivityMode get mode => _mode;

  StreamSubscription<StepCount>? _stepSubscription;
  int _initialSteps = 0;

  StreamSubscription<Position>? _locationSubscription;

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _stepSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> startTracking() async {
    if (Platform.isAndroid) {
      final androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: "WiseWalk Tracking Active",
        notificationText: "Tracking your journey in the background",
        notificationImportance: AndroidNotificationImportance.normal,
        enableWifiLock: true,
      );

      bool hasPermissions = await FlutterBackground.initialize(
        androidConfig: androidConfig,
      );
      if (hasPermissions) {
        await FlutterBackground.enableBackgroundExecution();
      }
    }

    Position? lastPosition;

    _trackingData = TrackingData(
      distance: 0.0,
      duration: Duration.zero,
      weather: "Loading...",
      measure: 0,
      mode: _mode,
    );
    _isTracking = true;
    safeNotifyListeners();
    if (_mode == ActivityMode.walking) {
      try {
        _stepSubscription = Pedometer.stepCountStream.listen(
          (event) {
            if (_initialSteps == 0) {
              _initialSteps = event.steps;
            }
            final sessionSteps = event.steps - _initialSteps;
            _trackingData = _trackingData.copyWith(steps: sessionSteps);
            safeNotifyListeners();
          },
          onError: (error) {
            print("Pedometer error: $error");
          },
          cancelOnError: true,
        );
      } catch (e) {
        print("Failed to count steps");
      }
    }
    _timerStartTime = DateTime.now();
    _pauseDuration = Duration.zero;
    _pauseStartTime = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isPaused) return;
      /* _trackingData = _trackingData.copyWith(
          duration: _trackingData.duration + const Duration(seconds: 1),
        ); */

      final updatedDuration =
          DateTime.now().difference(_timerStartTime!) - _pauseDuration;
      _trackingData = _trackingData.copyWith(duration: updatedDuration);
      safeNotifyListeners();
    });

    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
          ),
        ).listen((position) {
          if (_isPaused || !_isTracking) return;

          double updatedDistance = _trackingData.distance;
          if (lastPosition != null) {
            final distanceMeters = Geolocator.distanceBetween(
              lastPosition!.latitude,
              lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );
            updatedDistance += distanceMeters / 1000;
            /*  _trackingData = _trackingData.copyWith(
            distance: _trackingData.distance + (distanceMeters / 1000),
          );*/
          }

          final updatedDuration =
              DateTime.now().difference(_timerStartTime!) -
              _pauseDuration; // _trackingData.duration + const Duration(seconds: 1);
          final durationHours = updatedDuration.inSeconds / 3600;
          final speedKmph =
              updatedDistance / (durationHours > 0 ? durationHours : 1);
          final double met = _mode == ActivityMode.walking
              ? getMetForWalking(speedKmph)
              : getMetForCycling(speedKmph);
          final double weightInKg =
              _settingsViewModel?.userSettings?.weight ?? 70.0;
          ;
          final double calories = updatedDistance > 0
              ? met * durationHours * weightInKg
              : 0.0;

          _routePoints.add(
            JourneyCoordinates(
              journeyId: 0,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );

          lastPosition = position;
          _trackingData = _trackingData.copyWith(
            duration: updatedDuration,
            distance: updatedDistance,
            calories: calories,
          );
          safeNotifyListeners();
        });
  }

  Future<void> stopTracking(BuildContext context) async {
    _isTracking = false;
    _timer?.cancel();
    _stepSubscription?.cancel();
    _locationSubscription?.cancel();
    _stepSubscription = null;
    if (await FlutterBackground.isBackgroundExecutionEnabled) {
      await FlutterBackground.disableBackgroundExecution();
    }
    safeNotifyListeners();

    final journey = Journey(
      duration: _trackingData.duration,
      distance: _trackingData.distance,
      dateWithTime: DateTime.now(),
      steps: _trackingData.steps,
      calories: _trackingData.calories,
      mode: _trackingData.mode.name,
    );

    final pastJourneysVM = Provider.of<PastJourneysViewModel>(
      context,
      listen: false,
    );
    await pastJourneysVM.addJourney(journey);

    final lastJourney = await _journeyDao.getLastJourneyByDate(
      journey.dateWithTime,
    );

    for (var coord in _routePoints) {
      await _routeCoordinatesDao.insertCoordinatePoint(
        lastJourney.id!,
        coord.latitude,
        coord.longitude,
      );
    }
    _routePoints.clear();
    _trackingData = _trackingData.copyWith(
      distance: 0.0,
      duration: Duration.zero,
      steps: 0,
      calories: 0.0,
    );

    resetState();
  }

  void pauseTracking() {
    _isPaused = true;
    _pauseStartTime = DateTime.now();
    safeNotifyListeners();
  }

  void resumeTracking() {
    _isPaused = false;
    if (_pauseStartTime != null) {
      _pauseDuration += DateTime.now().difference(_pauseStartTime!);
      _pauseStartTime = null;
    }
    safeNotifyListeners();
  }

  void togglePauseResume() {
    _isPaused = !_isPaused;
    safeNotifyListeners();
  }

  void setMode(ActivityMode newMode) {
    _mode = newMode;
    safeNotifyListeners();
  }

  double getMetForWalking(double speed) {
    if (speed < 3.2) return 2.0;
    if (speed < 4.0) return 2.5;
    if (speed < 4.8) return 3.3;
    if (speed < 5.6) return 3.8;
    if (speed < 6.4) return 5.0;
    if (speed < 7.0) return 6.5;
    return 8.0;
  }

  double getMetForCycling(double speed) {
    if (speed < 16.0) return 3.5;
    if (speed < 20.0) return 8.0;
    if (speed < 25.0) return 10.0;
    if (speed < 30.0) return 12.0;
    return 16.0;
  }
  void resetState() {
    _timer?.cancel();
    _timer = null;
    _timerStartTime = null;
    _isPaused = false;
    _isTracking = false;
    _initialSteps = 0;
    _routePoints.clear();
    _trackingData = TrackingData(
      distance: 0.0,
      duration: Duration.zero,
      weather: "Loading...",
      measure: 0,
      mode: _mode,
    );
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) notifyListeners();
  }
}
