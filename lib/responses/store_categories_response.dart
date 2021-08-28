// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/store_product_concept/store_product_data.dart';

StoreCategoriesResponse storeCategoriesResponseFromJson(String str) =>
    StoreCategoriesResponse.fromJson(json.decode(str));

String airResponseToJson(StoreCategoriesResponse data) =>
    json.encode(data.toJson());

class StoreCategoriesResponse {
  StoreCategoriesResponse({this.ok, this.storeCategoriesProducts});

  bool ok;
  List<ProfileStoreCategory> storeCategoriesProducts;

  factory StoreCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoreCategoriesResponse(
        ok: json["ok"],
        storeCategoriesProducts: List<ProfileStoreCategory>.from(
            json["storeCategoriesProducts"]
                .map((x) => ProfileStoreCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "storeCategoriesProducts":
            List<dynamic>.from(storeCategoriesProducts.map((x) => x.toJson())),
      };

  StoreCategoriesResponse.withError(String errorValue);
}
