// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/models/user.dart';

Profile profilesFromJson(String str) => Profile.fromJson(json.decode(str));

String profilesToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile(
      {this.id,
      this.name,
      this.lastName,
      this.createdAt,
      this.updatedAt,
      this.imageHeader,
      this.imageAvatar,
      this.user,
      this.imageRecipe,
      this.message = "",
      this.messageDate,
      this.subId = "0",
      this.isClub = false,
      this.subscribeApproved = false,
      this.subscribeActive = false,
      this.about = ""});

  String id;
  String name;
  String lastName;
  DateTime createdAt;
  DateTime updatedAt;
  String imageHeader;
  String about;
  String imageAvatar;
  String imageRecipe;
  User user;
  String message;
  DateTime messageDate;
  String subId;
  bool isClub;
  bool subscribeApproved;
  bool subscribeActive;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      name: json["name"],
      lastName: json["lastName"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      imageAvatar: json["imageAvatar"],
      about: json["about"],
      message: json["message"],
      messageDate: DateTime.parse(json["messageDate"]),
      imageHeader: json["imageHeader"],
      user: User.fromJson(json["user"]),
      imageRecipe: json["imageRecipe"],
      subId: json["subId"],
      isClub: json["isClub"],
      subscribeApproved: json["subscribeApproved"],
      subscribeActive: json["subscribeActive"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "dateCreate": createdAt,
        "dateUpdate": updatedAt,
        "messageDate": messageDate,
        "about": about,
        "message": message,
        "imageAvatar:": imageAvatar,
        "imageHeader": imageHeader,
        "user": user.toJson(),
        "imageRecipe": imageRecipe,
        "subId": subId,
        "isClub": isClub,
        "subscribeApproved": subscribeApproved,
        "subscribeActive": subscribeActive
      };

  getAvatarImg() {
    if (imageAvatar == "") {
      return null;
    } else {
      return imageAvatar;
    }
  }

//https://images-cdn-br.s3-sa-east-1.amazonaws.com/default_banner.jpeg
  getHeaderImg() {
    if (imageHeader == "") {
      var imageDefault =
          "https://images-cdn-br.s3-sa-east-1.amazonaws.com/default_banner.jpeg";

      return imageDefault;
    } else {
      return imageHeader;
    }
  }

  getRecipeImg() {
    if (imageRecipe == "") {
      var imageDefault =
          "https://images-cdn-br.s3-sa-east-1.amazonaws.com/default_banner.jpeg";

      return imageDefault;
    } else {
      return imageRecipe;
    }
  }
}
