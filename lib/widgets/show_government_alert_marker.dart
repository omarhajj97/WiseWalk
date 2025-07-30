import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker showGovernmentAlertMarker({
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
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 92,
          child: GestureDetector(
            onTap: onTap,
            child: Image.asset('assets/icons/alarm.png', width: 30, height: 30),
          ),
        ),
      ],
    ),
  );
}
