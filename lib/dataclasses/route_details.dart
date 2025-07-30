import 'package:latlong2/latlong.dart';

class RouteDetails{
    final List<LatLng> routePoints;
    final double distanceKm;
    final double minutesDuration;

    RouteDetails(
      this.routePoints, 
      this.distanceKm, 
      this.minutesDuration);


}