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
          store: Store.fromJson(json["store"]),
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
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "position": position,
        "store": store.toJson(),
        "description": description,
        "visibility": visibility
      };
}

class ProfileStoreProduct {
  ProfileStoreProduct(
      {@required this.id,
      @required this.name,
      this.description = "",
      this.price = 0,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.images,
      this.category});
  String id;
  String name;
  String description;
  double price;
  String image;
  List<ImageProduct> images;

  DateTime createdAt;
  DateTime updatedAt;
  String user;

  String category;
  factory ProfileStoreProduct.fromJson(Map<String, dynamic> json) =>
      new ProfileStoreProduct(
        id: json["id"],
        name: json['name'],
        image: json["image"],
        user: json["user"],
        description: json['description'],
        price: json["price"],
        category: json["category"],
/*         createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]), */
        images: List<ImageProduct>.from(
            json["images"].map((x) => ImageProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        //  "createAt": createdAt,
        "description": description,
        "id": id,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "name": name,
        "price": price,
        "updateAt": updatedAt,
        "user": user,
        "category": category
      };
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

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

var rappiCategories = [
  ProfileStoreCategory(
    description: '',
    visibility: true,
    position: 1,
    id: '1',
    store: Store(user: User(uid: '1')),
    name: 'Orden User',
    products: [
      ProfileStoreProduct(
          user: '1',
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
    description: '',
    visibility: true,
    position: 1,
    id: '1-a',
    store: Store(user: User(uid: '1')),
    name: 'Orden Again',
    products: [
      ProfileStoreProduct(
          user: '1',
          id: '1-a',
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
    description: '',
    visibility: true,
    position: 2,
    id: '1-a',
    store: Store(user: User(uid: '1-a')),
    name: 'Picker For You',
    products: [
      ProfileStoreProduct(
          user: '1-a',
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
    description: '',
    visibility: true,
    position: 3,
    id: '1-a',
    store: Store(user: User(uid: '1-a')),
    name: 'Starters',
    products: [
      ProfileStoreProduct(
          user: '1-a',
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
    description: '',
    visibility: true,
    position: 4,
    id: '1-d',
    store: Store(user: User(uid: '2-b')),
    name: 'Sides',
    products: [
      ProfileStoreProduct(
          user: '2-b',
          id: '1',
          name: 'Rice 2',
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
    description: '',
    visibility: true,
    position: 5,
    id: '1-e',
    store: Store(user: User(uid: '1')),
    name: 'Orden Again 2',
    products: [
      ProfileStoreProduct(
          user: '1',
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
    description: '',
    visibility: true,
    position: 6,
    id: '1-f',
    store: Store(user: User(uid: '2')),
    name: 'Picker For You 2',
    products: [
      ProfileStoreProduct(
          user: '2',
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
    description: '',
    visibility: true,
    position: 7,
    id: '1-g',
    store: Store(user: User(uid: '2-a')),
    name: 'Starters 2',
    products: [
      ProfileStoreProduct(
          user: '2-a',
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
    description: '',
    visibility: true,
    position: 8,
    id: '1-h',
    store: Store(user: User(uid: '2')),
    name: 'Sides 2',
    products: [
      ProfileStoreProduct(
          id: '1',
          user: '2',
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
