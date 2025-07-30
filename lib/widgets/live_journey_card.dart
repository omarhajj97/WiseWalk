import 'package:flutter/material.dart';
import 'package:wise_walk/formatters/duration_formatter.dart';
import 'package:wise_walk/viewmodels/tracking_view_model.dart';

Widget liveJourneyCard(BuildContext context, TrackingViewModel trackingViewModel){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: const [
          Icon(Icons.directions_walk, size: 30),
          SizedBox(width: 6),
          Text(
            "Live Journey",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey,width:2),
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_walk, color: Colors.deepOrange),
                const SizedBox(width: 6),
                Text(
                  "Tracking in progress - ${DurationFormatter.formattedDuration(trackingViewModel.trackingData.duration)}",
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      trackingViewModel.isPaused ? Icons.play_arrow : Icons.pause,
                    ),
                    label: Text(
                      trackingViewModel.isPaused ? "Resume" : "Pause",
                    ),
                    onPressed: trackingViewModel.togglePauseResume,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade200,
                      foregroundColor: Colors.black87
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                    onPressed: () => trackingViewModel.stopTracking(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade200,
                      foregroundColor: Colors.black87
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}