import 'package:wise_walk/database_drift/app_database.dart';
import 'package:wise_walk/dataclasses/journey.dart';
import 'package:flutter/material.dart';
import 'package:wise_walk/dataclasses/trackingData.dart';


class PastJourneysViewModel extends ChangeNotifier{
  final AppDatabase _db;

  PastJourneysViewModel(this._db);

  List<Journey> _journeys = [];
  
  List<Journey> get journeys => _journeys;

  String? errorMessage;

  String _sortOption = 'Date(Newest First)';
  String get sortOption => _sortOption;

  bool _isLoadingJourneys = true;
  bool get isLoadingJourneys => _isLoadingJourneys;

  void updateSortOption(String option) {
    _sortOption = option;
    loadJourneys();
  }
  Future<void> loadJourneys() async {
    _isLoadingJourneys = true;
    notifyListeners();
    try{
    _journeys = await _db.journeyDao.sortJourneysBy(_sortOption);
    errorMessage = null;
    }
    catch(e){
      errorMessage = 'Failed to load journeys';
      _journeys =[];
    }
    _isLoadingJourneys = false;
    notifyListeners();
  }

  Future<void> addJourney(Journey journey) async{
    await _db.journeyDao.insertJourney(journey);
    await loadJourneys();
  }

  Future<void> deleteJourney(int id) async {
    await _db.journeyDao.deleteJourneyById(id);
    await loadJourneys();
  }  

  Map<String,dynamic> getTodayActivityDetails({TrackingData? currentActivity}){
    final now = DateTime.now();
    final todayJourneys = _journeys.where(
      (journey) => 
      journey.dateWithTime.year == now.year && journey.dateWithTime.month == now.month && journey.dateWithTime.day == now.day 
    );

    int totalSteps = 0;
    double totalCals = 0.0;

    for (var journey in todayJourneys){
      totalSteps += journey.steps ?? 0;
      totalCals += journey.calories ?? 0.0;
    }

    if(currentActivity != null){
      totalSteps += currentActivity.steps ?? 0;
      totalCals += currentActivity.calories ?? 0.0;
    }

    return {
      'steps':totalSteps,
      'calories': totalCals
    };

  }
    
  
}