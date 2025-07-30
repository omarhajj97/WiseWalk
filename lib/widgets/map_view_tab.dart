import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';
import 'package:wise_walk/widgets/alert_details_window.dart';
import 'package:wise_walk/widgets/road_alert_marker.dart';
import 'package:wise_walk/widgets/filter_alerts_on_map_sheet.dart';
import 'package:wise_walk/widgets/search_bar_widget.dart';
import 'package:wise_walk/widgets/show_government_alert_marker.dart';
import 'package:wise_walk/widgets/show_route_button.dart';
import 'package:wise_walk/widgets/show_weather_alert_marker.dart';
import 'package:wise_walk/widgets/show_weather_and_gov_alert_marker.dart';
import 'package:wise_walk/widgets/user_location_animated.dart';
import 'package:wise_walk/widgets/weather_alerts_dialog.dart';

class MapViewTab extends StatefulWidget {
  const MapViewTab({super.key});

  @override
  State<StatefulWidget> createState() => _MapViewTabState();
}

class _MapViewTabState extends State<MapViewTab> {
  late final alertsViewModel = Provider.of<AlertsViewmodel>(
    context,
    listen: false,
  );

  @override
  void initState() {
    super.initState();
    alertsViewModel.trackCurrentLocation();
  }

  @override
  void dispose() {
    alertsViewModel.stopTrackingCurrentLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertsViewmodel>(
      builder: (context, alertsViewModel, _) {
        if (alertsViewModel.isLoadingAlerts || alertsViewModel.userLocation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (alertsViewModel.dialogShown &&
              alertsViewModel.selectedAlert != null) {
            showDialog(
              context: context,
              builder: (_) => AlertDetailsWindow(
                alert: alertsViewModel.selectedAlert!,
                alertpath: alertsViewModel.getAlertIconPath(
                  alertsViewModel.selectedAlert!.type,
                ),
              ),
            ).then((_) => alertsViewModel.dismissDialog());
          } else if (alertsViewModel.dialogShown &&
              alertsViewModel.selectedWeatherAlerts.isNotEmpty) {
            showDialog(
              context: context,
              builder: (_) => WeatherAlertsDialog(
                weatherAlerts: alertsViewModel.selectedWeatherAlerts,
              ),
            ).then((_) => alertsViewModel.dismissDialog());
          }
        });

        if (alertsViewModel.userLocation == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: alertsViewModel.mapController,
              options: MapOptions(
                initialCenter: alertsViewModel.userLocation!,
                initialZoom: alertsViewModel.zoomLevel,
                onLongPress: (tapPosition, latlng) {
                  alertsViewModel.setPendingDestination(latlng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                  subdomains: ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.wisewalk',
                ),
                MarkerLayer(
                  markers: [
                    if (alertsViewModel.selectedMapFilters.contains(
                          'Weather Alerts',
                        ) &&
                        alertsViewModel.selectedMapFilters.contains(
                          'Emergency Alerts',
                        ) &&
                        alertsViewModel.filteredWeatherAlerts.isNotEmpty &&
                        alertsViewModel.filteredGovernmentAlerts.isNotEmpty)
                      showWeatherAndGovernmentAlertMarker(
                        location: alertsViewModel.userLocation!,
                        onWeatherTap: () =>
                            alertsViewModel.selectWeatherAlerts(),
                        onGovTap: () => alertsViewModel.selectAlert(
                          alertsViewModel.governmentAlerts.first,
                        ),
                      )
                    else if (alertsViewModel.selectedMapFilters.contains(
                          'Weather Alerts',
                        ) &&
                        alertsViewModel.filteredWeatherAlerts.isNotEmpty &&
                        alertsViewModel.filteredGovernmentAlerts.isEmpty)
                      showWeatherAlertMarker(
                        userCurrentLocation: alertsViewModel.userLocation!,
                        onTap: () => alertsViewModel.selectWeatherAlerts(),
                      )
                    else if (alertsViewModel.selectedMapFilters.contains(
                          'Emergency Alerts',
                        ) &&
                        alertsViewModel.filteredGovernmentAlerts.isNotEmpty &&
                        alertsViewModel.filteredWeatherAlerts.isEmpty)
                      showGovernmentAlertMarker(
                        userCurrentLocation: alertsViewModel.userLocation!,
                        onTap: () => alertsViewModel.selectAlert(
                          alertsViewModel.governmentAlerts.first,
                        ),
                      ),
                    ...alertsViewModel.filteredMapAlerts
                        .where((alert) => alert.type.toLowerCase() == 'road')
                        .map(
                          (alert) => Marker(
                            point: LatLng(alert.latitude, alert.longitude),
                            width: 40,
                            height: 40,
                            child: RoadAlertMarker(
                              alert: alert,
                              onTap: () {
                                alertsViewModel.selectAlert(alert);
                              },
                            ),
                          ),
                        ),
                    if (alertsViewModel.userLocation != null)
                      Marker(
                        point: alertsViewModel.userLocation!,
                        width: 40,
                        height: 40,
                        child: /*const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),*/
                            UserLocationAnimated(),
                      ),

                    if (alertsViewModel.pendingDestination != null)
                      Marker(
                        point: alertsViewModel.pendingDestination!,
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            alertsViewModel.clearPendingDestination();
                          },
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.purple,
                            size: 36,
                          ),
                        ),
                      )
                    else if (alertsViewModel.routePoints.isNotEmpty)
                      Marker(
                        point: alertsViewModel.routePoints.last,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.purple,
                          size: 36,
                        ),
                      ),
                  ],
                ),
                if (alertsViewModel.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: alertsViewModel.routePoints,
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),

            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: const SearchBarWidget(),
            ),

            if (alertsViewModel.pendingDestination != null)
              Positioned(
                bottom: 40,
                right: 16,
                left: 16,
                child: ShowRouteButton(alertsViewModel: alertsViewModel),
              ),

            Positioned(
              bottom: 20,
              right: 12,
              child: Column(
                children: [
                  Tooltip(
                    message: "Refresh Alerts",
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple, width: 2),
                      ),
                      child: FloatingActionButton(
                        heroTag: 'refresh',
                        shape: CircleBorder(),
                        onPressed: () async {
                          await alertsViewModel
                              .fetchUserLocationAndNearbyAlerts();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Alerts refreshed')),
                          );
                        },

                        child: Icon(Icons.refresh),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  Tooltip(
                    message: "Center Map",
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple, width: 2),
                      ),
                      child: FloatingActionButton(
                        heroTag: 'centerLocation',
                        shape: CircleBorder(),
                        onPressed: alertsViewModel.recenterMapToUserLocation,
                        //    backgroundColor: Colors.deepPurple.shade200,
                        child: Icon(Icons.my_location),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  Tooltip(
                    message: "Filter Alerts",
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple, width: 2),
                      ),
                      child: FloatingActionButton(
                        heroTag: 'filterAlerts',
                        shape: CircleBorder(),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) =>
                                const FilterAlertsOnMapSheet(),
                          );
                        },
                        child: const Icon(Icons.filter_alt_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
