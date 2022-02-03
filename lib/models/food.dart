import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';
import 'package:imagine_waiting_side/models/condiment.dart';

final localizedFoodCategory = {
  FoodCategory.defaultCategory: 'default',
  FoodCategory.starters: 'starters',
  FoodCategory.mainMeals: 'main meals',
  FoodCategory.sides: 'sides',
  FoodCategory.desserts: 'desserts',
};

enum FoodCategory { defaultCategory, starters, mainMeals, sides, desserts }

class Food {
  final String id;
  final String name;
  final FoodCategory category;
  final double cost;
  final DateTime time;
  final Map<Condiment, int>
      portions; // id of item and quantity. Ex meat: 3 portions

  Food(
      {required this.id,
      required this.name,
      required this.category,
      required this.cost,
      required this.time,
      required this.portions});

  Food.fromJson(String id, Map<String, dynamic> json)
      : this(
            id: id,
            name: json['name'] as String,
            category: FoodCategory.values[(json['category'] as int)],
            cost: json['cost'] as double,
            time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int),
            portions: _buildPortions(json['portions'] as Map<String, dynamic>));

  Food copyWith({id, name, category, cost, time, stock, portions}) {
    return Food(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        cost: cost ?? this.cost,
        time: time ?? this.time,
        portions: portions ?? this.portions);
  }

  static Map<Condiment, int> _buildPortions(Map<String, dynamic> data) {
    final FoodController foodController = Get.find<FoodController>();

    Map<Condiment, int> r = {};
    for (MapEntry<String, dynamic> entry in data.entries) {
      final Condiment? c = foodController.condiments
          .firstWhereOrNull((element) => element.id == entry.key.trim());

      if (null != c) {
        r.addAll({c: int.parse(entry.value.toString())});
      }
    }
    return r;
  }
}
