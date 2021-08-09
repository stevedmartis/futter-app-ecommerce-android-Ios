import 'package:meta/meta.dart';

class CreditCard {
  CreditCard({
    @required this.id,
    this.cardNumberHidden,
    this.cardNumber,
    this.brand,
    this.cvv,
    this.expiracyDate,
    this.cardHolderName,
    this.isSelect,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String cardNumberHidden;
  String cardNumber;
  String brand;
  String cvv;
  String expiracyDate;
  String cardHolderName;
  bool isSelect;
  DateTime createdAt;
  DateTime updatedAt;

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        id: json["id"],
        cardNumberHidden: json["cardNumberHidden"],
        cardNumber: json["cardNumber"],
        brand: json["brand"],
        cvv: json["cvv"],
        expiracyDate: json["expiracyDate"],
        cardHolderName: json["cardHolderName"],
        isSelect: json["isSelect"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cardNumberHidden": cardNumberHidden,
        "cardNumber": cardNumber,
        "brand": brand,
        "cvv": cvv,
        "expiracyDate": expiracyDate,
        "cardHolderName": cardHolderName,
        "isSelect": isSelect,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
