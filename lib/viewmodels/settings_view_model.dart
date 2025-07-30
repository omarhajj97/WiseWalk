import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wise_walk/dataclasses/user_settings.dart';

class SettingsViewModel extends ChangeNotifier {

  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _userSettings = UserSettings(
      weatherAlertsEnabled: prefs.getBool('weatherAlertsEnabled') ?? true,
      roadAlertsEnabled: prefs.getBool('roadAlertsEnabled') ?? true,
      windThreshold: prefs.getDouble('windThreshold') ?? 2.0,
      rainThreshold: prefs.getDouble('rainThreshold') ?? 2.0,
      visibilityThreshold: prefs.getDouble('visibilityThreshold') ?? 5.0,
      uvThreshold: prefs.getDouble('uvThreshold') ?? 5.0,
      notificationType: prefs.getString('notificationType') ?? 'Audible Only',
      pushNotifications: prefs.getBool('pushNotifications') ?? true,
      emailNotifications: prefs.getBool('emailNotifications') ?? true,
      voiceCommandsEnabled: prefs.getBool('voiceCommandsEnabled') ?? true,
      locationAccessEnabled: prefs.getBool('locationAccessEnabled') ?? true,
      highContrastMode: prefs.getString('highContrastMode') ?? 'High',
      stepsGoal: prefs.getInt('stepsGoal') ?? 5000,
      caloriesGoal: prefs.getInt('caloriesGoal') ?? 500,
      roadAlertsRadius: prefs.getDouble('roadAlertsRadius') ?? 0.5,
      weight: prefs.getDouble('weight') ?? 70.0,
      theme: prefs.getString('theme') ?? 'system'


    );
    notifyListeners();
  }
    Future<void> updateWeatherAlerts(bool value) async {
      if (_userSettings == null) return;

      _userSettings = UserSettings(
        weatherAlertsEnabled: value,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('weatherAlertsEnabled', value);
      notifyListeners();
    }

      Future<void> updateRoadAlerts(bool value) async {
        _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: value,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('roadAlertsEnabled', value);
      notifyListeners();
    }

    Future<void> updateRainThreshold(double value) async {
         _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: value,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('rainThreshold', value);
      notifyListeners();
    }
    
    Future<void> updateWindThreshold(double value) async {
         _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: value,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('windThreshold', value);
      notifyListeners();
    }

   Future<void> updateUvThreshold(double value) async {
         _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: value,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('uvThreshold', value);
      notifyListeners();
    }


       Future<void> updateVisibilityThreshold(double value) async {
         _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: value,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
     
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('visibilityThreshold', value);
      notifyListeners();
    }


    Future<void> setNotificationType(String value) async {
       _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: value,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notificationType', value);
      notifyListeners();
    }

    Future<void> updatePushNotifications(bool value) async {
       _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        rainThreshold: _userSettings!.rainThreshold,
        windThreshold: _userSettings!.windThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: value,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pushNotifications', value);
      notifyListeners();
    }

    Future<void> updateEmailNotifications(bool value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: value,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('emailNotifications', value);
      notifyListeners();
    }

    Future<void> updateVoiceCommands(bool value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: value,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('voiceCommandsEnabled', value);
      notifyListeners();
    }

    Future<void> updateLocationAccess(bool value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: value,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('locationAccessEnabled', value);
      notifyListeners();
    }

    Future<void> updateHighContrastMode(String value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: value, 
        stepsGoal: _userSettings!.stepsGoal, 
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('highContrastMode', value);
      notifyListeners();
    }

  Future<void> updateStepsGoal(int value) async {
    _userSettings = UserSettings(
      weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
      roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
      windThreshold: _userSettings!.windThreshold,
      rainThreshold: _userSettings!.rainThreshold,
      visibilityThreshold: _userSettings!.visibilityThreshold,
      uvThreshold: _userSettings!.uvThreshold,
      notificationType: _userSettings!.notificationType,
      pushNotifications: _userSettings!.pushNotifications,
      emailNotifications: _userSettings!.emailNotifications,
      voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
      locationAccessEnabled: _userSettings!.locationAccessEnabled,
      highContrastMode: _userSettings!.highContrastMode,
      stepsGoal: value,
      caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepsGoal', value);
    notifyListeners();
  }

  Future<void> updateCaloriesGoal(int value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: value,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
        
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('caloriesGoal', value);
      notifyListeners();
    }


      Future<void> updateRoadAlertsRadius(double value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: value,
        weight: _userSettings!.weight,
        theme: _userSettings!.theme
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('roadAlertsRadius', value);
      notifyListeners();
    }


      Future<void> updateUserWeight(double value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: value,
        theme: _userSettings!.theme

      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('weight', value);
      notifyListeners();
    }
 Future<void> updateTheme(String value) async {
      _userSettings = UserSettings(
        weatherAlertsEnabled: _userSettings!.weatherAlertsEnabled,
        roadAlertsEnabled: _userSettings!.roadAlertsEnabled,
        windThreshold: _userSettings!.windThreshold,
        rainThreshold: _userSettings!.rainThreshold,
        visibilityThreshold: _userSettings!.visibilityThreshold,
        uvThreshold: _userSettings!.uvThreshold,
        notificationType: _userSettings!.notificationType,
        pushNotifications: _userSettings!.pushNotifications,
        emailNotifications: _userSettings!.emailNotifications,
        voiceCommandsEnabled: _userSettings!.voiceCommandsEnabled,
        locationAccessEnabled: _userSettings!.locationAccessEnabled,
        highContrastMode: _userSettings!.highContrastMode,
        stepsGoal: _userSettings!.stepsGoal,
        caloriesGoal: _userSettings!.caloriesGoal,
        roadAlertsRadius: _userSettings!.roadAlertsRadius,
        weight: _userSettings!.weight,
        theme: value

      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', value);
      notifyListeners();
    }

}
