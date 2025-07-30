import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';

class FilterAlertsOnMapSheet extends StatefulWidget{
  const FilterAlertsOnMapSheet({
    super.key
  });

  @override
  State<FilterAlertsOnMapSheet> createState() => _FilterAlertsOnMapSheetState();

}

class _FilterAlertsOnMapSheetState extends State<FilterAlertsOnMapSheet>{
  @override
  Widget build(BuildContext context) {
    final alertsViewModel = context.watch<AlertsViewmodel>();
    final selectedFilter = alertsViewModel.selectedMapFilters;
     return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Filter Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...alertsViewModel.mapFilterTypes.map((type) => CheckboxListTile(
            title: Text(type),
            value: selectedFilter.contains(type),
            onChanged: (value) {
              alertsViewModel.updateMapFilters(type, value);
            },
          )),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }
}