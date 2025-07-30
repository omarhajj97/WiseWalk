import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng userLocation;
  final List<Marker> markers;
  final MapController mapController;
  final List<LatLng> routePoints;
  final double initialZoom;

  const MapWidget({
    super.key,
    required this.userLocation,
    required this.markers,
    required this.mapController,
    required this.routePoints,
    required this.initialZoom,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: userLocation,
            initialZoom: initialZoom,
            minZoom: 5,
            maxZoom: 18,
          ),
          children: [
            /*  TileLayer(
              urlTemplate: 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.wise_walk',
            ),*/
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.wisewalk',
            ),
            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            MarkerLayer(markers: markers),
          ],
        ),
      ],
    );
  }
}
