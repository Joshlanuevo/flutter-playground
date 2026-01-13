import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/expenses.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 244, 246),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 96, 59, 181),
        ),
      ),
      home: Expenses(),
    ),
  );
}