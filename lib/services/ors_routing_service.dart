import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:wise_walk/dataclasses/route_details.dart';

class OrsRoutingService {
  final String _apiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImQ5M2NhM2E2ODk4NjQzZGM4YTZlODczMWE3NjBmNjZhIiwiaCI6Im11cm11cjY0In0=';

  Future<RouteDetails> getRoute(LatLng start, LatLng end, {String mode = 'foot-walking'}) async{
    final url = 'https://api.openrouteservice.org/v2/directions/$mode?api_key=$_apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'coordinates': [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude]
        ],
      }),
    );

  /*f (response.statusCode == 200) {

    final data = jsonDecode(response.body);
    final routes = data['routes'];
    if (routes == null || routes.isEmpty) {
      throw Exception('No routes found.');
    }

    

    final encodedPolyline = routes[0]['geometry'];
    if (encodedPolyline is! String) {
      throw Exception('Polyline not a string');
    }

    final decoded = PolylinePoints().decodePolyline(encodedPolyline);
    return decoded.map((p) => LatLng(p.latitude, p.longitude)).toList();
  } else {
    print('ORS Error: ${response.body}');
    throw Exception('Failed to get route');
  }
}*/
    if (response.statusCode != 200) {
      throw Exception('ORS error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    print(jsonEncode(data));
    final route = data['routes'][0];
    final encoded = route['geometry'] as String;

    final details = route['summary'];
    final distanceKm = (details['distance'] as num) / 1000.0;
    final durationMinutes = (details['duration'] as num) / 60.0;
    print('Distance: $distanceKm km');
    print('Duration: $durationMinutes mins');

    final routePoints = PolylinePoints()
        .decodePolyline(encoded)
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    return RouteDetails(routePoints,distanceKm , durationMinutes);
  }

}
