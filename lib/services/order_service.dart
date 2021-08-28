import 'package:freeily/global/enviroments.dart';

import 'package:freeily/responses/message_error_response.dart';
import 'package:freeily/responses/orderStoresProduct.dart';

import 'package:freeily/responses/stores_products_order.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class OrderService with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> _ordersStore = [];
  List<Order> ordersClientInitial = [];

  List<Order> ordersStoreInitial = [];

  bool _loading = false;
  bool get loading => this._loading;
  set loading(bool value) {
    this._loading = value;

    notifyListeners();
  }

  List<Order> get orders => this._orders;
  set orders(List<Order> orders) {
    this._orders = orders;

    notifyListeners();
  }

  List<Order> get ordersStore => this._ordersStore;
  set ordersStore(List<Order> orders) {
    this._ordersStore = orders;

    notifyListeners();
  }

  void orderCheckNotifiStore(String orderId) {
    final order = ordersStore.firstWhere((item) => item.id == orderId,
        orElse: () => null);
    if (order != null) order.isNotifiCheckStore = false;

    //notifyListeners();
  }

  void orderCheckNotifiClient(String orderId) {
    final order =
        orders.firstWhere((item) => item.id == orderId, orElse: () => null);
    if (order != null) order.isNotifiCheckClient = false;

    //notifyListeners();
  }

  void orderCancelByStore(String orderId) {
    final order = ordersStore.firstWhere((item) => item.id == orderId,
        orElse: () => null);

    if (order != null) order.isCancelByStore = true;

    notifyListeners();
  }

  void changePymentMethodRoCash(String orderId, String cardId) {
    final order = ordersStore.firstWhere((item) => item.id == orderId,
        orElse: () => null);

    if (order != null) order.creditCardClient = cardId;

    notifyListeners();
  }

  void orderPrepareStore(String orderId) {
    final order = ordersStore.firstWhere((item) => item.id == orderId,
        orElse: () => null);

    if (order != null) order.isPreparation = true;

    notifyListeners();
  }

  void orderDeliverStore(String orderId) {
    final order = ordersStore.firstWhere((item) => item.id == orderId,
        orElse: () => null);

    if (order != null) order.isDelivery = true;

    notifyListeners();
  }

  void orderDeliveredStore(String orderId) {
    final order = ordersStore.firstWhere((item) => item.id == orderId,
        orElse: () => null);

    if (order != null) order.isDelivered = true;

    notifyListeners();
  }

  void orderCancelByClient(String orderId) {
    final order =
        orders.firstWhere((item) => item.id == orderId, orElse: () => null);
    if (order != null) order.isCancelByClient = true;

    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();

  Future getMyOrders(String uid) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/order/orders/by/client/$uid');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final ordersResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return ordersResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future getMyOrdesStore(String uid) async {
    // this.authenticated = true;

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/order/orders/by/store/$uid');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final ordersResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return ordersResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future createOrder(String client, List<StoresProduct> storeProducts,
      String creditCardClient) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/order/create');

    final data = {
      'client': client,
      'storesProducts': storeProducts,
      'creditCardClient': creditCardClient
    };

    final token = await this._storage.read(key: 'token');

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final catalogoResponse = orderStoresProductsFromJson(resp.body);

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editOrderNotifiOrder(String orderId, bool isStore) async {
    // this.authenticated = true;

    final data = {'id': orderId, 'isStore': isStore};

    final token = await this._storage.read(key: 'token');
    final urlFinal =
        ('${Environment.apiUrl}/api/order/update/notification/order');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final orderResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return orderResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editOrderClose(String orderId, bool isStore) async {
    // this.authenticated = true;

    final data = {'id': orderId, 'isStore': isStore};

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/order/update/cancel/order');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final orderResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return orderResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editOrderPrepare(String orderId) async {
    // this.authenticated = true;

    final data = {'id': orderId};

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/order/update/prepare');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final orderResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return orderResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editOrderDelivery(String orderId) async {
    // this.authenticated = true;
    final data = {'id': orderId};

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/order/update/delivery');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final orderResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return orderResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editOrderDelivered(String orderId) async {
    // this.authenticated = true;
    final data = {'id': orderId};

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/order/update/delivered');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final orderResponse = orderStoresProductsFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return orderResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteCatalogo(String catalogoId) async {
    final token = await this._storage.read(key: 'token');

    final urlFinal = ('${Environment.apiUrl}/api/catalogo/delete/$catalogoId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionCatalogo(List<Map<String, Object>> catalogos) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/catalogo/update/position');

    final token = await this._storage.read(key: 'token');

    //final data = {'name': name, 'email': description, 'uid': uid};
    var map = {'catalogos': catalogos, 'user': ""};

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(map),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // this.rooms = roomResponse.rooms;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}
