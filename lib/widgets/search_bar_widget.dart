import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_walk/viewmodels/alerts_view_model.dart';

class SearchBarWidget extends StatelessWidget{
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: _controller,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            context.read<AlertsViewmodel>().searchLocation(value.trim());
          }
        },
        decoration: const InputDecoration(
          hintText: 'Search or hold to route...',
          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}