// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

PlacesSearch placeSearchFromJson(String str) =>
    PlacesSearch.fromJson(json.decode(str));

String placeSearchToJson(PlacesSearch data) => json.encode(data.toJson());

class PlacesSearch {
  PlacesSearch(
      {this.description,
      this.placeId,
      this.number,
      this.secondaryText,
      this.mainText});

  String description;

  String placeId;
  String mainText;
  String secondaryText;
  String number;

  factory PlacesSearch.fromJson(Map<String, dynamic> json) => PlacesSearch(
        description: json["description"],
        placeId: json["placeId"],
        number: json["number"],
        secondaryText: json["secondaryText"],
        mainText: json["mainText"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "placeId": placeId,
        "secondaryText": secondaryText,
        "number": number,
        "mainText": mainText
      };
}
