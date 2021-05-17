// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

StoreCategoriesResponse storeCategoriesResponseFromJson(String str) =>
    StoreCategoriesResponse.fromJson(json.decode(str));

String airResponseToJson(StoreCategoriesResponse data) =>
    json.encode(data.toJson());

class StoreCategoriesResponse {
  StoreCategoriesResponse({this.ok, this.storeCategories});

  bool ok;
  List<ProfileStoreCategory> storeCategories;

  factory StoreCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoreCategoriesResponse(
        ok: json["ok"],
        storeCategories: List<ProfileStoreCategory>.from(json["storeCategories"]
            .map((x) => ProfileStoreCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "storeCategories":
            List<dynamic>.from(storeCategories.map((x) => x.toJson())),
      };

  StoreCategoriesResponse.withError(String errorValue);
}
