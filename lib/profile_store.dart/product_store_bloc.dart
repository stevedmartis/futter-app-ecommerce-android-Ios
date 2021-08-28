import 'package:flutter/material.dart';
import 'package:freeily/grocery_store/grocery_product.dart';

enum GroceryState {
  normal,
  details,
  cart,
}

class GroceryStoreBLoC with ChangeNotifier {
  GroceryState groceryState = GroceryState.normal;
  List<GroceryProduct> catalog = List.unmodifiable(groceryProducts);
  List<GroceryProductItem> cart = [];

  void changeToNormal() {
    groceryState = GroceryState.normal;
    notifyListeners();
  }

  void changeToCart() {
    groceryState = GroceryState.cart;
    notifyListeners();
  }

  void changeToDetails() {
    groceryState = GroceryState.details;
    notifyListeners();
  }

  void deleteProduct(GroceryProductItem productItem) {
    cart.remove(productItem);
    notifyListeners();
  }

  void addProduct(GroceryProduct product, int quantity) {
    for (GroceryProductItem item in cart) {
      if (item.product.name == product.name) {
        item.increment(quantity);
        notifyListeners();
        return;
      }
    }
    cart.add(GroceryProductItem(product: product, quantity: quantity));
    notifyListeners();
  }

  int totalCartElements() => cart.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );

  double totalPriceElements() => cart.fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue + (element.quantity * element.product.price),
      );
}

class GroceryProductItem {
  GroceryProductItem({this.quantity = 1, @required this.product});
  int quantity;
  final GroceryProduct product;

  void increment(int newQuantity) {
    quantity += newQuantity;
  }
}
