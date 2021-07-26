// To parse this JSON data, do
//
//     final orderStoresProducts = orderStoresProductsFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

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
    this.products,
    this.isActive,
    this.isFinalice,
    this.isPreparation,
    this.isSend,
    this.isCancel,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  Store store;
  String client;
  List<ProductElement> products;
  bool isActive;
  bool isFinalice;
  bool isCancel;
  DateTime createdAt;
  DateTime updatedAt;

  bool isPreparation;
  bool isSend;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        store: Store.fromJson(json["store"]),
        client: json["client"],
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
        isActive: json["isActive"],
        isFinalice: json["isFinalice"],
        isCancel: json["isCancel"],
        isPreparation: json["isPreparation"],
        isSend: json["isSend"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store": store.toJson(),
        "client": client,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "isActive": isActive,
        "isFinalice": isFinalice,
        "isCancel": isCancel,
        "isPreparation": isPreparation,
        "isSend": isSend,
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
