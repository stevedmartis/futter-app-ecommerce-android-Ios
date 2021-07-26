import 'package:australti_ecommerce_app/global/enviroments.dart';
import 'package:australti_ecommerce_app/responses/category_store_response.dart';
import 'package:australti_ecommerce_app/responses/message_error_response.dart';
import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';

import 'package:australti_ecommerce_app/responses/stores_products_order.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class OrderService with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> ordersInitial = [];

  bool _loading = true;
  bool get loading => this._loading;
  set loading(bool value) {
    this._loading = value;
  }

  List<Order> get orders => this._orders;
  set orders(List<Order> orders) {
    this._orders = orders;
    this._loading = false;

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

  Future createOrder(String client, List<StoresProduct> storeProducts) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/order/create');

    final data = {
      'client': client,
      'storesProducts': storeProducts,
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

  Future editCatalogo(ProfileStoreCategory category) async {
    // this.authenticated = true;

    final data = {
      'id': category.id,
      'description': category.description,
      'name': category.name,
      'position': category.position,
      'uid': category.store.user.uid,
      'visibility': category.visibility,
    };

    final token = await this._storage.read(key: 'token');
    final urlFinal = ('${Environment.apiUrl}/api/catalogo/update/catalogo');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = categoryResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
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
