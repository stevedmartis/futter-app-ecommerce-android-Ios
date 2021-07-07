// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

StoreCategoriesResponse myFavoritesStoreProductsResponseFromJson(String str) =>
    StoreCategoriesResponse.fromJson(json.decode(str));

String airResponseToJson(StoreCategoriesResponse data) =>
    json.encode(data.toJson());

class StoreCategoriesResponse {
  StoreCategoriesResponse({this.ok, this.favoritesProducts});

  bool ok;
  List<ProfileStoreProduct> favoritesProducts;

  factory StoreCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoreCategoriesResponse(
        ok: json["ok"],
        favoritesProducts: List<ProfileStoreProduct>.from(
            json["products"].map((x) => ProfileStoreProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "favoritesProducts":
            List<dynamic>.from(favoritesProducts.map((x) => x.toJson())),
      };

  StoreCategoriesResponse.withError(String errorValue);
}
