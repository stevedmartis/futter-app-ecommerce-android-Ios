import 'package:flutter/material.dart';
import 'package:youtube_diegoveloper_challenges/store_product_concept/store_product_data.dart';

const categoryHeight = 55.0;
const productHeight = 110.0;

class TabsViewScrollBLoC with ChangeNotifier {
  List<TabCategory> tabs = [];
  List<ProfileStoreItem> items = [];
  TabController tabController;
  ScrollController scrollController = ScrollController();

  ScrollController scrollController2 = ScrollController();

  bool _listen = true;

  void init(TickerProvider ticker) {
    tabController =
        TabController(vsync: ticker, length: rappiCategories.length);

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < rappiCategories.length; i++) {
      final category = rappiCategories[i];

      offsetFrom = offsetTo;
      offsetTo = offsetFrom +
          rappiCategories[i].products.length * productHeight +
          categoryHeight;

      tabs.add(TabCategory(
        category: category,
        selected: (i == 0),
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      ));
      items.add(ProfileStoreItem(category: category));
      for (int j = 0; j < category.products.length; j++) {
        final product = category.products[j];
        items.add(ProfileStoreItem(product: product));
      }
    }

    scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];
        if (scrollController.offset >= tab.offsetFrom &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);

          tabController.animateTo(i);

          break;
        }
      }
    }
  }

  void snapAppbar() {
    final scrollDistance = 500.0 - 35;

    print(scrollController2.offset);

    if (scrollController2.offset > 0 &&
        scrollController2.offset < scrollDistance) {
      final double snapOffset =
          scrollController2.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => scrollController2.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();

    if (animationRequired && scrollController2.offset == 0.0) {
      await scrollController2.animateTo(
        450,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );

      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      _listen = true;
    } else if (animationRequired && scrollController2.offset > 400.0) {
      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      _listen = true;
    }

    if (scrollController2.offset == 0.0)
      await scrollController2.animateTo(
        450,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollListener);
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
}

class TabCategory {
  const TabCategory({
    @required this.category,
    @required this.selected,
    @required this.offsetFrom,
    @required this.offsetTo,
  });

  TabCategory copyWith(bool selected) => TabCategory(
        category: category,
        selected: selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );

  final ProfileStoreCategory category;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;
}

class ProfileStoreItem {
  const ProfileStoreItem({
    this.category,
    this.product,
  });
  final ProfileStoreCategory category;
  final ProfileStoreProduct product;
  bool get isCategory => category != null;
}
