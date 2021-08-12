// To parse this JSON data, do
//
//     final bankAccount = bankAccountFromJson(jsonString);

import 'dart:convert';

BankAccountResponse bankAccountFromJson(String str) =>
    BankAccountResponse.fromJson(json.decode(str));

String bankAccountToJson(BankAccountResponse data) =>
    json.encode(data.toJson());

class BankAccountResponse {
  BankAccountResponse({
    this.ok,
    this.bankAccount,
  });

  bool ok;
  BankAccount bankAccount;

  factory BankAccountResponse.fromJson(Map<String, dynamic> json) =>
      BankAccountResponse(
        ok: json["ok"],
        bankAccount: BankAccount.fromJson(json["bankAccount"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "bankAccount": bankAccount.toJson(),
      };
}

class BankAccount {
  BankAccount({
    this.user,
    this.nameAccount,
    this.rutAccount,
    this.typeAccount,
    this.numberAccount,
    this.bankOfAccount,
    this.emailAccount,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  String user;
  String nameAccount;
  String rutAccount;
  String typeAccount;
  String numberAccount;
  String bankOfAccount;
  String emailAccount;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        user: json["user"],
        nameAccount: json["nameAccount"],
        rutAccount: json["rutAccount"],
        typeAccount: json["typeAccount"],
        numberAccount: json["numberAccount"],
        bankOfAccount: json["bankOfAccount"],
        emailAccount: json["emailAccount"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "nameAccount": nameAccount,
        "rutAccount": rutAccount,
        "typeAccount": typeAccount,
        "numberAccount": numberAccount,
        "bankOfAccount": bankOfAccount,
        "emailAccount": emailAccount,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
