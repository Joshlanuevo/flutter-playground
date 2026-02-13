import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    required this.title,
    required this.meals,
  });

  final String title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) {
          final meal = meals[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(
                meal.imageUrl,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) {
                  return const Icon(Icons.fastfood);
                },
              ),
              title: Text(meal.title),
              subtitle: Text('${meal.duration} min | ${meal.complexity.name}'),
            ),
          );
        },
      ),
    );
  }
}