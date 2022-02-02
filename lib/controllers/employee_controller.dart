import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/db/waiter_firestore.dart';
import 'package:imagine_waiting_side/models/waiter.dart';

class EmployeeController extends GetxController {
  final RxList<Waiter> _waiters = RxList<Waiter>([]);

  List<Waiter> get waiters => _waiters;

  Waiter? selectedWaiter;

  resetEverything() {
    selectedWaiter = null;
    update();
  }

  EmployeeController() {
    _setAllWaiters();
  }

  _setAllWaiters() async {
    final d = await WaiterFirestore.getAllWaiters();
    _waiters.assignAll(d);
    print(waiters.length);
  }

  createWaiter(Waiter waiter) async {
    final DocumentReference r = await WaiterFirestore.createWaiter(waiter);
    _waiters.add(waiter.copyWith(id: r.id));

    update(); // Surprisingly without that, after adding GetX does not automatically refresh.
  }

  setSelectedWaiter(Waiter w) {
    selectedWaiter = w;
    update();
  }
}
