// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AddressesCurrent addressCurrentFromJson(String str) =>
    AddressesCurrent.fromJson(json.decode(str));

String addressCurrentJson(AddressesCurrent data) => json.encode(data.toJson());

class AddressesCurrent {
  AddressesCurrent({
    this.results,
  });

  List<Result> results;

  factory AddressesCurrent.fromJson(Map<String, dynamic> json) =>
      AddressesCurrent(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.addressComponents,
  });

  List<AddressComponent> addressComponents;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
      };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  String longName;
  String shortName;
  List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}
