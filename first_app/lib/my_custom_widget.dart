import 'package:flutter/material.dart';

class MyCustomWidget extends StatelessWidget {
  final String message;

  const MyCustomWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
      ),
    );
  }
}