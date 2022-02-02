import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';
import 'package:imagine_waiting_side/models/food.dart';

class FoodOrdersListItem extends StatelessWidget {
  const FoodOrdersListItem({Key? key, required this.food}) : super(key: key);

  final Food food;
  @override
  Widget build(BuildContext context) {
    final FoodController foodController = Get.find<FoodController>();

    return GetBuilder<FoodController>(
      builder: (foodController) => ListTile(
        leading: IconButton(
            onPressed: () {
              foodController.removeFoodOrder(food);
            },
            icon: const Icon(Icons.remove)),
        title: Text(food.name + ' (${foodController.foodOrders[food] ?? 0})'),
        subtitle: Text('price: ${food.cost}'),
        trailing: IconButton(
            onPressed: () {
              foodController.addFoodOrder(food);
            },
            icon: const Icon(Icons.add)),
      ),
    );
  }
}
