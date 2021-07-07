import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

class FavoritesBLoC with ChangeNotifier {
  List<ProfileStoreProduct> productsFavoritesList = [];

  void favoriteProduct(ProfileStoreProduct product) {
    final item = productsFavoritesList
        .firstWhere((item) => item.id == product.id, orElse: () => null);

    item.isLike = !item.isLike;

    notifyListeners();
  }

  @override
  void dispose() {
    disposeImages();
    super.dispose();
  }

  void disposeImages() {}
}

final productsFavoritesList = FavoritesBLoC();
