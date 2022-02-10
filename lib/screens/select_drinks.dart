import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/employee_controller.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';
import 'package:imagine_waiting_side/controllers/order_controller.dart';
import 'package:imagine_waiting_side/models/order.dart';
import 'package:imagine_waiting_side/screens/select_waiter.dart';
import 'package:imagine_waiting_side/screens/widgets/drink_orders_list_item.dart';

class SelectDrinks extends StatelessWidget {
  const SelectDrinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FoodController foodController = Get.find<FoodController>();

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<FoodController>(
            builder: (foodController) =>
                Text('Drink orders: ${foodController.drinkOrders.length}')),
        actions: [
          IconButton(onPressed: passOrder, icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: kIsWeb
            ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30)
            : const EdgeInsets.all(1.0),
        child: ListView.builder(
          itemBuilder: (_, index) {
            return DrinkOrdersListItem(drink: foodController.drinks[index]);
          },
          itemCount: foodController.drinks.length,
        ),
      ),
    );
  }

  passOrder() {
    final foodController = Get.find<FoodController>();
    final orderController = Get.find<OrderController>();
    final employeeController = Get.find<EmployeeController>();

    Order order = Order(
      id: '',
      waiterId: employeeController.selectedWaiter?.id ?? '',
      waiterName: employeeController.selectedWaiter?.name ?? '',
      at: DateTime.now(),
      served: false,
      paid: false,
      total: foodController.getTotalOrders(),
      drinkItems: foodController.drinkOrders
          .map((key, value) => MapEntry(key.id, value)),
      foodItems: foodController.foodOrders
          .map((key, value) => MapEntry(key.id, value)),
    );

    if (order.drinkItems.isEmpty && order.foodItems.isEmpty) {
      return;
    }
    orderController.createOrder(order);

    foodController.reduceDrinkStock();
    foodController.reduceFoodCondimentsStock();

    foodController.resetEverything();
    employeeController.resetEverything();

    Get.to(() => const SelectWaiter());
  }
}
