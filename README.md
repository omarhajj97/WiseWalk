##### WiseWalk – Active Commuter Support System

### Overview
WiseWalk is a cross-platform mobile application developed using Flutter that aims to support active commuters and provide contextual awareness, safety, and an enhanced active travelling experience. It provides weather, road, and government-issued alerts to support the user during their commute while also providing customization features to adjust alerts using weather thresholds suited to the user’s preference. Users can also track their journeys and view them later. This project was developed as part of an MSc dissertation at the University of Strathclyde

### Features:
* Home Dashboard: Displays the current weather forecast, latest surrounding alert, and daily activity progress  
* Nearby Alerts: Provides nearby road disruptions, weather alerts triggered by user-defined weather thresholds, and government-issued alerts to support pedestrians and cyclists during their commutes  
* Journey Tracker: Allows users to track their active commutes, recording metrics like step count, calories burnt, distance, and others.  
* Past Journeys: Active travellers can view their saved journeys along with their corresponding details.

### Tech Stack:
* Framework: Flutter  
* Architecture: MVVM  
* Database: Drift  
* Maps: flutter_map package (based on OpenStreetMap)  
* APIs:  
  - OpenWeatherMap One Call v3.0  
  - WeatherAPI  
  - TomTom Traffic Incidents API  
  - TomTom Reverse Geocoding API  
  - TomTom Search API  
  - OpenRouteService Directions API  

### Project Structure:

lib/
 - database_drift/    # Drift database, tables, and DAO classes
 - dataclasses/       # Data models (Journey, Alert, etc.)
 - services/          # Notification, API, and location services
 - viewmodels/        # MVVM ViewModels
 - screens/           # UI screens (MVVM Views)
 - widgets/           # Reusable UI components
 - main.dart          # Application entry point
 - router.dart        # GoRouter configuration
 - main_scaffold.dart # wraps all screens


### How To Clone and Run Locally:
1) Before beginning, ensure the Flutter SDK is installed on your machine: https://docs.flutter.dev/get-started/install  

2) Open a terminal  

3) Clone the repository:  

   - git clone https://gitlab.cis.strath.ac.uk/cib24160/wise-walk
   - cd wise_walk

4) Install all dependencies:

   - flutter pub get

5) Configure API keys: (make sure to load these keys in the application before making API calls)
 - create a .env or config.dart file in the project
 - Add API keys for OpenWeatherMap, WeatherAPI, TomTom APIs, OpenRouteService
 - Example of .env file:
 ~~~  
   OPENWEATHERMAP_API_KEY=your_api_key_here
   WEATHERAPI_KEY=your_api_key_here
   TOMTOM_API_KEY=your_api_key_here
   ORS_API_KEY=your_api_key_here
 ~~~   

6) Run the application:

   - flutter run


IMPORTANT NOTES:
- WiseWalk uses simulated push notification to illustrate incoming alerts 
- Location access is required to obtain weather and alert information + tracking and routing








