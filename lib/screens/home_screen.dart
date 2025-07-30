import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';
import 'package:wise_walk/viewmodels/home_view_model.dart';
import 'package:wise_walk/viewmodels/past_journeys_view_model.dart';
import 'package:wise_walk/viewmodels/settings_view_model.dart';
import 'package:wise_walk/viewmodels/tracking_view_model.dart';
import 'package:wise_walk/widgets/alert_details_window.dart';
import 'package:wise_walk/widgets/circular_activity_indicator.dart';
import 'package:wise_walk/widgets/error_dialog.dart';
import 'package:wise_walk/widgets/live_journey_card.dart';
import 'package:wise_walk/widgets/refresh_button.dart';
import 'package:wise_walk/widgets/start_new_journey_button.dart';
import 'package:wise_walk/widgets/weather_details_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final homeViewModel = context.read<HomeViewModel>();
      final alertsViewModel = context.read<AlertsViewmodel>();
      await homeViewModel.ensureLocationPermission();
      await homeViewModel.fetchWeatherForCurrentLocation();
      await alertsViewModel.fetchUserLocationAndNearbyAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final currentForecast = homeViewModel.cuurentForecast;
    final hourlyForecast = homeViewModel.hourlyForecasts;
    final alertsViewModel = context.watch<AlertsViewmodel>();
    final settingsViewModel = context.watch<SettingsViewModel>();
    final trackingViewModel = context.watch<TrackingViewModel>();
    final isTracking = trackingViewModel.isTracking;
    final pastJourneysViewModel = context.watch<PastJourneysViewModel>();
    final stats = pastJourneysViewModel.getTodayActivityDetails(
      currentActivity: trackingViewModel.isTracking
          ? trackingViewModel.trackingData
          : null,
    );
    if (settingsViewModel.userSettings == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final stepsGoal = settingsViewModel.userSettings!.stepsGoal;
    final caloriesGoal = settingsViewModel.userSettings!.caloriesGoal;
    final steps = stats['steps'];
    final calories = stats['calories'];

    if (homeViewModel.showPermissionErrorDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(
            title: 'Location Access Denied',
            message:
                'Please enable location permissions in your settings to continue.',
            onClose: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Location required. Tap to open settings.',
                  ),
                  action: SnackBarAction(
                    label: 'Settings',
                    onPressed: () {
                      Geolocator.openAppSettings();
                    },
                  ),
                ),
              );
            },
          ),
        );
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isTracking) ...[
                          liveJourneyCard(context, trackingViewModel),
                          const SizedBox(height: 20),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.dashboard, size: 25),
                                SizedBox(width: 6),
                                Text(
                                  "Dashboard",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            RefreshButton(
                              onPressed: () async {
                                await homeViewModel
                                    .fetchWeatherForCurrentLocation();
                                await alertsViewModel
                                    .fetchUserLocationAndNearbyAlerts();

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Dashboard refreshed"),
                                    ),
                                  );
                                }
                              },
                              label: "Refresh",
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Card(
                            //weather card
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.cloud, size: 30),
                                          SizedBox(width: 6),
                                          Text(
                                            "Current Weather",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      (currentForecast.location == "Unknown" ||
                                              currentForecast.weather ==
                                                  "Loading...")
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : ListTile(
                                              leading:
                                                  (homeViewModel.weatherIcon),
                                              title: Text(
                                                "${currentForecast.temperature.round()}°C - ${currentForecast.location}",
                                              ),
                                              subtitle: Text(
                                                currentForecast.weather,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 90,
                                  right: 2,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: ((context) =>
                                            WeatherDetailsDialog(
                                               currentForecast: currentForecast,
                                              hourlyForecast: hourlyForecast,
                                            )),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text("More Details"),
                                        SizedBox(width: 4),
                                        Icon(Icons.chevron_right, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //latest alert
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Card(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.security_update_warning,
                                            size: 30,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Latest Alert",
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      if (alertsViewModel.isLoadingAlerts)
                                        const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      else if (alertsViewModel.latestAlert !=
                                          null)
                                        ListTile(
                                          leading: Image.asset(
                                            homeViewModel.getAlertIconPath(
                                              alertsViewModel.latestAlert!.type,
                                            ),
                                            width: 40,
                                            height: 40,
                                          ),
                                          title: Text(
                                            alertsViewModel.latestAlert!.title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          subtitle: Text(
                                            alertsViewModel
                                                    .latestAlert!
                                                    .location
                                                    .contains('|')
                                                ? 'Multiple Areas'
                                                : alertsViewModel
                                                      .latestAlert!
                                                      .location,
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      else
                                        Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Center(
                                            child: Text(
                                              "No alerts found nearby.",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (!alertsViewModel.isLoadingAlerts &&
                                    alertsViewModel.latestAlert != null)
                                  Positioned(
                                    top: 95,
                                    right: 2,
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDetailsWindow(
                                            alert: alertsViewModel.latestAlert!,
                                            alertpath: alertsViewModel
                                                .getAlertIconPath(
                                                  alertsViewModel
                                                      .latestAlert!
                                                      .type,
                                                ),
                                          ),
                                        ).then(
                                          (_) =>
                                              alertsViewModel.dismissDialog(),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text("More Details"),
                                          SizedBox(width: 4),
                                          Icon(Icons.chevron_right, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Card(
                            //health
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.run_circle_outlined, size: 30),
                                      SizedBox(width: 6),
                                      Text(
                                        "Today's Health Summary",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircularActivityIndicator(
                                        label: "Steps",
                                        currentValue: steps,
                                        goalValue: stepsGoal,
                                        color: Colors.purple,
                                      ),
                                      CircularActivityIndicator(
                                        label: "Calories",
                                        currentValue: calories.toInt(),
                                        goalValue: caloriesGoal,
                                        color: Colors.purple,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: StartNewJourneyButton(isTracking: isTracking),
    );
  }
}
