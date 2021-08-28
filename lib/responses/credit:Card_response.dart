import 'dart:convert';

import 'package:freeily/models/credit_Card.dart';

CreditCardResponse cardResponseFromJson(String str) =>
    CreditCardResponse.fromJson(json.decode(str));

String favoriteResponseToJson(CreditCardResponse data) =>
    json.encode(data.toJson());

class CreditCardResponse {
  CreditCardResponse({this.ok, this.card});

  bool ok;
  CreditCard card;

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) =>
      CreditCardResponse(
          ok: json["ok"], card: CreditCard.fromJson(json["card"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "card": card.toJson(),
      };

  CreditCardResponse.withError(String errorValue);
}
