import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:imagine_waiting_side/db/condiment_firestore.dart';
import 'package:imagine_waiting_side/db/drink_firestore.dart';
import 'package:imagine_waiting_side/db/food_firestore.dart';
import 'package:imagine_waiting_side/models/condiment.dart';
import 'package:imagine_waiting_side/models/drink.dart';
import 'package:imagine_waiting_side/models/food.dart';

class FoodController extends GetxController {
  final RxList<Drink> _drinks = RxList<Drink>([]);
  final RxList<Drink> _searchedDrinks = RxList<Drink>([]);
  final RxList<Condiment> _condiments = RxList<Condiment>([]);
  final RxList<Food> _foods = RxList<Food>([]);

  List<Drink> get drinks => _drinks;
  List<Drink> get searchedDrinks => _searchedDrinks;
  List<Condiment> get condiments => _condiments;
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
    setAllCondiments();
    setAllFoods();
  }

  setAllDrinks() async {
    final d = await DrinkFirestore.getAllDrinks();
    _drinks.assignAll(d);
    _searchedDrinks.assignAll(d);
  }

  setAllCondiments() async {
    final c = await CondimentFirestore.getAllCondiments();
    _condiments.assignAll(c);
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
      if (drink.stock > 0) {
        drinkOrders[drink] = 1;
      }
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

  reduceDrinkStock() async {
    drinkOrders.forEach((Drink drink, quantity) async {
      await DrinkFirestore.setDrinkStock(drink.id, drink.stock - quantity);
    });
  }

  reduceFoodCondimentsStock() async {
    foodOrders.forEach((Food food, int quantity) {
      food.portions.forEach((Condiment condiment, int condimentQuantity) async {
        await CondimentFirestore.setCondimentStock(
            condiment.id, condiment.stock - (quantity * condimentQuantity));
      });
    });
  }

  void setSearchedDrinks({String? value}) {
    if (null == value || value.isEmpty) {
      _searchedDrinks.assignAll(drinks);
      update();
      return;
    }
    _searchedDrinks.assignAll(drinks
        .where((element) =>
            element.name.toLowerCase().contains(value.trim().toLowerCase()))
        .toList());
    update();
  }
}
