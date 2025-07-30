import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartNewJourneyButton extends StatelessWidget {
  final bool isTracking;

  const StartNewJourneyButton({
    super.key,
    required this.isTracking,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed:() => context.push('/tracking'),
      backgroundColor: isTracking
          ? Colors.orange
          : Colors.lightGreenAccent,
      icon: Icon(
        isTracking ? Icons.navigation : Icons.directions_walk,
        color: Colors.black,
      ),
      label: Text(
        isTracking ? "View Current Journey" : "Start New Journey",
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
