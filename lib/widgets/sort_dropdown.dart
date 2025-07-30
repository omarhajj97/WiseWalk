import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final void Function(String) onChanged;

  const SortDropdown({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });


  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Sort Alerts',
      offset: const Offset(0, 40),
      itemBuilder: (context) {
        return options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            enabled: true, 
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(option),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  value: selectedOption == option,
                  onChanged: (selected) {
                    Navigator.of(context).pop();
                    onChanged(option); 
                  },
                );
              },
            ),
          );
        }).toList();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.swap_vert, color: Colors.black),
            SizedBox(width: 6),
            Text(
              'Sort By',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}