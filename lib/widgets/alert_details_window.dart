import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_walk/dataclasses/alert.dart';

class AlertDetailsWindow extends StatelessWidget {
  final Alert alert;
  final String alertpath;

  const AlertDetailsWindow({
    super.key,
    required this.alert,
    required this.alertpath,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Image.asset(alertpath, height: 40, width: 40),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              alert.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(alert.description ?? 'N/A'),
            const SizedBox(height: 12),

            if (alert.instruction != null && alert.instruction!.isNotEmpty) ...[
              const Text(
                "Instructions:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(alert.instruction!),
              const SizedBox(height: 12),
            ],
            if (alert.startTime != null && alert.endTime != null) ...[
              const Text(
                "Duration:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("From ${(alert.startTime)} to ${(alert.endTime)}"),
              const SizedBox(height: 12),
            ],

            const Text(
              "Was this alert helpful?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Thanks for your feedback!"),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Thanks for your feedback!"),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                  child: const Text("No"),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
