import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';
import 'package:imagine_waiting_side/models/drink.dart';

class DrinkOrdersListItem extends StatelessWidget {
  const DrinkOrdersListItem({Key? key, required this.drink}) : super(key: key);

  final Drink drink;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodController>(
      builder: (foodController) => ListTile(
        leading: IconButton(
            onPressed: () {
              foodController.removeDrinkOrder(drink);
            },
            icon: const Icon(Icons.remove)),
        title:
            Text(drink.name + ' (${foodController.drinkOrders[drink] ?? 0})'),
        subtitle: Text(
            'Only ${drink.stock - (foodController.drinkOrders[drink] ?? 0)} remaining'),
        trailing: IconButton(
            onPressed: () {
              foodController.addDrinkOrder(drink);
            },
            icon: const Icon(Icons.add)),
      ),
    );
  }
}
