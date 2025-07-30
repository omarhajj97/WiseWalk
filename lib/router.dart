import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/database_drift/app_database.dart';
import 'package:wise_walk/database_drift/route_coordinates_dao.dart';
import 'package:wise_walk/dataclasses/journey.dart';
import 'package:wise_walk/main.dart';
import 'package:wise_walk/main_scaffold.dart';
import 'package:wise_walk/screens/journey_details_screen.dart';
import 'package:wise_walk/screens/tracking_screen.dart';
import 'package:wise_walk/viewmodels/journey_details_view_model.dart';
import 'screens/home_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/past_journeys_screen.dart';
import 'screens/settings_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: navigatorKey,
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
         GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/alerts',
          builder: (context, state) => AlertsScreen(),
        ),
        GoRoute(
          path: '/pastjourneys',
          builder: (context, state) => PastJourneysScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/tracking',
          builder: (context, state) => TrackingScreen(),
        ),
        GoRoute(
          path: '/journeydetails',
          builder: (context, state) {
            final journey = state.extra as Journey;
            final appDatabase = Provider.of<AppDatabase>(context, listen: false);
            final routeCoordinatesDao = RouteCoordinatesDao(appDatabase);
            return ChangeNotifierProvider(
              create: (_) => JourneyDetailsViewModel(journey: journey,routeCoordinatesDao: routeCoordinatesDao ),
              child: JourneyDetailsScreen(journey: journey),
            );
          },
        ),
      ],
    )
  ],
);
