import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/services/notification_service.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';


class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});


    @override
  State<StatefulWidget> createState() => _MainScaffoldState();

}

class _MainScaffoldState extends State<MainScaffold>{
  bool _hasShownNotification = false;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alertsViewModel = Provider.of<AlertsViewmodel>(context, listen: false);

    if (!_hasShownNotification && alertsViewModel.latestAlert != null) {
      _hasShownNotification = true;

      final alert = alertsViewModel.latestAlert!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotificationService.showSimulatedNotification(
          title: '🚨 ${alert.type}',
          body: alert.title,
          screen: '/alerts', 
        );
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();
  final alertsViewModel = Provider.of<AlertsViewmodel>(context);

  int currentIndex = switch (location) {
        '/' => 0,
        '/alerts' => 1,
        '/pastjourneys' => 2,
        _ => 0,
      };

      final title = switch (location) {
        '/' => 'Home',
        '/alerts' => 'Alerts Near You',
        '/pastjourneys' => 'Past Journeys',
        '/settings' => 'Settings',
        '/tracking' => 'Journey Tracker',
        '/journeydetails' => 'Journey Details',
        _ => '',
      };

      final bool isSettings = location == '/settings';
      final bool isTracking = location == '/tracking';
      final bool isDetails = location == '/journeydetails';
      return Scaffold(
        appBar: AppBar(
          title: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28)),
          centerTitle: true,
          automaticallyImplyLeading: isSettings || isTracking || isDetails,
          leading: isSettings || isTracking || isDetails
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, size:30),
                  onPressed: () => context.pop(),
                )
              : null,
          actions: isSettings
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.settings, size: 38,),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
        ),
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
            final routes = ['/', '/alerts', '/pastjourneys'];

            if (!isSettings) {
              context.go(routes[index]);
            } else {
              context.go(routes[index]);
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Badge(isLabelVisible: alertsViewModel.hasUnreadAlerts, label: Text(alertsViewModel.alertCount.toString(), style: const TextStyle(fontSize: 10)),child: const Icon(Icons.notifications)), label: 'Nearby Alerts'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Past Journeys'),
          ],
        ),
      );
    }
    
}