import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/dataclasses/trackingData.dart';
import 'package:wise_walk/formatters/distance_formatter.dart';
import 'package:wise_walk/formatters/duration_formatter.dart';
import 'package:wise_walk/viewmodels/home_view_model.dart';
import 'package:wise_walk/viewmodels/tracking_view_model.dart';
import 'package:wise_walk/widgets/activity_mode_dropdown.dart';
import 'package:wise_walk/widgets/weather_details_dialog.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trackingViewModel = context.watch<TrackingViewModel>();
    final homeViewModel = context.watch<HomeViewModel>();
    final hourlyForecast = homeViewModel.hourlyForecasts;
    final trackingData = trackingViewModel.trackingData;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: false,
              radius: const Radius.circular(6),
              thickness: 6,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Activity Mode",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActivityModeDropdown(
                        currentActivityMode: trackingViewModel.mode,
                        onChanged: (value) {
                          if (value != null) {
                            trackingViewModel.setMode(value);
                          }
                        },
                        onSelected: trackingViewModel.setMode,
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Elapsed Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        DurationFormatter.formattedDuration(
                          trackingData.duration,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        DistanceFormatter.formatDistance(trackingData.distance),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      if (trackingViewModel.mode == ActivityMode.walking) ...[
                        const Divider(height: 32),
                        const Text(
                          'Steps',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${trackingData.steps ?? 0}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                      const Divider(height: 32),
                      const Text(
                        'Calories Burned',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${trackingData.calories?.toStringAsFixed(1) ?? '0.0'} kcal',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          const Text(
                            'Weather',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 180),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => WeatherDetailsDialog(
                                  currentForecast: homeViewModel.cuurentForecast,
                                  hourlyForecast: hourlyForecast,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'More Details',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Icon(Icons.keyboard_arrow_right_sharp),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          (homeViewModel.weatherIcon),
                          const SizedBox(width: 10),
                          Text(
                            '${homeViewModel.cuurentForecast.weather} - ${homeViewModel.cuurentForecast.temperature.round()}°C',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!trackingViewModel.isTracking) ...[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => trackingViewModel.startTracking(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.play_arrow, size: 26),
                    SizedBox(width: 8),
                    Text('Start Tracking', style: TextStyle(fontSize: 22)),
                  ],
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: trackingViewModel.isPaused
                          ? Colors.blueAccent
                          : Colors.orangeAccent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (trackingViewModel.isPaused) {
                        trackingViewModel.resumeTracking();
                      } else {
                        trackingViewModel.pauseTracking();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          trackingViewModel.isPaused
                              ? Icons.play_arrow
                              : Icons.pause,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          trackingViewModel.isPaused ? 'Resume' : 'Pause',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      trackingViewModel.stopTracking(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Journey Saved Successfully!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.purpleAccent,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.stop, size: 26),
                        SizedBox(width: 8),
                        Text('Stop', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
