import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker showWeatherAndGovernmentAlertMarker({
  required LatLng location,
  required VoidCallback onWeatherTap,
  required VoidCallback onGovTap,
}) {
  return Marker(
    point: location,
    height: 120,
    width: 120,
    child: Stack(
      alignment: Alignment.center,
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
          )
        ),
        Positioned(
          top: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                GestureDetector(
                  onTap: onWeatherTap,
                  child: Image.asset(
                    'assets/icons/warning (2).png',
                    width: 30,
                    height: 30,
                  ),
                ),
              const SizedBox(width: 64),
                GestureDetector(
                  onTap: onGovTap,
                  child: Image.asset(
                    'assets/icons/alarm.png',
                    width: 30,
                    height: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
