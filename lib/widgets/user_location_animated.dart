import 'package:flutter/material.dart';

class UserLocationAnimated extends StatefulWidget {
  const UserLocationAnimated({super.key});

  @override
  State<UserLocationAnimated> createState() => _UserLocationAnimatedState();
}

class _UserLocationAnimatedState extends State<UserLocationAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)  {
    return FadeTransition(
      opacity: _controller,
      child: const Icon(
        Icons.person_pin_circle,
        color: Colors.blue,
        size: 40,
      ),
    );
  }
}
