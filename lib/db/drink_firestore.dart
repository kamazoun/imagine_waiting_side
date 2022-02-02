import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/models/drink.dart';

class DrinkFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _drinksRef =
      _firestore.collection('drinks').withConverter<Drink>(
            fromFirestore: (snapshot, _) =>
                Drink.fromJson(snapshot.id, snapshot.data()),
            toFirestore: (drink, _) => drink.toJson(),
          );

  static _catchError(error) =>
      Get.snackbar('An Error Occurred', 'Please try again later!');

  static Future createDrink(Drink drink) async {
    return await _drinksRef.add(drink);
  }

  static Future<List<Drink>> getAllDrinks() async {
    List<QueryDocumentSnapshot<Object?>> drinks = await _drinksRef
        .orderBy('stock')
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return drinks.map((QueryDocumentSnapshot e) => e.data() as Drink).toList();
  }

  static Future<List<Drink>> getEmptyDrinks() async {
    List<QueryDocumentSnapshot<Object?>> drinks = await _drinksRef
        .where('stock', isEqualTo: 0)
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return drinks
        .map((QueryDocumentSnapshot e) =>
            Drink.fromJson(e.id, e.data() as Map<String, dynamic>?))
        .toList();
  }

  static Future<Drink> getDrink(String id) async {
    Drink drink = await _drinksRef
        .doc(id)
        .get()
        .then((snapshot) => snapshot.data() as Drink);

    return drink;
  }

  static Future<void> setDrinkStock(String id, int stock) async {
    _drinksRef.doc(id).update({'stock': stock});
  }
}
