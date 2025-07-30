import 'package:flutter/material.dart';
import 'package:wise_walk/dataclasses/alert.dart';

class RoadAlertMarker extends StatelessWidget{

final Alert alert;
final VoidCallback onTap;

const RoadAlertMarker({
  super.key,
  required this.alert,
  required this.onTap
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/icons/road-closed.png',
            height: 40,
            width: 40,
          )
        ],
      ),
    );
  }

}