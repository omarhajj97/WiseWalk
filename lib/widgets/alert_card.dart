import 'package:flutter/material.dart';
import 'package:wise_walk/dataclasses/alert.dart';
import 'package:intl/intl.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final AlertsViewmodel alertsViewModel;
  final VoidCallback onTap;

  const AlertCard({
    super.key,
    required this.alert,
    required this.alertsViewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = alertsViewModel.getAlertIconPath(alert.type);
    final formatter = DateFormat('dd MMM yyyy, HH:mm');
    final DateTime alertStartTime = alert.startTime ?? DateTime.now();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: alertsViewModel.getAlertCardBorderColor(alert.type),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(icon, width: 40, height: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (alert.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        alert.location,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                    /*if (alert.description != null &&
                        alert.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(alert.description!),
                    ],*/
                    const SizedBox(height: 4),
                    Text('Issued: ${formatter.format(alertStartTime)}'),
                    if (alert.endTime != null)
                      Text('Valid Until: ${formatter.format(alert.endTime!)}')
                    else
                      const Text('Valid Until: N/A'),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("More Details"),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
