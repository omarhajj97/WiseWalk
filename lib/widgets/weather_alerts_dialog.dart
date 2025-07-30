import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/dataclasses/alert.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';

class WeatherAlertsDialog extends StatelessWidget {
  final List<Alert> weatherAlerts;

  const WeatherAlertsDialog({super.key, required this.weatherAlerts});

  @override
  Widget build(BuildContext context) {
    final alertsViewModel = context.read<AlertsViewmodel>();

    return AlertDialog(
      title: const Text('Weather Alerts'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: weatherAlerts.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final alert = weatherAlerts[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 2),
                  child: Image.asset(
                    alertsViewModel.getAlertIconPath(alert.type),
                    width: 30,
                    height: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (alert.description != null) ...[
                        const SizedBox(height: 4),
                        Text(alert.description!),
                      ],
                      if (alert.startTime != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'From: ${DateFormat('dd MMM yyyy, HH:mm').format(alert.startTime!)}',
                        ),
                      ],
                      if (alert.endTime != null) ...[
                        Text(
                          'To: ${DateFormat('dd MMM yyyy, HH:mm').format(alert.endTime!)}',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
