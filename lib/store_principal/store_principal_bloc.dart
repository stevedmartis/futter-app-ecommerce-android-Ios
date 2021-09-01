import 'package:freeily/models/store.dart';
import 'package:freeily/preferences/user_preferences.dart';
import 'package:freeily/responses/bank_account.dart';

import 'package:freeily/services/stores_Services.dart';

import 'package:freeily/store_principal/store_Service.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';

enum StoreState { restaurant, market, liqueur, followed }
const showBottomInit = true;

class StoreBLoC with ChangeNotifier {
  StoreState storeState = StoreState.restaurant;
  List<Store> storesListState = [];

  List<Store> storesAllDb = [];
  List<Store> storesListInitial = [];

  List<Store> storesSearch = [];
  List<BankAccount> bankAccountsByStore = [];

  BankAccount currentBankAccount;

  StoreServices selected;

  List<ProfileStoreProduct> productsSearch = [];
  final prefs = new AuthUserPreferences();
  bool loadingStores = false;

  final storeService = StoreService();

  bool loadingSearch = false;
  bool initialSearch = true;

  List<StoreServices> servicesStores = [
    StoreServices(
        id: 0,
        backImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/headers/followed_header.png',
        frontImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/mini/followed_mini.png',
        name: 'Seguidos',
        stores: 0),
    StoreServices(
        id: 1,
        backImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/headers/market_header.png',
        frontImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/mini/mark_mini.png',
        name: 'Mercados',
        stores: 0),
    StoreServices(
        id: 2,
        backImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/headers/rest_header.png',
        frontImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/mini/rest_mini.png',
        name: 'Restaurantes',
        stores: 0),
    StoreServices(
        id: 3,
        backImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/headers/licor_header.png',
        frontImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/mini/licor_mini.png',
        name: 'Licores',
        stores: 0),
    StoreServices(
        id: 4,
        backImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/headers/moda_header-png.png',
        frontImage:
            'https://freeily-images.s3.amazonaws.com/principal_stores/mini/moda_mini.png',
        name: 'Moda',
        stores: 0)
  ];

  List<GroceryProductItem> cart = [];
  final notifierTotal = ValueNotifier(1);
  // final notifierBottom = ValueNotifier<bool>(true);
  final ValueNotifier<bool> notifierBottom = ValueNotifier(true);
  bool isVisible = showBottomInit;

  Store _storeCurrent;

  void searchStoresOrProductsByQuery(String value, String uid) async {
    if (value.length >= 2) {
      loadingSearch = true;

      final resp = await storeService.getStoreAndProductsByValue(value, uid);

      if (resp.ok) {
        storesSearch = resp.storesSearch;
        productsSearch = resp.productsSearch;

        loadingSearch = false;

        notifyListeners();
      }
    } else {
      loadingSearch = false;

      storesSearch = storesListInitial;
      productsSearch = [];
      notifyListeners();
    }
  }

  void addFallowed() {
    final item = servicesStores.where((i) => i.id == 0);
    item.single.stores++;

    notifyListeners();
  }

  void removeFallowed() {
    final item = servicesStores.where((i) => i.id == 0);
    item.single.stores--;

    if (item.single.stores == 0) selected = servicesStores[1];
    notifyListeners();
  }

  void chargeServicesStores(List<Store> storesList) {
    storesListInitial = storesList;
    final markets = storesListInitial.where((i) => i.service == 1).toList();

    final restaurants = storesListInitial.where((i) => i.service == 2).toList();

    final liquers = storesListInitial.where((i) => i.service == 3).toList();

    final modas = storesListInitial.where((i) => i.service == 4).toList();

    final followed =
        storesListInitial.where((i) => i.isFollowing == true).toList();

    final followedService = servicesStores.firstWhere((i) => i.id == 0);

    followedService.stores = followed.length;
    prefs.followed = followed.length;

    final marketService = servicesStores.firstWhere((i) => i.id == 1);

    marketService.stores = markets.length;

    final restService = servicesStores.firstWhere((i) => i.id == 2);

    restService.stores = restaurants.length;

    final liquerService = servicesStores.firstWhere((i) => i.id == 3);

    liquerService.stores = liquers.length;

    final modaService = servicesStores.firstWhere((i) => i.id == 4);

    modaService.stores = modas.length;
    storesSearch = storesListInitial;
    initialSearch = false;

    changeToFollowed();

    selected = followedService;

    loadingStores = true;

    notifyListeners();
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
    final Store store = storesListInitial
        .singleWhere((i) => i.user.uid == storeId, orElse: () => null);

    return store;
  }

  Store getStoreAllDbByProducts(String storeId) {
    final Store store = storesAllDb.singleWhere((i) => i.user.uid == storeId,
        orElse: () => null);

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

  void changeToFollowed() {
    storeState = StoreState.followed;

    final followed =
        storesListInitial.where((i) => i.isFollowing == true).toList();

    storesListState = followed;
    notifierTotal.value = 0;
    notifyListeners();
  }

  void changeToModa() {
    storeState = StoreState.market;

    final newList = storesListInitial.where((i) => i.service == 4).toList();

    storesListState = newList;

    notifierTotal.value = 1;

    notifyListeners();
  }

  void deleteProduct(GroceryProductItem productItem) {
    cart.remove(productItem);
    notifyListeners();
  }

  void favoriteProduct(ProfileStoreProduct product, bool like) {
    final item = productsSearch.firstWhere((item) => item.id == product.id,
        orElse: () => null);

    if (item != null) item.isLike = like;

    notifyListeners();
  }

  void addBanksAccountStoresOrder(BankAccount bankAccount) {
    bankAccountsByStore.add(bankAccount);
    notifyListeners();
  }

  void currentBankAccountStorePaymentMethod(BankAccount bankAccount) {
    currentBankAccount = bankAccount;
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
