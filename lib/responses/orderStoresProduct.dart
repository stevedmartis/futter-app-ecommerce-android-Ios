// To parse this JSON data, do
//
//     final orderStoresProducts = orderStoresProductsFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/models/store.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';

OrderStoresProducts orderStoresProductsFromJson(String str) =>
    OrderStoresProducts.fromJson(json.decode(str));

String orderStoresProductsToJson(OrderStoresProducts data) =>
    json.encode(data.toJson());

class OrderStoresProducts {
  OrderStoresProducts({
    this.ok,
    this.orders,
  });

  bool ok;
  List<Order> orders;

  factory OrderStoresProducts.fromJson(Map<String, dynamic> json) =>
      OrderStoresProducts(
        ok: json["ok"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.id,
    this.store,
    this.client,
    this.creditCardClient,
    this.products,
    this.isActive,
    this.isFinalice,
    this.isPreparation,
    this.isDelivery,
    this.isCancelByStore,
    this.isCancelByClient,
    this.isDelivered,
    this.isNotifiCheckStore,
    this.isNotifiCheckClient,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  Store store;
  String client;
  String creditCardClient;
  List<ProductElement> products;
  bool isActive;
  bool isFinalice;
  bool isCancelByStore;
  bool isCancelByClient;
  bool isNotifiCheckStore;
  bool isNotifiCheckClient;

  DateTime createdAt;
  DateTime updatedAt;

  bool isPreparation;
  bool isDelivery;
  bool isDelivered;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        store: Store.fromJson(json["store"]),
        client: json["client"],
        creditCardClient: json["creditCardClient"],
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
        isActive: json["isActive"],
        isFinalice: json["isFinalice"],
        isCancelByStore: json["isCancelByStore"],
        isCancelByClient: json["isCancelByClient"],
        isNotifiCheckStore: json["isNotifiCheckStore"],
        isNotifiCheckClient: json["isNotifiCheckClient"],
        isPreparation: json["isPreparation"],
        isDelivered: json["isDelivered"],
        isDelivery: json["isDelivery"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store": store.toJson(),
        "client": client,
        "creditCardClient": creditCardClient,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "isActive": isActive,
        "isFinalice": isFinalice,
        "isCancelByStore": isCancelByStore,
        "isCancelByClient": isCancelByClient,
        "isNotifiCheckStore:": isNotifiCheckStore,
        "isNotifiCheckClient": isNotifiCheckClient,
        "isPreparation": isPreparation,
        "isDelivery": isDelivery,
        "isDelivered": isDelivered,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class ProductElement {
  ProductElement({
    this.product,
    this.quantity,
  });

  ProfileStoreProduct product;
  int quantity;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        product: ProfileStoreProduct.fromJson(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
      };
}
