import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/models/user.dart';
import 'package:meta/meta.dart' show required;

class ProfileStoreCategory {
  const ProfileStoreCategory(
      {@required this.name, @required this.products, @required this.store});
  final String name;
  final List<ProfileStoreProduct> products;
  final Store store;
}

class ProfileStoreProduct {
  const ProfileStoreProduct({
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.image,
  });
  final String name;
  final String description;
  final double price;
  final String image;
}

const rappiCategories = [
  ProfileStoreCategory(
    store: Store(user: User(uid: '1')),
    name: 'Orden Again',
    products: [
      ProfileStoreProduct(
          name: 'Silim Lights',
          description:
              'Beef-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake-Pilzen, Sesamöl & Ei.',
          price: 26.50,
          image: 'assets/rappi_concept/silimlights.png'),
      ProfileStoreProduct(
          name: 'Udo Island',
          description:
              'Koreanischer Glasnudelsalat mit Gemüse-Pickles, Melon Balls.',
          price: 11.50,
          image: 'assets/rappi_concept/udoisland.png'),
      ProfileStoreProduct(
          name: 'Secret Japanese Pavillon',
          description:
              'Gimbap Korean Sushi Selection mit Bulgogi-Beef, Kimchi & Mango sowie Beef- Tatar, 12 Stück',
          price: 28.50,
          image: 'assets/rappi_concept/secretjapanesepavillon.png'),
      ProfileStoreProduct(
          name: 'Hanok Stay',
          description:
              'Mazemen mit Bulgogi-Beef, Ramen, Ei, Sojasprossen & Frühlingszwiebeln.',
          price: 20.50,
          image: 'assets/rappi_concept/hanokstay.png'),
      ProfileStoreProduct(
          name: 'Yunai Sky',
          description:
              'Bulgogi mit plant-based Beef dazu Reis, Sojasprossen, Frühlingszwiebeln, Kimchi, Salatblätter & Artisan Sauce',
          price: 29.50,
          image: 'assets/rappi_concept/yunaisky.png'),
    ],
  ),
  ProfileStoreCategory(
    store: Store(user: User(uid: '1')),
    name: 'Picker For You',
    products: [
      ProfileStoreProduct(
          name: 'Sudogwon Millions',
          description:
              'Steamed bao-sandwiches with kimchi, pickled cucumber and mango cubes.',
          price: 26.50,
          image: 'assets/rappi_concept/sudogwonmillions.png'),
      ProfileStoreProduct(
          name: 'Gentle Monster',
          description: 'Mandus mit Shrimps, 4 Stk.',
          price: 12.50,
          image: 'assets/rappi_concept/gentlemonster.png'),
      ProfileStoreProduct(
          name: 'Unified Silla',
          description:
              'Natural planted fried Blumenkohl glasiert mit Gochujang',
          price: 11.50,
          image: 'assets/rappi_concept/unifiedsilla.png'),
      ProfileStoreProduct(
          name: 'Nosan Night',
          description: 'Pikante koreanische Suppe mit Kimchi und Tofu',
          price: 7.50,
          image: 'assets/rappi_concept/nosannight.png'),
      ProfileStoreProduct(
          name: 'Wings of Incheon',
          description: 'Micro-Greens & gerösteten Erbsen, 4 Stk.',
          price: 29.50,
          image: 'assets/rappi_concept/wingsofincheon.png'),
    ],
  ),
  ProfileStoreCategory(
    store: Store(user: User(uid: '1')),
    name: 'Starters',
    products: [
      ProfileStoreProduct(
          name: 'Haeundae Surf',
          description:
              'Chicken-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake- Pilzen, Sesamöl, gerösteten Zwiebeln & Ei.',
          price: 23.50,
          image: 'assets/rappi_concept/haeundaesurf.png'),
      ProfileStoreProduct(
          name: 'Gugudan O’Clock',
          description:
              'Ramen Soup mit Porkbelly & Chicken, homemade Brühe, Shiitake-Pilzen, & Frühlingszwiebeln.',
          price: 24.50,
          image: 'assets/rappi_concept/gugudanoclock.png'),
      ProfileStoreProduct(
          name: 'Koyote Pop',
          description:
              'Marinierter, knuspriger Tofu & Frühlingszwiebeln, garniert mit Sesam.',
          price: 8.50,
          image: 'assets/rappi_concept/koyotepop.png'),
      ProfileStoreProduct(
          name: 'Edamame',
          description: 'Edamame with Korean chili salt.',
          price: 7.50,
          image: 'assets/rappi_concept/edamame.png'),
      ProfileStoreProduct(
          name: 'Late Sunset',
          description:
              'Korean Fried Chicken, Dirty Cheese Sauce & Artisan Sauce.',
          price: 14.50,
          image: 'assets/rappi_concept/latesunset.png'),
    ],
  ),
  ProfileStoreCategory(
    store: Store(user: User(uid: '1')),
    name: 'Sides',
    products: [
      ProfileStoreProduct(
          name: 'Rice',
          description: 'Portion.',
          price: 4.00,
          image: 'assets/rappi_concept/rice.png'),
      ProfileStoreProduct(
          name: 'Cucumber Kimchi',
          description: 'Portion',
          price: 5.00,
          image: 'assets/rappi_concept/cucumberkimchi.png'),
      ProfileStoreProduct(
          name: 'Cabbage Kimchi',
          description: 'Portion',
          price: 8.50,
          image: 'assets/rappi_concept/cabbagekimchi.png'),
      ProfileStoreProduct(
          name: 'Fries',
          description: 'Fries mit Miss Miu Mayo.',
          price: 6.00,
          image: 'assets/rappi_concept/fries.png'),
      ProfileStoreProduct(
          name: 'Carrot Kimchi',
          description: 'Portion',
          price: 14.50,
          image: 'assets/rappi_concept/carrotkimchi.png'),
    ],
  ),

  //repeated items
  ProfileStoreCategory(
    store: Store(user: User(uid: '2')),
    name: 'Orden Again 2',
    products: [
      ProfileStoreProduct(
          name: 'Silim Lights',
          description:
              'Beef-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake-Pilzen, Sesamöl & Ei.',
          price: 26.50,
          image: 'assets/rappi_concept/silimlights.png'),
      ProfileStoreProduct(
          name: 'Udo Island',
          description:
              'Koreanischer Glasnudelsalat mit Gemüse-Pickles, Melon Balls.',
          price: 11.50,
          image: 'assets/rappi_concept/udoisland.png'),
      ProfileStoreProduct(
          name: 'Secret Japanese Pavillon',
          description:
              'Gimbap Korean Sushi Selection mit Bulgogi-Beef, Kimchi & Mango sowie Beef- Tatar, 12 Stück',
          price: 28.50,
          image: 'assets/rappi_concept/secretjapanesepavillon.png'),
      ProfileStoreProduct(
          name: 'Hanok Stay',
          description:
              'Mazemen mit Bulgogi-Beef, Ramen, Ei, Sojasprossen & Frühlingszwiebeln.',
          price: 20.50,
          image: 'assets/rappi_concept/hanokstay.png'),
      ProfileStoreProduct(
          name: 'Yunai Sky',
          description:
              'Bulgogi mit plant-based Beef dazu Reis, Sojasprossen, Frühlingszwiebeln, Kimchi, Salatblätter & Artisan Sauce',
          price: 29.50,
          image: 'assets/rappi_concept/yunaisky.png'),
    ],
  ),
  ProfileStoreCategory(
    store: Store(user: User(uid: '2')),
    name: 'Picker For You 2',
    products: [
      ProfileStoreProduct(
          name: 'Sudogwon Millions',
          description:
              'Steamed bao-sandwiches with kimchi, pickled cucumber and mango cubes.',
          price: 26.50,
          image: 'assets/rappi_concept/sudogwonmillions.png'),
      ProfileStoreProduct(
          name: 'Gentle Monster',
          description: 'Mandus mit Shrimps, 4 Stk.',
          price: 12.50,
          image: 'assets/rappi_concept/gentlemonster.png'),
      ProfileStoreProduct(
          name: 'Unified Silla',
          description:
              'Natural planted fried Blumenkohl glasiert mit Gochujang',
          price: 11.50,
          image: 'assets/rappi_concept/unifiedsilla.png'),
      ProfileStoreProduct(
          name: 'Nosan Night',
          description: 'Pikante koreanische Suppe mit Kimchi und Tofu',
          price: 7.50,
          image: 'assets/rappi_concept/nosannight.png'),
      ProfileStoreProduct(
          name: 'Wings of Incheon',
          description: 'Micro-Greens & gerösteten Erbsen, 4 Stk.',
          price: 29.50,
          image: 'assets/rappi_concept/wingsofincheon.png'),
    ],
  ),
  ProfileStoreCategory(
    store: Store(user: User(uid: '2')),
    name: 'Starters 2',
    products: [
      ProfileStoreProduct(
          name: 'Haeundae Surf',
          description:
              'Chicken-Bibimbap mit Reis, Bohnen, Spinat, Karotten, Shiitake- Pilzen, Sesamöl, gerösteten Zwiebeln & Ei.',
          price: 23.50,
          image: 'assets/rappi_concept/haeundaesurf.png'),
      ProfileStoreProduct(
          name: 'Gugudan O’Clock',
          description:
              'Ramen Soup mit Porkbelly & Chicken, homemade Brühe, Shiitake-Pilzen, & Frühlingszwiebeln.',
          price: 24.50,
          image: 'assets/rappi_concept/gugudanoclock.png'),
      ProfileStoreProduct(
          name: 'Koyote Pop',
          description:
              'Marinierter, knuspriger Tofu & Frühlingszwiebeln, garniert mit Sesam.',
          price: 8.50,
          image: 'assets/rappi_concept/koyotepop.png'),
      ProfileStoreProduct(
          name: 'Edamame',
          description: 'Edamame with Korean chili salt.',
          price: 7.50,
          image: 'assets/rappi_concept/edamame.png'),
      ProfileStoreProduct(
          name: 'Late Sunset',
          description:
              'Korean Fried Chicken, Dirty Cheese Sauce & Artisan Sauce.',
          price: 14.50,
          image: 'assets/rappi_concept/latesunset.png'),
    ],
  ),
  ProfileStoreCategory(
    store: Store(user: User(uid: '2')),
    name: 'Sides 2',
    products: [
      ProfileStoreProduct(
          name: 'Rice',
          description: 'Portion.',
          price: 4.00,
          image: 'assets/rappi_concept/rice.png'),
      ProfileStoreProduct(
          name: 'Cucumber Kimchi',
          description: 'Portion',
          price: 5.00,
          image: 'assets/rappi_concept/cucumberkimchi.png'),
      ProfileStoreProduct(
          name: 'Cabbage Kimchi',
          description: 'Portion',
          price: 8.50,
          image: 'assets/rappi_concept/cabbagekimchi.png'),
      ProfileStoreProduct(
          name: 'Fries',
          description: 'Fries mit Miss Miu Mayo.',
          price: 6.00,
          image: 'assets/rappi_concept/fries.png'),
      ProfileStoreProduct(
          name: 'Carrot Kimchi',
          description: 'Portion',
          price: 14.50,
          image: 'assets/rappi_concept/carrotkimchi.png'),
    ],
  ),
];
