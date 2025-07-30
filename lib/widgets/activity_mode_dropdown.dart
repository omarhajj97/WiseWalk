import 'package:flutter/material.dart';
import 'package:wise_walk/dataclasses/trackingData.dart';

class ActivityModeDropdown extends StatelessWidget {
  final ActivityMode currentActivityMode;
  final ValueChanged<ActivityMode?> onChanged;
  final PopupMenuItemSelected<ActivityMode>? onSelected;

  const ActivityModeDropdown({
    super.key,
    required this.currentActivityMode,
    required this.onChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<ActivityMode>(
      offset: const Offset(0, 40),
      onSelected: onSelected,
      itemBuilder: (context) => ActivityMode.values.map((mode) {
        return PopupMenuItem(
          value: mode,
          child: Text(
            mode == ActivityMode.walking ? '🚶 Walking' : '🚴 Cycling',style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400,width: 2),
          borderRadius: BorderRadius.circular(12),
          color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(currentActivityMode == ActivityMode.walking ? '🚶 Walking' : '🚴 Cycling',style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),),
        const Icon(Icons.arrow_drop_down),
      ],
      ),
      )
    );
  }
}
