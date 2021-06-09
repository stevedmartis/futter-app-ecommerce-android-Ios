// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  ProductResponse({this.ok, this.product});

  bool ok;
  ProfileStoreProduct product;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
          ok: json["ok"],
          product: ProfileStoreProduct.fromJson(json["product"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "product": product.toJson(),
      };

  ProductResponse.withError(String errorValue);
}
