import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/food_controller.dart';
import 'package:imagine_waiting_side/controllers/order_controller.dart';
import 'package:imagine_waiting_side/models/drink.dart';
import 'package:imagine_waiting_side/models/food.dart';
import 'package:imagine_waiting_side/models/order.dart';

class SeeOrders extends StatelessWidget {
  final String waiterId;

  const SeeOrders({Key? key, required this.waiterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<OrderController>(
        builder: (orderController) => FutureBuilder<List<Order>>(
          future: orderController.getWaiterOrders(waiterId),
          builder: (_, futureSnapshot) {
            if (futureSnapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Order>? orders = futureSnapshot.data;

            if (null == orders) {
              return const Center(child: Text('No orders yet!'));
            }
            return ListView.separated(
              itemBuilder: (_, index) => DataTable(columns: [
                const DataColumn(label: Text('Items')),
                DataColumn(
                    label: Text(
                        orders[index].at.toIso8601String().substring(0, 16))),
              ], rows: _buildOrderRows(orders[index])),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 30),
            );
          },
        ),
      ),
    );
  }

  List<DataRow> _buildOrderRows(Order order) {
    final FoodController foodController = Get.find<FoodController>();
    final List<DataRow> r = [];

    for (final entry in order.foodItems.entries) {
      final Food? food = foodController.foods
          .firstWhereOrNull((element) => element.id == entry.key);
      if (null == food) {
        continue;
      }
      r.add(DataRow(cells: [
        DataCell(Text(food.name)),
        DataCell(Text('${entry.value}'))
      ]));
    }

    for (final entry in order.drinkItems.entries) {
      final Drink? drink = foodController.drinks
          .firstWhereOrNull((element) => element.id == entry.key);
      if (null == drink) {
        continue;
      }
      r.add(DataRow(cells: [
        DataCell(Text(drink.name)),
        DataCell(Text('${entry.value}'))
      ]));
    }

    return r;
  }
}
