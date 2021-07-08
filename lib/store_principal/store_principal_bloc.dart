import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/responses/search_stores_products_response.dart';
import 'package:australti_ecommerce_app/services/stores_Services.dart';

import 'package:australti_ecommerce_app/store_principal/store_Service.dart';
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

  List<Store> storesSearch = [];

  List<ProfileStoreProduct> productsSearch = [];

  final storeService = StoreService();

  List<StoreServices> servicesStores = [
    StoreServices(
        id: 1,
        backImage: 'assets/frutas_verduras3.jpeg',
        frontImage: 'assets/frutas_verduras3.jpeg',
        name: 'Mercados',
        stores: 0),
    StoreServices(
        id: 2,
        backImage: 'assets/rest6.jpg',
        frontImage: 'assets/rest6.jpg',
        name: 'Restaurantes',
        stores: 0),
    StoreServices(
        id: 3,
        backImage: 'assets/licores1.jpeg',
        frontImage: 'assets/licores1.jpeg',
        name: 'Licores',
        stores: 0)
  ];

  List<GroceryProductItem> cart = [];
  final notifierTotal = ValueNotifier(1);
  // final notifierBottom = ValueNotifier<bool>(true);
  final ValueNotifier<bool> notifierBottom = ValueNotifier(true);
  bool isVisible = showBottomInit;

  Store _storeCurrent;

  void searchStoresOrProductsByQuery(String value) async {
    if (value.length >= 3) {
      final SearchStoresProductsListResponse resp =
          await storeService.getStoreAndProductsByValue(value);

      if (resp.ok) {
        storesSearch = resp.storesSearch;
        productsSearch = resp.productsSearch;

        notifyListeners();
      }
    }
  }

  void chargeServicesStores() {
    final markets = storesListInitial.where((i) => i.service == 1).toList();

    final restaurants = storesListInitial.where((i) => i.service == 2).toList();

    final liquers = storesListInitial.where((i) => i.service == 3).toList();

    servicesStores[0].stores = markets.length;

    servicesStores[1].stores = restaurants.length;
    servicesStores[2].stores = liquers.length;
  }

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
