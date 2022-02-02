import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imagine_waiting_side/controllers/employee_controller.dart';
import 'package:imagine_waiting_side/models/waiter.dart';
import 'package:imagine_waiting_side/screens/select_foods.dart';

class WaiterGrid extends StatelessWidget {
  const WaiterGrid({Key? key, required this.waiter}) : super(key: key);

  final Waiter waiter;

  @override
  Widget build(BuildContext context) {
    final EmployeeController employeeController =
        Get.find<EmployeeController>();
    return InkWell(
      onTap: () {
        employeeController.setSelectedWaiter(waiter);
      },
      onDoubleTap: () {
        employeeController.setSelectedWaiter(waiter);
        Get.to(() => const SelectFoods());
      },
      child: GetBuilder<EmployeeController>(
        builder: (employeeController) => Container(
          margin: employeeController.selectedWaiter?.id == waiter.id
              ? const EdgeInsets.all(1)
              : const EdgeInsets.all(15),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.pink],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
              borderRadius: BorderRadius.circular(25.5)),
          child: Center(
              child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: waiter.gender ? Colors.blue : Colors.pink,
                        size: employeeController.selectedWaiter?.id == waiter.id
                            ? 75
                            : 25,
                      ),
                      Text(
                        waiter.name,
                        style: TextStyle(
                            fontSize: employeeController.selectedWaiter?.id ==
                                    waiter.id
                                ? 50
                                : 25,
                            color: employeeController.selectedWaiter?.id ==
                                    waiter.id
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
