import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/employee_controller.dart';
import 'package:imagine_waiting_side/screens/select_foods.dart';
import 'package:imagine_waiting_side/screens/widgets/waiter_grid.dart';

class SelectWaiter extends StatelessWidget {
  const SelectWaiter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmployeeController employeeController =
        Get.find<EmployeeController>();
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<EmployeeController>(
          builder: (employeeController) => Text(
              'Place order for: ${employeeController.selectedWaiter?.name ?? ''}'),
        ),
        actions: [
          GetBuilder<EmployeeController>(
            builder: (employeeController) => IconButton(
                onPressed: null != employeeController.selectedWaiter
                    ? () {
                        Get.to(() => const SelectFoods());
                      }
                    : null,
                icon: const Icon(Icons.next_plan)),
          )
        ],
      ),
      body: GetX<EmployeeController>(
        builder: (employeeController) => GridView.builder(
            itemCount: employeeController.waiters.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kIsWeb ? 5 : 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 50),
            itemBuilder: (_, index) =>
                WaiterGrid(waiter: employeeController.waiters[index])),
      ),
    );
  }
}
