import 'dart:convert';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';

List<GroceryProductItem> cartProductsFromJson(String str) =>
    List<GroceryProductItem>.from(
        json.decode(str).map((x) => GroceryProductItem.fromJson(x)));

String cartProductsToJson(List<GroceryProductItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroceryProductItem {
  GroceryProductItem({this.quantity = 1, @required this.product});
  int quantity;
  final ProfileStoreProduct product;

  factory GroceryProductItem.fromJson(Map<String, dynamic> json) =>
      GroceryProductItem(
        product: ProfileStoreProduct.fromJson(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
      };

  void increment(int newQuantity) {
    quantity += newQuantity;
  }
}
