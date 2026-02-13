import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
  });

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  // Helper to capitalize the first letter of enum names (e.g. 'simple' -> 'Simple')
  String get complexityText {
    final name = meal.complexity.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  String get affordabilityText {
    final name = meal.affordability.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.hardEdge, // ensures image respects card border radius
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onSelectMeal(meal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal image — no local asset needed
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                // Shows a progress indicator while the image fetches
                loadingBuilder: (ctx, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                // Falls back to an icon if the URL fails
                errorBuilder: (ctx, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Center(
                      child: Icon(Icons.fastfood, size: 60),
                    ),
                  );
                },
              ),
            ),
            // Meal info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    meal.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Duration, complexity, affordability row
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.schedule,
                        label: '${meal.duration} min',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.bar_chart,
                        label: complexityText,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.attach_money,
                        label: affordabilityText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Dietary badges
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (meal.isGlutenFree)
                        _DietBadge(label: 'Gluten-Free'),
                      if (meal.isVegan)
                        _DietBadge(label: 'Vegan'),
                      if (meal.isVegetarian && !meal.isVegan)
                        _DietBadge(label: 'Vegetarian'),
                      if (meal.isLactoseFree)
                        _DietBadge(label: 'Lactose-Free'),
                    ],
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

// Small icon + text chip for meal metadata
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

// Colored badge for dietary info
class _DietBadge extends StatelessWidget {
  const _DietBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}