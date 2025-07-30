import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wise_walk/database_drift/route_coordinates_dao.dart';
import 'package:wise_walk/dataclasses/journey.dart';
import 'package:flutter/foundation.dart';

class JourneyDetailsViewModel extends ChangeNotifier{
  
  final Journey journey;
  final RouteCoordinatesDao _routeCoordinatesDao;
  final mapController = MapController();

   JourneyDetailsViewModel({
      required this.journey,
      required RouteCoordinatesDao routeCoordinatesDao,
    }) : _routeCoordinatesDao = routeCoordinatesDao;
  


  List<LatLng> routePoints = [];
  List<LatLng> get route => routePoints;

  double _initialZoom = 13.0;
  double get initialZoom => _initialZoom;

  String get duration{
    final mins = journey.duration.inMinutes;
    return "$mins min";
  }

  Future<void> loadRoutePoints(int journeyId) async {
  routePoints = await _routeCoordinatesDao.getRouteForJourney(journeyId);
  _initialZoom = getInitialZoom(journey.distance);
  notifyListeners();
}

double getInitialZoom(double kmDistanceBetweenPoints){
  if (kmDistanceBetweenPoints < 0.2) return 18.0;
  if (kmDistanceBetweenPoints < 0.5) return 16.0;
  if (kmDistanceBetweenPoints < 1.0) return 15.0;
  return 13.0;
}
}