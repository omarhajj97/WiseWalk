import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/services/notification_service.dart';
import 'package:wise_walk/viewmodels/settings_view_model.dart';
import 'package:wise_walk/widgets/activity_goal_dialog.dart';
import 'package:wise_walk/widgets/activity_info.dart';
import 'package:wise_walk/widgets/notification_dropdown.dart';
import 'package:wise_walk/widgets/notification_switch.dart';
import 'package:wise_walk/widgets/settings_header_info.dart';
import 'package:wise_walk/widgets/threshold_slider.dart';
import 'package:wise_walk/widgets/weight_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Scrollbar(
          thumbVisibility: false,
          radius: const Radius.circular(6),
          thickness: 6,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingsHeaderInfo(
                    header: "Theme Mode",
                    info:
                        "Set the type of theme including light, dark, and system themes.",
                  ),
                  notificationDropdown(
                    label: 'Theme',
                    value: settingsViewModel.userSettings!.theme,
                    items: ['system', 'light', 'dark'],
                    onChanged: (selected) {
                      if (selected != null) {
                        settingsViewModel.updateTheme(selected);
                      }
                    },
                  ),

                  const Divider(height: 32),

                  const SettingsHeaderInfo(
                    header: "Weather Preferences",
                    info:
                        "Set thresholds for wind speed, rain, visibility, and UV to trigger alerts that match your comfort.",
                  ),
                  thresholdSlider(
                    label: 'Wind Speed Threshold (m/s)',
                    value: settingsViewModel.userSettings!.windThreshold,
                    min: 0,
                    max: 100,
                    onChanged: settingsViewModel.updateWindThreshold,
                  ),
                  thresholdSlider(
                    label: 'Rain Threshold (mm/h)',
                    value: settingsViewModel.userSettings!.rainThreshold,
                    min: 0,
                    max: 100,
                    onChanged: settingsViewModel.updateRainThreshold,
                  ),
                  thresholdSlider(
                    label: 'Visibility Threshold (km)',
                    value: settingsViewModel.userSettings!.visibilityThreshold,
                    min: 0,
                    max: 20,
                    onChanged: settingsViewModel.updateVisibilityThreshold,
                  ),
                  thresholdSlider(
                    label: 'UV Index Threshold',
                    value: settingsViewModel.userSettings!.uvThreshold,
                    min: 0,
                    max: 11,
                    onChanged: settingsViewModel.updateUvThreshold,
                  ),
                  const Divider(height: 32),

                  const SettingsHeaderInfo(
                    header: "Alert Preferences",
                    info: "Choose which types of alerts you want to receive.",
                  ),
                  notificationSwitch(
                    label: 'Weather Alerts',
                    value: settingsViewModel.userSettings!.weatherAlertsEnabled,
                    onChanged: settingsViewModel.updateWeatherAlerts,
                  ),
                  notificationSwitch(
                    label: 'Road Alerts',
                    value: settingsViewModel.userSettings!.roadAlertsEnabled,
                    onChanged: settingsViewModel.updateRoadAlerts,
                  ),

                  const Divider(height: 32),
                  SettingsHeaderInfo(
                    header: "Map Settings",
                    info:
                        "Specifices how far around you to search for road closures.",
                  ),

                  thresholdSlider(
                    label: "Road Alerts Radius (km)",
                    value: settingsViewModel.userSettings!.roadAlertsRadius,
                    min: 0.0,
                    max: 5.0,
                    onChanged: (value) {
                      settingsViewModel.updateRoadAlertsRadius(value);
                    },
                  ),
                  const Divider(height: 32),
                  const SettingsHeaderInfo(
                    header: "Activity Goals",
                    info:
                        "Set daily step and calorie goals to track your progress.",
                  ),
                  ActivityInfo(
                    title: 'Daily Steps Goal',
                    info: '${settingsViewModel.userSettings!.stepsGoal} steps',
                    icon: const Icon(Icons.directions_walk),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ActivityGoalDialog(
                          currentGoal:
                              settingsViewModel.userSettings!.stepsGoal,
                          onSave: (newGoal) {
                            settingsViewModel.updateStepsGoal(newGoal);
                          },
                          typeOfGoal: 'Steps',
                        ),
                      );
                    },
                  ),
                  ActivityInfo(
                    title: 'Daily Calorie Goal',
                    info:
                        '${settingsViewModel.userSettings!.caloriesGoal} calories',
                    icon: Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ActivityGoalDialog(
                          currentGoal:
                              settingsViewModel.userSettings!.caloriesGoal,
                          onSave: (newGoal) {
                            settingsViewModel.updateCaloriesGoal(newGoal);
                          },
                          typeOfGoal: 'Calories',
                        ),
                      );
                    },
                  ),
                  const Divider(height: 32),
                  SettingsHeaderInfo(
                    header: "Your Weight (in Kg)",
                    info:
                        "Used to calculate calories burned based on your activity.",
                  ),
                  ActivityInfo(
                    title: 'Your Weight (in Kg)',
                    info: '${settingsViewModel.userSettings!.weight} kg',
                    icon: const Icon(Icons.scale),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => WeightDialog(
                          weight: settingsViewModel.userSettings!.weight,
                          onSave: (double newWeight) {
                            settingsViewModel.updateUserWeight(newWeight);
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 32),

                  const SettingsHeaderInfo(
                    header: "Accessibility Preferences",
                    info:
                        "Enable voice commands, high contrast, and location access to your device.",
                  ),
                  notificationSwitch(
                    label: 'Enable Voice Commands',
                    value: settingsViewModel.userSettings!.voiceCommandsEnabled,
                    onChanged: settingsViewModel.updateVoiceCommands,
                  ),
                  notificationSwitch(
                    label: 'Location Access',
                    value:
                        settingsViewModel.userSettings!.locationAccessEnabled,
                    onChanged: settingsViewModel.updateLocationAccess,
                  ),
                  notificationDropdown(
                    label: 'Contrast Mode',
                    value: settingsViewModel.userSettings!.highContrastMode,
                    items: ['High', 'Medium', 'Low'],
                    onChanged: (val) {
                      if (val != null)
                        settingsViewModel.updateHighContrastMode(val);
                    },
                  ),
                  const Divider(height: 32),

                  const SettingsHeaderInfo(
                    header: "Notifications",
                    info: "control how you receive notifications.",
                  ),
                  notificationSwitch(
                    label: 'Push Notifications',
                    value: settingsViewModel.userSettings!.pushNotifications,
                    onChanged: settingsViewModel.updatePushNotifications,
                  ),
                  notificationSwitch(
                    label: 'Email Notifications',
                    value: settingsViewModel.userSettings!.emailNotifications,
                    onChanged: settingsViewModel.updateEmailNotifications,
                  ),
                  notificationDropdown(
                    label: 'Notification Type',
                    value: settingsViewModel.userSettings!.notificationType,
                    items: ['Audible Only', 'Visual Only', 'Both'],
                    onChanged: (String? selected) {
                      if (selected != null) {
                        settingsViewModel.setNotificationType(selected);
                      }
                    },
                  ),

                  const Divider(height: 32),

                  const SettingsHeaderInfo(
                    header: "Notification Testing",
                    info:
                        "Send a fake push notification to test your notifications.",
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      NotificationService.showSimulatedNotification(
                        title: '🚧 Road Closed',
                        body: 'Queen Street closed due to roadworks',
                        screen: '/alerts',
                      );
                    },
                    child: Text('Simulate Push Notification'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.deepPurple,
                          width: 2, 
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
    );
  }
}
