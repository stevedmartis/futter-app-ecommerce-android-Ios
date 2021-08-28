import 'dart:convert';

import 'package:freeily/models/credit_Card.dart';

MyCreditCards creditCardsFromJson(String str) =>
    MyCreditCards.fromJson(json.decode(str));

String reditCardsToJson(MyCreditCards data) => json.encode(data.toJson());

class MyCreditCards {
  MyCreditCards({
    this.ok,
    this.cards,
  });

  bool ok;
  List<CreditCard> cards;

  factory MyCreditCards.fromJson(Map<String, dynamic> json) => MyCreditCards(
        ok: json["ok"],
        cards: List<CreditCard>.from(
            json["cards"].map((x) => CreditCard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}
