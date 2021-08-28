// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:freeily/store_product_concept/store_product_data.dart';

ImagesResponse imagesResponseFromJson(String str) =>
    ImagesResponse.fromJson(json.decode(str));

String imagesResponseToJson(ImagesResponse data) => json.encode(data.toJson());

class ImagesResponse {
  ImagesResponse({this.ok, this.images});

  bool ok;
  List<ImageProduct> images;

  factory ImagesResponse.fromJson(Map<String, dynamic> json) => ImagesResponse(
        ok: json["ok"],
        images: List<ImageProduct>.from(
            json["images"].map((x) => ImageProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "images": images,
      };

  ImagesResponse.withError(String errorValue);
}
