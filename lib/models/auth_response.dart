import 'dart:convert';
import 'package:australti_ecommerce_app/models/profile.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.ok,
    this.profile,
    this.token,
  });

  bool ok;
  Profile profile;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        profile: Profile.fromJson(json["profile"]),
        token: json["token"],
        //json['profile'].cast<String>()

//        Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {"ok": ok, "profile": profile.toJson()};
}
