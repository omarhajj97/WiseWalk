

class UserSettings {
  final bool weatherAlertsEnabled;
  final bool roadAlertsEnabled;
  final double windThreshold;
  final double rainThreshold;
  final double visibilityThreshold;
  final double uvThreshold;
  final String notificationType;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool voiceCommandsEnabled;
  final bool locationAccessEnabled;
  final String highContrastMode;
  final int stepsGoal;
  final int caloriesGoal;
  final double roadAlertsRadius;
  final double weight;
  final String theme; 

  UserSettings({
    required this.weatherAlertsEnabled,
    required this.roadAlertsEnabled,
    required this.windThreshold,
    required this.rainThreshold,
    required this.visibilityThreshold,
    required this.uvThreshold,
    required this.notificationType,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.voiceCommandsEnabled,
    required this.locationAccessEnabled,
    required this.highContrastMode,
    required this.stepsGoal,
    required this.caloriesGoal,
    required this.roadAlertsRadius,
    required this.weight,
    required this.theme
  });

  
  factory UserSettings.defaultSettings() => UserSettings(
        weatherAlertsEnabled: true,
        roadAlertsEnabled: true,
        windThreshold: 2.0,
        rainThreshold: 2.0,
        visibilityThreshold: 2.0,
        uvThreshold: 2.0,
        notificationType: 'Audible Only',
        pushNotifications: true,
        emailNotifications: true,
        voiceCommandsEnabled: true,
        locationAccessEnabled: true,
        highContrastMode: 'High',
        stepsGoal: 5000,
        caloriesGoal: 500,
        roadAlertsRadius: 0.5,
        weight: 70,
        theme: 'system'
        
      );
      
      }