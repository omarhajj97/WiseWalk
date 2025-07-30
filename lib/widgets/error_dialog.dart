import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends StatelessWidget{
  final String message;
  final String title;
  final VoidCallback? onClose;
  const ErrorDialog({super.key, required this.title, required this.message, this.onClose});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.red)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
            if (onClose != null) {
              onClose!();
            }
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}