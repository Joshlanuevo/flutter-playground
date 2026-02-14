import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  // Reuse the same helpers from MealItem for consistency
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsible hero image app bar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                meal.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      blurRadius: 6,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: meal.id,
                child: Image.network(
                  meal.imageUrl,
                  fit: BoxFit.cover,
                  // Dim the image slightly so the title text remains legible
                  color: Colors.black.withOpacity(0.25),
                  colorBlendMode: BlendMode.darken,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: colorScheme.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (ctx, _, __) => Container(
                    color: colorScheme.surfaceVariant,
                    child: const Center(child: Icon(Icons.fastfood, size: 60)),
                  ),
                ),
              ),
            ),
          ),

          // ── Body content ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Quick-stats row ──────────────────────────────────────
                  _SectionCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.schedule,
                          value: '${meal.duration} min',
                          label: 'Duration',
                        ),
                        _VerticalDivider(),
                        _StatItem(
                          icon: Icons.bar_chart,
                          value: complexityText,
                          label: 'Complexity',
                        ),
                        _VerticalDivider(),
                        _StatItem(
                          icon: Icons.attach_money,
                          value: affordabilityText,
                          label: 'Cost',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Dietary badges ───────────────────────────────────────
                  if (meal.isGlutenFree ||
                      meal.isVegan ||
                      meal.isVegetarian ||
                      meal.isLactoseFree) ...[
                    _SectionCard(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (meal.isGlutenFree)
                            _DietBadge(label: 'Gluten-Free', colorScheme: colorScheme),
                          if (meal.isVegan)
                            _DietBadge(label: 'Vegan', colorScheme: colorScheme),
                          if (meal.isVegetarian && !meal.isVegan)
                            _DietBadge(label: 'Vegetarian', colorScheme: colorScheme),
                          if (meal.isLactoseFree)
                            _DietBadge(label: 'Lactose-Free', colorScheme: colorScheme),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Ingredients ─────────────────────────────────────────
                  _SectionHeader(title: 'Ingredients', icon: Icons.shopping_basket_outlined),
                  const SizedBox(height: 8),
                  _SectionCard(
                    child: Column(
                      children: [
                        for (int i = 0; i < meal.ingredients.length; i++) ...[
                          _IngredientRow(
                            index: i + 1,
                            text: meal.ingredients[i],
                            colorScheme: colorScheme,
                          ),
                          if (i < meal.ingredients.length - 1)
                            Divider(
                              height: 1,
                              indent: 40,
                              color: colorScheme.outlineVariant.withOpacity(0.4),
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Steps ────────────────────────────────────────────────
                  _SectionHeader(title: 'Instructions', icon: Icons.format_list_numbered),
                  const SizedBox(height: 8),
                  ...meal.steps.asMap().entries.map(
                    (entry) => _StepTile(
                      step: entry.key + 1,
                      text: entry.value,
                      isLast: entry.key == meal.steps.length - 1,
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: colorScheme.onSurface.withOpacity(0.55),
              ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
    );
  }
}

class _DietBadge extends StatelessWidget {
  const _DietBadge({required this.label, required this.colorScheme});
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.index,
    required this.text,
    required this.colorScheme,
  });
  final int index;
  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.step,
    required this.text,
    required this.isLast,
    required this.colorScheme,
  });
  final int step;
  final String text;
  final bool isLast;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number + connecting line
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$step',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: colorScheme.primary.withOpacity(0.25),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Step text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 6),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}