import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/db/drink_firestore.dart';
import 'package:imagine_waiting_side/db/order_firestore.dart';
import 'package:imagine_waiting_side/models/order.dart';

class OrderController extends GetxController {
  final RxList<Order> _orders = RxList<Order>([]);

  List<Order> get orders => _orders;

  OrderController() {
    setAllOrders();
  }

  setAllOrders() async {
    final d = await OrderFirestore.getAllOrders();
    _orders.assignAll(d);
  }

  createOrder(Order order) async {
    final DocumentReference r = await OrderFirestore.createOrder(order);
    _orders.add(order.copyWith(id: r.id));

    update(); // Surprisingly without that, after adding GetX does not automatically refresh.
  }

  Future<List<Order>> getWaiterOrders(String waiterId) async {
    List<Order>? r = await OrderFirestore.getWaiterOrders(waiterId);

    if (null == r || r.isEmpty) {
      r = orders.where((element) => element.waiterId == waiterId).toList();
    }
    return r;
  }
}
