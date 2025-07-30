import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';
import 'package:wise_walk/widgets/alert_card.dart';
import 'package:wise_walk/widgets/alert_details_window.dart';
import 'package:wise_walk/widgets/fliter_dropdown.dart';
import 'package:wise_walk/widgets/refresh_button.dart';
import 'package:wise_walk/widgets/sort_dropdown.dart';

class ListViewTab extends StatelessWidget {
  const ListViewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final alertsViewModel = Provider.of<AlertsViewmodel>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FilterDropdown(
                    selectedFilter: alertsViewModel.selectedMapFilters,
                    onChanged: alertsViewModel.updateFilterOptions,
                  ),
                  const SizedBox(width: 12),
                  SortDropdown(
                    options: [
                      'Most Recent',
                      'Least Recent',
                      'Highest Severity',
                      'Lowest Severity',
                      'Nearest to Me',
                      'Farthest from Me',
                    ],
                    selectedOption: alertsViewModel.sortOption,
                    onChanged: alertsViewModel.updateSortOption,
                  ),
                ],
              ),
              RefreshButton(
                onPressed: () async {
                  await alertsViewModel.fetchUserLocationAndNearbyAlerts();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Alerts refreshed")),
                    );
                  }
                },
                label: "Refresh",
              ),
            ],
          ),
        ),
        Expanded(
          child: alertsViewModel.isLoadingAlerts
              ? const Center(child: CircularProgressIndicator())
              : alertsViewModel.alerts.isEmpty
              ? const Center(child: Text('No nearby alerts detected.'))
              : Scrollbar(
                  thumbVisibility: false,
                  radius: const Radius.circular(6),
                  thickness: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await alertsViewModel
                            .fetchUserLocationAndNearbyAlerts();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: alertsViewModel.filteredAlerts.length,
                        itemBuilder: (context, index) {
                          final alert = alertsViewModel.filteredAlerts[index];
                          return AlertCard(
                            alert: alert,
                            alertsViewModel: alertsViewModel,
                            onTap: () {
                              alertsViewModel.selectAlert(alert);
                              showDialog(
                                context: context,
                                builder: (_) => AlertDetailsWindow(
                                  alert: alert,
                                  alertpath: alertsViewModel.getAlertIconPath(
                                    alert.type,
                                  ),
                                ),
                              ).then((_) => alertsViewModel.dismissDialog());
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
