import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';
import 'package:wise_walk/widgets/mode_of_transport_picker.dart';

class ShowRouteButton extends StatelessWidget {
  final AlertsViewmodel alertsViewModel;

  const ShowRouteButton({super.key, required this.alertsViewModel});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(16),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  ),
      icon: const Icon(Icons.route),
      label: const Text("Show Route"),
      onPressed: () {
        final destination = alertsViewModel.pendingDestination!;
        showModeOfTransportPicker(
          context: context,
          alertsViewModel: alertsViewModel,
          destination: destination,
          onModeSelected: (mode,selectedRoute) {


            alertsViewModel.clearPendingDestination();
            if (selectedRoute != null) {
              final distanceKm = (selectedRoute.distanceKm).toStringAsFixed(2);
              final durationMin = (selectedRoute.minutesDuration)
                  .toStringAsFixed(0);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Distance: $distanceKm km - Time: $durationMin mins",
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
