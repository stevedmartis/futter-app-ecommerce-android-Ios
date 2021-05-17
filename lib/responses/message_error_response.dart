import 'dart:convert';

Erroresponse errorMessageResponseFromJson(String str) =>
    Erroresponse.fromJson(json.decode(str));

String errorMessageResponseToJson(Erroresponse data) =>
    json.encode(data.toJson());

class Erroresponse {
  Erroresponse({this.ok, this.msg});

  bool ok;
  String msg;

  factory Erroresponse.fromJson(Map<String, dynamic> json) =>
      Erroresponse(ok: json["ok"], msg: json["msg"]);

  Map<String, dynamic> toJson() => {"ok": ok, "msg": msg};

  Erroresponse.withError(String errorValue);
}
