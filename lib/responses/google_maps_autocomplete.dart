// To parse this JSON data, do
//
//     final googleMapsAutoComplete = googleMapsAutoCompleteFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/models/place_Search.dart';

GoogleMapsAutoComplete googleMapsAutoCompleteFromJson(String str) =>
    GoogleMapsAutoComplete.fromJson(json.decode(str));

String googleMapsAutoCompleteToJson(GoogleMapsAutoComplete data) =>
    json.encode(data.toJson());

class GoogleMapsAutoComplete {
  GoogleMapsAutoComplete({
    this.ok,
    this.predictions,
  });

  bool ok;
  List<PlaceSearch> predictions;

  factory GoogleMapsAutoComplete.fromJson(Map<String, dynamic> json) =>
      GoogleMapsAutoComplete(
        ok: json["ok"],
        predictions: List<PlaceSearch>.from(
            json["predictions"].map((x) => PlaceSearch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "predictions": List<dynamic>.from(predictions.map((x) => x.toJson())),
      };
}
