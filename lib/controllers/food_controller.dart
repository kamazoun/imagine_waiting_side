import 'package:get/get.dart';
import 'package:imagine_waiting_side/db/drink_firestore.dart';
import 'package:imagine_waiting_side/db/food_firestore.dart';
import 'package:imagine_waiting_side/models/drink.dart';
import 'package:imagine_waiting_side/models/food.dart';

class FoodController extends GetxController {
  final RxList<Drink> _drinks = RxList<Drink>([]);
  final RxList<Food> _foods = RxList<Food>([]);

  List<Drink> get drinks => _drinks;
  List<Food> get foods => _foods;

  Map<Food, int> foodOrders = {};
  Map<Drink, int> drinkOrders = {};

  resetEverything() {
    foodOrders = {};
    drinkOrders = {};
    setAllDrinks();
    setAllFoods();
    update();
  }

  FoodController() {
    setAllDrinks();
    setAllFoods();
  }

  setAllDrinks() async {
    final d = await DrinkFirestore.getAllDrinks();
    _drinks.assignAll(d);
  }

  setAllFoods() async {
    final f = await FoodFirestore.getAllFoods();
    _foods.assignAll(f);
  }

  Future<List<Drink>> getEmptyDrinks() async {
    // Maybe take from _drinks? But what if meanwhile some drinks are updated?
    final drinks = await DrinkFirestore.getEmptyDrinks();
    return drinks;
  }

  addFoodOrder(Food food) {
    if (foodOrders.containsKey(food)) {
      foodOrders[food] = foodOrders[food]! + 1;
    } else {
      foodOrders[food] = 1;
    }

    update();
  }

  removeFoodOrder(Food food) {
    if (foodOrders.containsKey(food)) {
      foodOrders[food] = foodOrders[food]! - 1;
    }
    if (foodOrders[food] == 0) {
      foodOrders.remove(food);
    }

    update();
  }

  addDrinkOrder(Drink drink) {
    if (drinkOrders.containsKey(drink)) {
      if ((drinkOrders[drink] ?? 0) < drink.stock) {
        drinkOrders[drink] = drinkOrders[drink]! + 1;
      }
    } else {
      drinkOrders[drink] = 1;
    }

    update();
  }

  removeDrinkOrder(Drink drink) {
    if (drinkOrders.containsKey(drink)) {
      drinkOrders[drink] = drinkOrders[drink]! - 1;
    }
    if (drinkOrders[drink] == 0) {
      drinkOrders.remove(drink);
    }

    update();
  }

  clearOrders() {
    foodOrders.clear();
    drinkOrders.clear();
    update();
  }

  double getFoodTotal() {
    double total = 0.0;
    for (Food food in foodOrders.keys) {
      total += foodOrders[food]! * food.cost;
    }
    return total;
  }

  double getDrinkTotal() {
    double total = 0.0;
    for (Drink drink in drinkOrders.keys) {
      total += drinkOrders[drink]! * drink.cost;
    }
    return total;
  }

  double getTotalOrders() {
    return getFoodTotal() + getDrinkTotal();
  }

  reduceDrinkStock() {
    drinkOrders.forEach((Drink drink, quantity) {
      DrinkFirestore.setDrinkStock(drink.id, drink.stock - quantity);
    });
  }

  reduceFoodCondimentsStock() {
    foodOrders.forEach((Food food, int quantity) {
      food.portions.forEach
    });
  }
}
