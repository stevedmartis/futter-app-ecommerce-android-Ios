import 'dart:convert';

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toJson());

class Favorite {
  Favorite(
      {this.id,
      this.user,
      this.product,
      this.createdAt,
      this.updatedAt,
      this.isLike = false,
      init()});

  String id;

  String user;
  String product;
  bool isLike;

  DateTime createdAt;
  DateTime updatedAt;

  factory Favorite.fromJson(Map<String, dynamic> json) => new Favorite(
        id: json["id"],
        user: json['user'],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isLike: json["isLike"],
        product: json["product"],

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "product": product,
        "isLike": isLike,
      };
}
