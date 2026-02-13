import 'package:flutter/material.dart';

import 'package:meals/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    required this.category, 
    super.key
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Text(category.title);
  }
}