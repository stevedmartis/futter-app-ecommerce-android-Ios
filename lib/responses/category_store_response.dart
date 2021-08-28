// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/store_product_concept/store_product_data.dart';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String airResponseToJson(CategoryResponse data) => json.encode(data.toJson());

class CategoryResponse {
  CategoryResponse({this.ok, this.category});

  bool ok;
  ProfileStoreCategory category;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
          ok: json["ok"],
          category: ProfileStoreCategory.fromJson(json["category"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "category": category.toJson(),
      };

  CategoryResponse.withError(String errorValue);
}
