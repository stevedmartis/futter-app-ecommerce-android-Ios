import 'dart:convert';
import 'package:freeily/models/store.dart';

StoreResponse storeResponseFromJson(String str) =>
    StoreResponse.fromJson(json.decode(str));

String storeResponseToJson(StoreResponse data) => json.encode(data.toJson());

class StoreResponse {
  StoreResponse({
    this.ok,
    this.store,
  });

  bool ok;
  Store store;

  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
        ok: json["ok"],
        store: Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {"ok": ok, "store": store.toJson()};
}
