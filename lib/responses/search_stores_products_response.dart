// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

SearchStoresProductsListResponse storesProductsListResponseFromJson(
        String str) =>
    SearchStoresProductsListResponse.fromJson(json.decode(str));

String airResponseToJson(SearchStoresProductsListResponse data) =>
    json.encode(data.toJson());

class SearchStoresProductsListResponse {
  SearchStoresProductsListResponse(
      {this.ok, this.storesSearch, this.productsSearch});

  bool ok;
  List<Store> storesSearch;
  List<ProfileStoreProduct> productsSearch;

  factory SearchStoresProductsListResponse.fromJson(
          Map<String, dynamic> json) =>
      SearchStoresProductsListResponse(
        ok: json["ok"],
        storesSearch: List<Store>.from(
            json["storesSearch"].map((x) => Store.fromJson(x))),
        productsSearch: List<ProfileStoreProduct>.from(
            json["productsSearch"].map((x) => ProfileStoreProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "storesSearch": List<dynamic>.from(storesSearch.map((x) => x.toJson())),
        "productsSearch":
            List<dynamic>.from(productsSearch.map((x) => x.toJson())),
      };

  SearchStoresProductsListResponse.withError(String errorValue);
}
