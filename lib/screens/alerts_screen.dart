import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';
import 'package:wise_walk/widgets/list_view_tab.dart';
import 'package:wise_walk/widgets/map_view_tab.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alertsViewModel = context.read<AlertsViewmodel>();
      alertsViewModel.fetchUserLocationAndNearbyAlerts();
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(icon: Icon(Icons.map), text: "Map View"),
              Tab(icon: Icon(Icons.list), text: "List View"),
            ],
          ),
          Expanded(child: TabBarView(children: [MapViewTab(), ListViewTab()])),
        ],
      ),
    );
  }
}
