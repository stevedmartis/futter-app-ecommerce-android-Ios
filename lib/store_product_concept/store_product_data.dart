import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/models/user.dart';
import 'package:meta/meta.dart' show required;

class ProfileStoreCategory {
  ProfileStoreCategory(
      {@required this.id,
      this.name,
      this.products,
      this.store,
      this.createdAt,
      this.position,
      this.privacity,
      this.updatedAt,
      this.description,
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
      @required this.description,
      @required this.price,
      @required this.image,
      this.createdAt,
      this.updatedAt});
  String id;
  String name;
  String description;
  double price;
  String image;

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
          image: 'assets/rappi_concept/silimlights.png'),
      ProfileStoreProduct(
          id: '2',
          name: 'Udo Island',
          description:
              'Koreanischer Glasnudelsalat mit Gemüse-Pickles, Melon Balls.',
          price: 11.50,
          image: 'assets/rappi_concept/udoisland.png'),
      ProfileStoreProduct(
          id: '3',
          name: 'Secret Japanese Pavillon',
          description:
              'Gimbap Korean Sushi Selection mit Bulgogi-Beef, Kimchi & Mango sowie Beef- Tatar, 12 Stück',
          price: 28.50,
          image: 'assets/rappi_concept/secretjapanesepavillon.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Hanok Stay',
          description:
              'Mazemen mit Bulgogi-Beef, Ramen, Ei, Sojasprossen & Frühlingszwiebeln.',
          price: 20.50,
          image: 'assets/rappi_concept/hanokstay.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Yunai Sky',
          description:
              'Bulgogi mit plant-based Beef dazu Reis, Sojasprossen, Frühlingszwiebeln, Kimchi, Salatblätter & Artisan Sauce',
          price: 29.50,
          image: 'assets/rappi_concept/yunaisky.png'),
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
          image: 'assets/rappi_concept/silimlights.png'),
      ProfileStoreProduct(
          id: '2',
          name: 'Udo Island',
          description:
              'Koreanischer Glasnudelsalat mit Gemüse-Pickles, Melon Balls.',
          price: 11.50,
          image: 'assets/rappi_concept/udoisland.png'),
      ProfileStoreProduct(
          id: '3',
          name: 'Secret Japanese Pavillon',
          description:
              'Gimbap Korean Sushi Selection mit Bulgogi-Beef, Kimchi & Mango sowie Beef- Tatar, 12 Stück',
          price: 28.50,
          image: 'assets/rappi_concept/secretjapanesepavillon.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Hanok Stay',
          description:
              'Mazemen mit Bulgogi-Beef, Ramen, Ei, Sojasprossen & Frühlingszwiebeln.',
          price: 20.50,
          image: 'assets/rappi_concept/hanokstay.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Yunai Sky',
          description:
              'Bulgogi mit plant-based Beef dazu Reis, Sojasprossen, Frühlingszwiebeln, Kimchi, Salatblätter & Artisan Sauce',
          price: 29.50,
          image: 'assets/rappi_concept/yunaisky.png'),
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
          name: 'Sudogwon Millions',
          description:
              'Steamed bao-sandwiches with kimchi, pickled cucumber and mango cubes.',
          price: 26.50,
          image: 'assets/rappi_concept/sudogwonmillions.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Gentle Monster',
          description: 'Mandus mit Shrimps, 4 Stk.',
          price: 12.50,
          image: 'assets/rappi_concept/gentlemonster.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Unified Silla',
          description:
              'Natural planted fried Blumenkohl glasiert mit Gochujang',
          price: 11.50,
          image: 'assets/rappi_concept/unifiedsilla.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Nosan Night',
          description: 'Pikante koreanische Suppe mit Kimchi und Tofu',
          price: 7.50,
          image: 'assets/rappi_concept/nosannight.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Wings of Incheon',
          description: 'Micro-Greens & gerösteten Erbsen, 4 Stk.',
          price: 29.50,
          image: 'assets/rappi_concept/wingsofincheon.png'),
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
          name: 'Haeundae Surf',
          description:
              'Chicken-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake- Pilzen, Sesamöl, gerösteten Zwiebeln & Ei.',
          price: 23.50,
          image: 'assets/rappi_concept/haeundaesurf.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Gugudan O’Clock',
          description:
              'Ramen Soup mit Porkbelly & Chicken, homemade Brühe, Shiitake-Pilzen, & Frühlingszwiebeln.',
          price: 24.50,
          image: 'assets/rappi_concept/gugudanoclock.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Koyote Pop',
          description:
              'Marinierter, knuspriger Tofu & Frühlingszwiebeln, garniert mit Sesam.',
          price: 8.50,
          image: 'assets/rappi_concept/koyotepop.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Edamame',
          description: 'Edamame with Korean chili salt.',
          price: 7.50,
          image: 'assets/rappi_concept/edamame.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Late Sunset',
          description:
              'Korean Fried Chicken, Dirty Cheese Sauce & Artisan Sauce.',
          price: 14.50,
          image: 'assets/rappi_concept/latesunset.png'),
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
          image: 'assets/rappi_concept/rice.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Cucumber Kimchi',
          description: 'Portion',
          price: 5.00,
          image: 'assets/rappi_concept/cucumberkimchi.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Cabbage Kimchi',
          description: 'Portion',
          price: 8.50,
          image: 'assets/rappi_concept/cabbagekimchi.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Fries',
          description: 'Fries mit Miss Miu Mayo.',
          price: 6.00,
          image: 'assets/rappi_concept/fries.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Carrot Kimchi',
          description: 'Portion',
          price: 14.50,
          image: 'assets/rappi_concept/carrotkimchi.png'),
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
          image: 'assets/rappi_concept/silimlights.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Udo Island',
          description:
              'Koreanischer Glasnudelsalat mit Gemüse-Pickles, Melon Balls.',
          price: 11.50,
          image: 'assets/rappi_concept/udoisland.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Secret Japanese Pavillon',
          description:
              'Gimbap Korean Sushi Selection mit Bulgogi-Beef, Kimchi & Mango sowie Beef- Tatar, 12 Stück',
          price: 28.50,
          image: 'assets/rappi_concept/secretjapanesepavillon.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Hanok Stay',
          description:
              'Mazemen mit Bulgogi-Beef, Ramen, Ei, Sojasprossen & Frühlingszwiebeln.',
          price: 20.50,
          image: 'assets/rappi_concept/hanokstay.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Yunai Sky',
          description:
              'Bulgogi mit plant-based Beef dazu Reis, Sojasprossen, Frühlingszwiebeln, Kimchi, Salatblätter & Artisan Sauce',
          price: 29.50,
          image: 'assets/rappi_concept/yunaisky.png'),
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
          image: 'assets/rappi_concept/sudogwonmillions.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Gentle Monster',
          description: 'Mandus mit Shrimps, 4 Stk.',
          price: 12.50,
          image: 'assets/rappi_concept/gentlemonster.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Unified Silla',
          description:
              'Natural planted fried Blumenkohl glasiert mit Gochujang',
          price: 11.50,
          image: 'assets/rappi_concept/unifiedsilla.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Nosan Night',
          description: 'Pikante koreanische Suppe mit Kimchi und Tofu',
          price: 7.50,
          image: 'assets/rappi_concept/nosannight.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Wings of Incheon',
          description: 'Micro-Greens & gerösteten Erbsen, 4 Stk.',
          price: 29.50,
          image: 'assets/rappi_concept/wingsofincheon.png'),
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
          image: 'assets/rappi_concept/haeundaesurf.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Gugudan O’Clock',
          description:
              'Ramen Soup mit Porkbelly & Chicken, homemade Brühe, Shiitake-Pilzen, & Frühlingszwiebeln.',
          price: 24.50,
          image: 'assets/rappi_concept/gugudanoclock.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Koyote Pop',
          description:
              'Marinierter, knuspriger Tofu & Frühlingszwiebeln, garniert mit Sesam.',
          price: 8.50,
          image: 'assets/rappi_concept/koyotepop.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Edamame',
          description: 'Edamame with Korean chili salt.',
          price: 7.50,
          image: 'assets/rappi_concept/edamame.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Late Sunset',
          description:
              'Korean Fried Chicken, Dirty Cheese Sauce & Artisan Sauce.',
          price: 14.50,
          image: 'assets/rappi_concept/latesunset.png'),
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
          image: 'assets/rappi_concept/rice.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Cucumber Kimchi',
          description: 'Portion',
          price: 5.00,
          image: 'assets/rappi_concept/cucumberkimchi.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Cabbage Kimchi',
          description: 'Portion',
          price: 8.50,
          image: 'assets/rappi_concept/cabbagekimchi.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Fries',
          description: 'Fries mit Miss Miu Mayo.',
          price: 6.00,
          image: 'assets/rappi_concept/fries.png'),
      ProfileStoreProduct(
          id: '1',
          name: 'Carrot Kimchi',
          description: 'Portion',
          price: 14.50,
          image: 'assets/rappi_concept/carrotkimchi.png'),
    ],
  ),
];
