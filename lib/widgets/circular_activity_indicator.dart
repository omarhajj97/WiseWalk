import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class CircularActivityIndicator extends StatelessWidget{
  final String label;
  final int currentValue;
  final int goalValue;
  final Color color;

  const CircularActivityIndicator(
    {
      super.key, 
      required this.label, 
      required this.currentValue, 
      required this.goalValue, 
      required this.color,
      
    }
  );

  @override
  Widget build(BuildContext context) {
    double percent = currentValue/goalValue;
    percent = percent.clamp(0.0, 1.0);

    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 8.0,
      percent: percent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$currentValue / $goalValue",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
      progressColor: color,
      backgroundColor: Colors.grey.shade300,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
    );
  }
  
}