import 'package:australti_ecommerce_app/models/grocery_Store.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_product.dart';

enum GroceryState {
  normal,
  details,
  cart,
}

class GroceryStoreBLoC with ChangeNotifier {
  GroceryState groceryState = GroceryState.normal;
  List<GroceryProduct> catalog = List.unmodifiable(groceryProducts);
  List<GroceryProductItem> cart = [];
  bool isReload = true;

  final prefs = new AuthUserPreferences();

  void changeToCart() {
    groceryState = GroceryState.cart;
    notifyListeners();
  }

  void changeToNormal() {
    groceryState = GroceryState.normal;
    notifyListeners();
  }

  void changeReaload() {
    isReload = false;
    //notifyListeners();
  }

  void changeToDetails() {
    groceryState = GroceryState.details;
    notifyListeners();
  }

  void cartSavetoCart(List<GroceryProductItem> cartSave) {
    cart = cartSave;
    notifyListeners();
  }

  void deleteProduct(GroceryProductItem productItem) {
    cart.remove(productItem);
    totalPriceElements();
    isReload = false;
    prefs.setCart = cart;
    notifyListeners();
  }

  void emptyCart() {
    cart = [];
    totalPriceElements();
    isReload = false;
    prefs.setCart = cart;
    notifyListeners();
  }

  double getTotalCartElements() {
    return cart.fold<double>(
      0.0,
      (previousValue, element) =>
          previousValue + (element.quantity * element.product.price),
    );
  }

  void addProduct(ProfileStoreProduct product, int quantity) {
    for (GroceryProductItem item in cart) {
      if (item.product.name == product.name) {
        item.increment(quantity);
        notifyListeners();
        return;
      }
    }

    cart.add(GroceryProductItem(
      product: product,
      quantity: quantity,
    ));

    prefs.setCart = cart;
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

  int totalPriceCart() => cart.fold<int>(
        0,
        (previousValue, element) =>
            previousValue + (element.quantity * element.product.price),
      );
}

final groceryStoreBloc = GroceryStoreBLoC();
