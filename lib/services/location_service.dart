import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

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
static Future<String> getCityName(double latitude, double longitude) async {
  try {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final city = placemark.locality;
      final subArea = placemark.subAdministrativeArea;
      final admin = placemark.administrativeArea;

      final resolvedCity = (city != null && city.isNotEmpty)
          ? city
          : (subArea != null && subArea.isNotEmpty)
              ? subArea
              : (admin != null && admin.isNotEmpty)
                  ? admin
                  : "Unknown";

      print("Resolved city name: $resolvedCity");
      return resolvedCity;
    }
  } catch (e) {
    print("Reverse geocoding error: $e");
  }

  return "Unknown";
}


}
