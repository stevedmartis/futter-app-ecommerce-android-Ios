// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/models/user.dart';
import 'package:flutter/material.dart';

Store storeFromJson(String str) => Store.fromJson(json.decode(str));

String storeToJson(Store data) => json.encode(data.toJson());

class Store {
  const Store({
    this.id = "",
    @required this.user,
    this.about = "",
    this.products = 0,
    this.name = "",
    this.image = "",
    this.timeDelivery,
    this.percentOff,
    this.trophys = 0,
    this.isEco = false,
    this.service,
    this.createAt,
    this.updateAt,
  });

  final String id;
  final User user;
  final String about;
  final int products;
  final String name;
  final String image;
  final int service;
  final String timeDelivery;
  final int percentOff;
  final int trophys;
  final bool isEco;
  final String createAt;
  final String updateAt;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        user: User.fromJson(json["user"]),
        about: json["about"],
        products: json["products"],
        name: json["name"],
        image: json["image"],
        service: json["service"],
        timeDelivery: json["time_delivery"],
        percentOff: json["percentOff"],
        trophys: json["trophys"],
        isEco: json["isEco"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "about": about,
        "products": products,
        "name": name,
        "image": image,
        "service": service,
        "time_delivery": timeDelivery,
        "percentOff": percentOff,
        "trophys": trophys,
        "isEco": isEco,
        "createAt": createAt,
        "updateAt": updateAt,
      };
}
