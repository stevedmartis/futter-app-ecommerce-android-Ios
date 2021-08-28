// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/models/favorte.dart';

FavoriteResponse favoriteResponseFromJson(String str) =>
    FavoriteResponse.fromJson(json.decode(str));

String favoriteResponseToJson(FavoriteResponse data) =>
    json.encode(data.toJson());

class FavoriteResponse {
  FavoriteResponse({this.ok, this.favorite});

  bool ok;
  Favorite favorite;

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      FavoriteResponse(
          ok: json["ok"], favorite: Favorite.fromJson(json["favorite"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "favorite": favorite.toJson(),
      };

  FavoriteResponse.withError(String errorValue);
}
