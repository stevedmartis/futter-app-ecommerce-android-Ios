// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/models/store.dart';

StoresListResponse storesListResponseFromJson(String str) =>
    StoresListResponse.fromJson(json.decode(str));

String airResponseToJson(StoresListResponse data) => json.encode(data.toJson());

class StoresListResponse {
  StoresListResponse({this.ok, this.storeListServices});

  bool ok;
  List<Store> storeListServices;

  factory StoresListResponse.fromJson(Map<String, dynamic> json) =>
      StoresListResponse(
        ok: json["ok"],
        storeListServices: List<Store>.from(
            json["storeListServices"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "storeListServices":
            List<dynamic>.from(storeListServices.map((x) => x.toJson())),
      };

  StoresListResponse.withError(String errorValue);
}
