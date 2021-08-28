// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/models/store.dart';

StoresResponse storesResponseFromJson(String str) =>
    StoresResponse.fromJson(json.decode(str));

String storesResponseToJson(StoresResponse data) => json.encode(data.toJson());

class StoresResponse {
  StoresResponse({this.ok, this.stores});

  bool ok;
  List<Store> stores;

  factory StoresResponse.fromJson(Map<String, dynamic> json) => StoresResponse(
        ok: json["ok"],
        stores:
            List<Store>.from(json["profiles"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
      };

  StoresResponse.withError(String errorValue);
}
