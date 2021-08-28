import 'dart:convert';

import 'package:freeily/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';

List<GroceryProductItem> cartProductsFromJson(String str) =>
    List<GroceryProductItem>.from(
        json.decode(str).map((x) => GroceryProductItem.fromJson(x)));

String cartProductsToJson(List<GroceryProductItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroceryProductItem {
  GroceryProductItem(
      {this.quantity = 1, @required this.product, this.show = false});
  int quantity;
  bool show;
  final ProfileStoreProduct product;

  factory GroceryProductItem.fromJson(Map<String, dynamic> json) =>
      GroceryProductItem(
        product: ProfileStoreProduct.fromJson(json["product"]),
        quantity: json["quantity"],
        show: json["show"],
      );

  Map<String, dynamic> toJson() =>
      {"product": product.toJson(), "quantity": quantity, "show": show};

  void increment(int newQuantity) {
    quantity += newQuantity;
  }
}
