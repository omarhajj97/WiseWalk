import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker showWeatherAlertMarker({
  required LatLng userCurrentLocation,
  required VoidCallback onTap,
}) {
  return Marker(
    point: userCurrentLocation,
    width: 120,
    height: 120,
    child: Stack(
      children: [
        IgnorePointer(
          child: Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 92,
          child: GestureDetector(
            onTap: onTap,
            child: Image.asset(
              'assets/icons/warning (2).png',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    ),
  );
}
