import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:wise_walk/dataclasses/alert.dart';

class TomTomService {
  final String apiKey = 'RKZHXJCUapkYbOZQE8drYVPjXMmez4T1';
  final Map<String, String> _reverseGeocodeCache = {};

  
  Future<List<Alert>> fetchNearbyDisruptions({
    required double latitude,
    required double longitude,
    required double radiusInKm
  }) async {
    try {
      final double delta = radiusInKm / 111.0; 
      final double minLat = latitude - delta;
      final double maxLat = latitude + delta;
      final double minLon = longitude - delta;
      final double maxLon = longitude + delta;
      final String bbox = '$minLon,$minLat,$maxLon,$maxLat';
  
      final url = 'https://api.tomtom.com/traffic/services/5/incidentDetails'
          '?bbox=$bbox'
          '&language=en-GB'
          '&category=roadClosure,construction'
          '&key=$apiKey';


      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        print('TomTom URL: $url');

        throw Exception('Failed to fetch TomTom incidents');
      }

      final data = jsonDecode(response.body);
      final List incidents = data['incidents'] ?? [];

      final List<Alert> alerts = [];

    for (var incident in incidents) {
      final props = incident['properties'];
      final geometry = incident['geometry'];
      final coords = geometry?['coordinates']?[0];
      final iconCategory = props?['iconCategory'];

      const iconCategories = {7, 8, 9, 11};

  if (!iconCategories.contains(iconCategory)) continue;

  if (coords is List && coords.length >= 2) {
    final lon = coords[0];
    final lat = coords[1];
    final key = '$lat,$lon';
    final streetName = _reverseGeocodeCache.containsKey(key)
        ? _reverseGeocodeCache[key]!
        : await reverseGeocode(lat, lon);
    _reverseGeocodeCache[key] = streetName; 

    final String? start = props?['startTime'];
    final String? end = props?['endTime'];
    //final String? description = props?['description'];


    alerts.add(Alert(
      type: 'road',
      title: 'Pedestrian Disruption',
      location: streetName,
      latitude: lat,
      longitude: lon,
      startTime: start != null ? DateTime.tryParse(start) : null,
      endTime: end != null ? DateTime.tryParse(end) : null,
      description: 'Pedestrian disruption on $streetName'
    ));
  }
}

      return alerts;
      
    } catch (e) {
      print('TomTom fetch error: $e');
      return [];
    }
  }

  String getCategoryDescription(int code) {
  switch (code) {
    case 6:
      return 'Roadworks';
    case 7:
      return 'Road Closure';
    case 8:
      return 'Lane Restriction';
    case 9:
      return 'Traffic Congestion';
    default:
      return 'Disruption';
  }
}

Future<String> reverseGeocode(double lat, double lon) async {
  final key = '${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}';

  if (_reverseGeocodeCache.containsKey(key)) {
    return _reverseGeocodeCache[key]!;
  }

  final url = 'https://api.tomtom.com/search/2/reverseGeocode/$lat,$lon.json'
      '?key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final addresses = data['addresses'] as List;

      if (addresses.isNotEmpty) {
        final address = addresses[0]['address'];
        final street = address['streetName'] ?? '';
        final municipality = address['municipality'] ?? '';
        final freeform = address['freeformAddress'];

        final result = (freeform ?? '$street, $municipality').trim().isNotEmpty
            ? (freeform ?? '$street, $municipality')
            : 'Unnamed road';

        _reverseGeocodeCache[key] = result;
        return result;
      }
    }
  } catch (e) {
    print('Reverse geocoding failed: $e');
  }

  _reverseGeocodeCache[key] = 'Unnamed road';
  return 'Unnamed road';
}

Future<LatLng?> searchLocation(String query) async {
  final url = 'https://api.tomtom.com/search/2/geocode/$query.json'
      '?key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'] as List?;
    if (results != null && results.isNotEmpty) {
      final position = results[0]['position'];
      final lat = position['lat'];
      final lon = position['lon'];
      return LatLng(lat, lon);
    }
  }

  return null;
}
}
