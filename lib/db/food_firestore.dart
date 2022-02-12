import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/models/condiment.dart';
import 'package:imagine_waiting_side/models/food.dart';

class FoodFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _foodsRef = _firestore
      .collection('foods')
      .withConverter<Food>(
        fromFirestore: (snapshot, _) =>
            Food.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>),
        toFirestore: (food, _) => {},
      );

  static _catchError(error) =>
      Get.snackbar('An Error Occurred', 'Please try again later!');

  static Future createFood(Food food) async {
    return await _foodsRef.add(food);
  }

  static Future<List<Food>> getAllFoods() async {
    List<QueryDocumentSnapshot<Object?>> foods = await _foodsRef
        .orderBy('name')
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return foods.map((QueryDocumentSnapshot e) => e.data() as Food).toList();
  }

  static Future<List<Food>> getEmptyFoodsWithEmptyCondiments(
      List<Condiment> finishedCondiment) async {
    List<QueryDocumentSnapshot<Object?>> foods = await _foodsRef
        .where('portions[0]', whereIn: finishedCondiment)
        .get()
        .then((QuerySnapshot<Object?> snapshot) => snapshot.docs);

    return foods
        .map((QueryDocumentSnapshot e) =>
            Food.fromJson(e.id, e.data() as Map<String, Object>))
        .toList();
  }

  static Future<Food> getFood(String id) async {
    Food food = await _foodsRef
        .doc(id)
        .get()
        .then((snapshot) => snapshot.data() as Food);

    return food;
  }
}
