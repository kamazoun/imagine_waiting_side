import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/models/waiter.dart';

class WaiterFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _waitersRef =
      _firestore.collection('waiters').withConverter<Waiter>(
            fromFirestore: (snapshot, _) => Waiter.fromJson(
                snapshot.id, snapshot.data() as Map<String, dynamic>),
            toFirestore: (waiter, _) => waiter.toJson(),
          );

  static _catchError(error) =>
      Get.snackbar('An Error Occurred', 'Please try again later!');

  static Future createWaiter(Waiter waiter) async {
    return await _waitersRef.add(waiter);
  }

  static Future<List<Waiter>> getAllWaiters() async {
    List<QueryDocumentSnapshot<Object?>> waiters = await _waitersRef
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return waiters
        .map((QueryDocumentSnapshot e) => e.data() as Waiter)
        .toList();
  }

  static Future<Waiter> getWaiter(String id) async {
    final Waiter waiter = await _waitersRef
        .doc(id)
        .get()
        .then((snapshot) => snapshot.data() as Waiter);

    return waiter;
  }
}
