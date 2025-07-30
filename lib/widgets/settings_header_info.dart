import 'package:flutter/material.dart';

class SettingsHeaderInfo extends StatelessWidget {
  final String header;
  final String info;

  const SettingsHeaderInfo({
    super.key,
    required this.header,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          header,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogCon) => AlertDialog(
                title: Text(header),
                content: Text(info),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCon),
                    child: const Text("Ok"),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.info_outline, size: 23),
        ),
      ],
    );
  }
}
