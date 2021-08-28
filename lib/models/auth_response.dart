import 'dart:convert';
import 'package:freeily/models/store.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.ok,
    this.store,
    this.token,
  });

  bool ok;
  Store store;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        store: Store.fromJson(json["store"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {"ok": ok, "profile": store.toJson()};
}
