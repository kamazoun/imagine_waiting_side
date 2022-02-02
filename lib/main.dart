import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/screens/select_waiter.dart';

import 'controllers/auth.dart';
import 'controllers/employee_controller.dart';
import 'controllers/food_controller.dart';
import 'controllers/order_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthController());
  Get.put(FoodController());
  Get.put(OrderController());
  Get.put(EmployeeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Imagine Bar Inventory Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectWaiter(),
    );
  }
}
