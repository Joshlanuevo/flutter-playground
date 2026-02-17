import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_state_management/data/dummy_data.dart';

final mealsPProvider = Provider((ref) {
  return dummyMeals;
});