import 'package:flutter/material.dart';
import 'package:meals/models/category.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/meals.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    required this.category,
    super.key,
  });

  final Category category;

  void selectCategory(BuildContext context) {
    final categoryMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: categoryMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.55),
              category.color.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                // Fixed: colorScheme.onBackground is deprecated in Material3,
                // colorScheme.onSurface is the correct replacement.
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}