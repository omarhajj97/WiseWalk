import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/dataclasses/journey.dart';
import 'package:wise_walk/viewmodels/journey_details_view_model.dart';
import 'package:wise_walk/widgets/map_widget.dart';

class JourneyDetailsScreen extends StatefulWidget {
  final Journey journey;
  const JourneyDetailsScreen({
    super.key,
    required this.journey
  });

   @override
   State<JourneyDetailsScreen> createState() => _JourneyDetailsScreenState();
  }

  class _JourneyDetailsScreenState extends State<JourneyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final journeyDetailsViewModel = context.read<JourneyDetailsViewModel>();
    journeyDetailsViewModel.loadRoutePoints(widget.journey.id!);
  }

  @override
  Widget build(BuildContext context) {
    final journeyDetailsViewModel = context.watch<JourneyDetailsViewModel>();
    final modeStr = journeyDetailsViewModel.journey.mode ?? '';


    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text('Activity Mode', style: TextStyle(fontSize: 18)),
            Text(modeStr.contains('cycling') ? '🚴 Cycling' : '🚶 Walking', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(height: 32),

            const Text('Duration', style: TextStyle(fontSize: 18)),
            Text(journeyDetailsViewModel.journey.formattedDuration, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(height: 32),

            const Text('Distance', style: TextStyle(fontSize: 18)),
            Text(journeyDetailsViewModel.journey.formattedDistance, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(height: 32),

            if(journeyDetailsViewModel.journey.mode == 'walking')...[
            const Text('Steps', style: TextStyle(fontSize: 18)),
            Text('${journeyDetailsViewModel.journey.steps ?? 0}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            ],

            const Text('Calories Burned', style: TextStyle(fontSize: 18)),
            Text('${journeyDetailsViewModel.journey.calories?.toStringAsFixed(2) ?? 0}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(height: 32),


            const Text('Route', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
           if (journeyDetailsViewModel.route.isNotEmpty)
            SizedBox(
              height: 200,
              child: MapWidget(
                      userLocation: journeyDetailsViewModel.route.first,
                      markers: [
                          Marker(
                            point: journeyDetailsViewModel.route.first,
                            width: 30,
                            height: 30,
                            child: const Icon(Icons.location_on, color: Colors.green),
                          ),
                          Marker(
                            point: journeyDetailsViewModel.route.last,
                            width: 30,
                            height: 30,
                            child: const Icon(Icons.location_on, color: Colors.red),
                          ),
                      ],
                      mapController: journeyDetailsViewModel.mapController,
                      routePoints: journeyDetailsViewModel.routePoints,
                      initialZoom: journeyDetailsViewModel.initialZoom
                    ),
                  )
            else CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
