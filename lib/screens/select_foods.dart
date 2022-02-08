import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';
import 'package:imagine_waiting_side/models/food.dart';
import 'package:imagine_waiting_side/screens/select_drinks.dart';
import 'package:imagine_waiting_side/screens/widgets/food_orders_list_item.dart';

class SelectFoods extends StatelessWidget {
  const SelectFoods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FoodController foodController = Get.find<FoodController>();

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<FoodController>(
            builder: (foodController) =>
                Text('Food orders: ${foodController.foodOrders.length}')),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const SelectDrinks());
              },
              icon: const Icon(Icons.next_plan))
        ],
      ),
      body: Padding(
        padding: kIsWeb
            ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30)
            : const EdgeInsets.all(1.0),
        child: ListView.builder(
          itemBuilder: (_, index) {
            return FoodOrdersListItem(food: foodController.foods[index]);
          },
          itemCount: foodController.foods.length,
        ),
      ),
    );
  }
}
