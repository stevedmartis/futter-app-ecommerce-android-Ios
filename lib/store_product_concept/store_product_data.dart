import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/models/user.dart';
import 'package:meta/meta.dart' show required;

class ProfileStoreCategory {
  ProfileStoreCategory(
      {@required this.id,
      this.name = "",
      this.products,
      this.store,
      this.createdAt,
      this.position,
      this.privacity,
      this.updatedAt,
      this.description = "",
      this.visibility = true});
  String id;
  String name;
  List<ProfileStoreProduct> products;
  Store store;

  DateTime createdAt;
  DateTime updatedAt;
  int position;
  String privacity;
  String description;
  bool visibility;

  factory ProfileStoreCategory.fromJson(Map<String, dynamic> json) =>
      new ProfileStoreCategory(
          id: json["id"],
          name: json['name'],
          store: json["store"],
          position: json["position"],
          products: List<ProfileStoreProduct>.from(
              json["products"].map((x) => ProfileStoreProduct.fromJson(x))),
          createdAt: DateTime.parse(json["createdAt"]),
          updatedAt: DateTime.parse(json["updatedAt"]),
          description: json["description"],
          privacity: json["privacity"],
          visibility: json["visibility"]

          //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
          );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "store": store,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "description": description,
        "privacity": privacity,
        "visibility": visibility
      };
}

class ProfileStoreProduct {
  ProfileStoreProduct(
      {@required this.id,
      @required this.name,
      this.description,
      this.price,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.images});
  String id;
  String name;
  String description;
  double price;
  String image;
  List<ImageProduct> images;

  DateTime createdAt;
  DateTime updatedAt;

  factory ProfileStoreProduct.fromJson(Map<String, dynamic> json) =>
      new ProfileStoreProduct(
        id: json["id"],
        name: json['name'],
        image: json["image"],
        description: json['description'],
        price: json["price"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );
}

class ImageProduct {
  ImageProduct({
    @required this.url,
  });

  String url;

  factory ImageProduct.fromJson(Map<String, dynamic> json) => new ImageProduct(
        url: json['url'],

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );
}

var rappiCategories = [
  ProfileStoreCategory(
    privacity: '1',
    position: 1,
    id: '1',
    store: Store(user: User(uid: '1')),
    name: 'Orden User',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Silim Lights user',
          description:
              'Beef-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake-Pilzen, Sesamöl & Ei.',
          price: 26.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),

  ProfileStoreCategory(
    privacity: '1',
    position: 1,
    id: '1-a',
    store: Store(user: User(uid: '1-a')),
    name: 'Orden Again',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Silim Lights 1',
          description:
              'Beef-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake-Pilzen, Sesamöl & Ei.',
          price: 26.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
  ProfileStoreCategory(
    privacity: '1',
    position: 2,
    id: '1-b',
    store: Store(user: User(uid: '1')),
    name: 'Picker For You',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Wings of Incheon',
          description: 'Micro-Greens & gerösteten Erbsen, 4 Stk.',
          price: 29.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
  ProfileStoreCategory(
    privacity: '1',
    position: 3,
    id: '1-c',
    store: Store(user: User(uid: '1')),
    name: 'Starters',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Late Sunset',
          description:
              'Korean Fried Chicken, Dirty Cheese Sauce & Artisan Sauce.',
          price: 14.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
  ProfileStoreCategory(
    privacity: '1',
    position: 4,
    id: '1-d',
    store: Store(user: User(uid: '1')),
    name: 'Sides',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Rice',
          description: 'Portion.',
          price: 4.00,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),

  //repeated items
  ProfileStoreCategory(
    privacity: '1',
    position: 5,
    id: '1-e',
    store: Store(user: User(uid: '2')),
    name: 'Orden Again 2',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Silim Lights',
          description:
              'Beef-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake-Pilzen, Sesamöl & Ei.',
          price: 26.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
  ProfileStoreCategory(
    privacity: '1',
    position: 6,
    id: '1-f',
    store: Store(user: User(uid: '2')),
    name: 'Picker For You 2',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Sudogwon Millions',
          description:
              'Steamed bao-sandwiches with kimchi, pickled cucumber and mango cubes.',
          price: 26.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
  ProfileStoreCategory(
    privacity: '1',
    position: 7,
    id: '1-g',
    store: Store(user: User(uid: '2')),
    name: 'Starters 2',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Haeundae Surf',
          description:
              'Chicken-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake- Pilzen, Sesamöl, gerösteten Zwiebeln & Ei.',
          price: 23.50,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
  ProfileStoreCategory(
    privacity: '1',
    position: 8,
    id: '1-h',
    store: Store(user: User(uid: '2')),
    name: 'Sides 2',
    products: [
      ProfileStoreProduct(
          id: '1',
          name: 'Rice',
          description: 'Portion.',
          price: 4.00,
          images: [
            ImageProduct(
                url:
                    'https://leafety-images.s3.us-east-2.amazonaws.com/ecommerce/cabbagekimchi.png')
          ]),
    ],
  ),
];
