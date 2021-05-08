// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/models/store.dart';

StoreResponse plantsResponseFromJson(String str) =>
    StoreResponse.fromJson(json.decode(str));

String plantsResponseToJson(StoreResponse data) => json.encode(data.toJson());

class StoreResponse {
  StoreResponse({this.ok, this.stores});

  bool ok;
  List<Store> stores;

  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
        ok: json["ok"],
        stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };

  StoreResponse.withError(String errorValue);
}
