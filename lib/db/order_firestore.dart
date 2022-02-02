import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/models/order.dart';

class OrderFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _ordersRef =
      _firestore.collection('orders').withConverter<Order>(
            fromFirestore: (snapshot, _) => Order.fromJson(
                snapshot.id, snapshot.data() as Map<String, dynamic>),
            toFirestore: (order, _) => order.toJson(),
          );

  static _catchError(error) =>
      Get.snackbar('An Error Occurred', 'Please try again later!');

  static Future createOrder(Order order) async {
    print('CREANTE ORDERS ');
    return await _ordersRef.add(order);
  }

  static Future<List<Order>> getAllOrders() async {
    List<QueryDocumentSnapshot<Object?>> orders = await _ordersRef
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return orders.map((QueryDocumentSnapshot e) => e.data() as Order).toList();
  }

  static Future<List<Order>> getUnpaidOrders() async {
    List<QueryDocumentSnapshot<Object?>> orders = await _ordersRef
        .where('paid', isEqualTo: false)
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return orders
        .map((QueryDocumentSnapshot e) =>
            Order.fromJson(e.id, e.data() as Map<String, Object>))
        .toList();
  }

  static Future<Order> getOrder(String id) async {
    final Order order = await _ordersRef
        .doc(id)
        .get()
        .then((snapshot) => snapshot.data() as Order);

    return order;
  }
}
