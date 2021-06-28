import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';

enum StoreState {
  restaurant,
  market,
  liqueur,
}
const showBottomInit = true;

class StoreBLoC with ChangeNotifier {
  StoreState storeState = StoreState.restaurant;
  List<Store> storesListState = [];

  List<Store> storesListInitial = [];

  List<GroceryProductItem> cart = [];
  final notifierTotal = ValueNotifier(1);
  // final notifierBottom = ValueNotifier<bool>(true);
  final ValueNotifier<bool> notifierBottom = ValueNotifier(true);
  bool isVisible = showBottomInit;

  Store _storeCurrent;

  void changeToRestaurant() {
    storeState = StoreState.restaurant;

    final newList = storesListInitial.where((i) => i.service == 2).toList();

    storesListState = newList;
    notifierTotal.value = 2;
    notifyListeners();
  }

  void bottomNavigation(bool showBottom) {
    notifierBottom.value = showBottom;

    isVisible = showBottom;
    notifyListeners();
  }

  Store get currentStore => this._storeCurrent;

  set currentStore(Store valor) {
    this._storeCurrent = valor;
    //notifyListeners();
  }

  void changeToMarket() {
    storeState = StoreState.market;

    final newList = storesListInitial.where((i) => i.service == 1).toList();

    storesListState = newList;

    notifierTotal.value = 1;
    notifyListeners();
  }

  Store getStoreByProducts(String storeId) {
    final store = storesListInitial.singleWhere((i) => i.user.uid == storeId);

    return store;
  }

  Store getProductsByStore(String storeId) {
    final store = storesListInitial.singleWhere((i) => i.user.uid == storeId);

    return store;
  }

  void charge() {}

  void changeToLiqueur() {
    storeState = StoreState.liqueur;

    final newList = storesListInitial.where((i) => i.service == 3).toList();

    storesListState = newList;
    notifierTotal.value = 3;
    notifyListeners();
  }

  void deleteProduct(GroceryProductItem productItem) {
    cart.remove(productItem);
    notifyListeners();
  }
}

class GroceryProductItem {
  GroceryProductItem({this.quantity = 1, @required this.product});
  int quantity;
  final ProfileStoreProduct product;

  void increment(int newQuantity) {
    quantity += newQuantity;
  }
}

final storeBloc = StoreBLoC();
