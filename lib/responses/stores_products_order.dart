// To parse this JSON data, do
//
//     final storesProductsOrder = storesProductsOrderFromJson(jsonString);

import 'dart:convert';

StoresProductsOrder storesProductsOrderFromJson(String str) =>
    StoresProductsOrder.fromJson(json.decode(str));

String storesProductsOrderToJson(StoresProductsOrder data) =>
    json.encode(data.toJson());

class StoresProductsOrder {
  StoresProductsOrder({
    this.storesProducts,
  });

  List<StoresProduct> storesProducts;

  factory StoresProductsOrder.fromJson(Map<String, dynamic> json) =>
      StoresProductsOrder(
        storesProducts: List<StoresProduct>.from(
            json["storesProducts"].map((x) => StoresProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "storesProducts":
            List<dynamic>.from(storesProducts.map((x) => x.toJson())),
      };
}

class StoresProduct {
  StoresProduct({
    this.storeUid,
    this.products,
  });

  String storeUid;
  List<Product> products;

  factory StoresProduct.fromJson(Map<String, dynamic> json) => StoresProduct(
        storeUid: json["storeUid"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "storeUid": storeUid,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    this.id,
    this.quantity,
  });

  String id;
  int quantity;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}
