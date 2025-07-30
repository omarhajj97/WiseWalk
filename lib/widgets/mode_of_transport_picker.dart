import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wise_walk/dataclasses/route_details.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';

typedef ModeAndRouteSelectedCallback = void Function(String mode, RouteDetails? route);

void showModeOfTransportPicker({
  required BuildContext context,
  required AlertsViewmodel alertsViewModel,
  required LatLng destination,
  required ModeAndRouteSelectedCallback onModeSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FutureBuilder<Map<String, RouteDetails?>>(
        future: alertsViewModel.fetchAllRoutes(destination),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Fetching route options..."),
                  ],
                ),
              ),
            );
          }

          final routes = snapshot.data!;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "How would you like to commute?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_walk),
            title: const Text("Walk"),
            subtitle: Text(alertsViewModel.showRouteInfo(routes["foot-walking"])),
            onTap: () {
              Navigator.pop(context);
              onModeSelected("foot-walking",routes["foot-walking"]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_bike),
            title: const Text("Cycle"),
            subtitle: Text(alertsViewModel.showRouteInfo(routes["cycling-regular"])),
            onTap: () {
              Navigator.pop(context);
              onModeSelected("cycling-regular",routes["foot-walking"]);
            },
              ),
            ],
          );
        },
      );
    },
  );
}