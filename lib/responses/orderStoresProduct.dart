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
    this.order,
  });

  bool ok;
  List<Order> order;

  factory OrderStoresProducts.fromJson(Map<String, dynamic> json) =>
      OrderStoresProducts(
        ok: json["ok"],
        order: List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "order": List<dynamic>.from(order.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.id,
    this.store,
    this.client,
    this.products,
    this.siActive,
    this.isFinalice,
    this.isCancel,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  Store store;
  String client;
  List<ProductElement> products;
  bool siActive;
  bool isFinalice;
  bool isCancel;
  DateTime createdAt;
  DateTime updatedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        store: Store.fromJson(json["store"]),
        client: json["client"],
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
        siActive: json["siActive"],
        isFinalice: json["isFinalice"],
        isCancel: json["isCancel"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store": store.toJson(),
        "client": client,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "siActive": siActive,
        "isFinalice": isFinalice,
        "isCancel": isCancel,
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
