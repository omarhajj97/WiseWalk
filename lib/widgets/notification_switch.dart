import 'package:flutter/material.dart';

Widget notificationSwitch({
   required String label,
   required bool value, 
   required ValueChanged<bool> onChanged
  }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Switch(value: value, onChanged: onChanged),
      ],
    ),
  );
}