import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final Set<String> selectedFilter;
  final Function(Set<String>) onChanged;

  const FilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filterOptions = [
      'All Alerts',
      'Weather Alerts Only',
      'Road Disruptions Only',
      'Emergency Alerts Only',
      'Alerts Within 2km',
      'Alerts Within 5km',
    ];

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      itemBuilder: (context) {
        final Set<String> updatedChecks = Set<String>.from(selectedFilter);
        return [
          PopupMenuItem<String>(
            enabled: true,
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter menuSetState) {
                return StatefulBuilder(
                  builder: (context, setInnerState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filterOptions.map((filterOption) {
                        final isChecked = updatedChecks.contains(filterOption);
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: isChecked,
                          contentPadding: EdgeInsets.zero,
                          title: Text(filterOption),
                          onChanged: (checked) {
                            menuSetState(() {
                              if (checked == true) {
                                if (filterOption == 'All Alerts') {
                                  updatedChecks
                                    ..clear()
                                    ..addAll(
                                      filterOptions.where(
                                        (option) =>
                                            option != 'Alerts Within 2km' &&
                                            option != 'Alerts Within 5km',
                                      ),
                                    )
                                    ..add('All Alerts');
                                } else {
                                  updatedChecks.add(filterOption);
                                  updatedChecks.remove('All Alerts');
                                }
                              } else {
                                updatedChecks.remove(filterOption);
                                if (filterOption == 'All Alerts') {
                                  updatedChecks.clear();
                                }
                              }
                              onChanged(Set<String>.from(updatedChecks));
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ];
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
            Icon(Icons.filter_alt, color: Colors.black),
            SizedBox(width: 6),
            Text(
              'Filter',
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
