import 'package:freeily/models/store.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';

class StoreProduct {
  StoreProduct(
      {this.id,
      this.name,
      this.description = "",
      this.price = 0,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.store,
      this.images,
      this.category,
      this.isLike});
  String id;
  String name;
  String description;
  int price;
  String image;
  List<ImageProduct> images;

  DateTime createdAt;
  DateTime updatedAt;
  Store store;
  bool isLike;

  String category;
  factory StoreProduct.fromJson(Map<String, dynamic> json) => new StoreProduct(
        id: json["id"],
        name: json['name'],
        image: json["image"],
        store: Store.fromJson(json["store"]),
        description: json['description'],
        price: json["price"],
        category: json["category"],
        isLike: json["isLike"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        images: List<ImageProduct>.from(
            json["images"].map((x) => ImageProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "description": description,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "price": price,
        "store": store.toJson(),
        "category": category,
        "isLike": isLike,
      };
}
