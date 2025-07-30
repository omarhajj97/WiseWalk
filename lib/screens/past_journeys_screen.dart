import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/past_journeys_view_model.dart';
import 'package:wise_walk/widgets/journey_card.dart';
import 'package:wise_walk/widgets/refresh_button.dart';
import 'package:wise_walk/widgets/sort_dropdown.dart';

class PastJourneysScreen extends StatefulWidget {
  const PastJourneysScreen({super.key});

  @override
  State<PastJourneysScreen> createState() => _PastJourneysScreenState();
}

class _PastJourneysScreenState extends State<PastJourneysScreen> {
  @override
  Widget build(BuildContext context) {
    final pastJourneysViewModel = context.watch<PastJourneysViewModel>();
    final journeys = pastJourneysViewModel.journeys;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SortDropdown(
                  options: const [
                    'Date(Newest First)',
                    'Date(Oldest First)',
                    'Duration(Longest First)',
                    'Duration(Shortest First)',
                    'Distance(Shortest First)',
                    'Distance(Longest First)',
                  ],
                  selectedOption: pastJourneysViewModel.sortOption,
                  onChanged: (value) {
                    pastJourneysViewModel.updateSortOption(value);
                  },
                ),
                RefreshButton(
                  onPressed: () async {
                    await pastJourneysViewModel
                        .loadJourneys(); 
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Journeys refreshed"),
                        ),
                      );
                    }
                  },
                  label: "Refresh",
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (pastJourneysViewModel.errorMessage != null)
              Text(
                pastJourneysViewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (pastJourneysViewModel.isLoadingJourneys)
              const Center(child: CircularProgressIndicator())
            else if (journeys.isEmpty)
              const Center(
                heightFactor: 20,
                child: Text("No journeys recorded yet."),
              )
            else
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: false,
                        radius: const Radius.circular(6),
                        thickness: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ListView.builder(
                            itemCount: journeys.length,
                            itemBuilder: (context, index) {
                              final journey = journeys[index];
                              return JourneyCard(
                                journey: journey,
                                onTap: () {
                                  context.push(
                                    '/journeydetails',
                                    extra: journey,
                                  );
                                },
                                onDelete: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Journey'),
                                      content: Text(
                                        'Are you sure you want to delete this journey?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    pastJourneysViewModel.deleteJourney(
                                      journey.id!,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
