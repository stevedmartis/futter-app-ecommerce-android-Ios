import 'package:australti_ecommerce_app/bloc_globals/validators.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';

const categoryHeight = 50.0;

const productHeight = 110.0;

class TabsViewScrollBLoC with ChangeNotifier {
  List<TabCategory> tabs = [];

  List<ProfileStoreItem> items = [];
  List<ProfileStoreProduct> productsByCategoryList = [];
  TabController tabController;
  ScrollController scrollController = ScrollController();
  ScrollController hideBottomNavController;

  ScrollController scrollController2 =
      ScrollController(initialScrollOffset: 260);

  bool _listen = true;
  bool initial = true;

  bool isFollow = false;

  void init(TickerProvider ticker, String storeUserId) {
    final categoriesByStoreUserId =
        rappiCategories.where((i) => i.store.user.uid == storeUserId).toList();

    tabController =
        TabController(vsync: ticker, length: categoriesByStoreUserId.length);

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < categoriesByStoreUserId.length; i++) {
      final category = categoriesByStoreUserId[i];

      offsetFrom = offsetTo;
      offsetTo = offsetFrom +
          rappiCategories[i].products.length * productHeight +
          categoryHeight;

      final item = tabs.firstWhere((item) => item.category.id == category.id,
          orElse: () => null);

      final exist = (item != null) ? true : false;

      if (!exist)
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

  void addNewCategory(TickerProvider ticket, ProfileStoreCategory newCategory) {
    rappiCategories.add(newCategory);

    init(ticket, newCategory.store.user.uid);
  }

  void productsByCategory(String categoryId) {
    final category = rappiCategories.where((i) => i.id == categoryId);
    print(category.single);

    productsByCategoryList = category.single.products;

    print(productsByCategoryList);
    notifyListeners();
  }

  bool _bottomVisible = true;

  bool get bottomVisible => this._bottomVisible;

  set bottomVisible(bool valor) {
    this._bottomVisible = valor;
    notifyListeners();
  }

  void hideScrollListener() {
    hideBottomNavController.addListener(
      () {
        if (hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (bottomVisible) bottomVisible = false;
        }
        if (hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!bottomVisible) bottomVisible = true;
        }
      },
    );
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

  void snapAppbar() async {
    if (scrollController2.offset >= 250 || initial) {
      await scrollController2.animateTo(
        0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      initial = false;
    }
  }

  void initSnapAppbar() async {
    if (scrollController2.offset == 0.0) {
      await scrollController2.animateTo(
        260.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      initial = false;
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();

    if (animationRequired && scrollController2.offset >= 0.0) {
      await scrollController2.animateTo(
        260,
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
        selected.offsetFrom - 80,
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      _listen = true;
    }

    if (scrollController2.offset >= 0.0 && scrollController.offset > 400)
      await scrollController2.animateTo(
        260,
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

class CategoryBloc with Validators {
  final _nameController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _privacityController = BehaviorSubject<bool>();

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  Stream<bool> get privacityStream => _privacityController.stream;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get description => _descriptionController.value;
  bool get privacity => _privacityController.value;

  dispose() {
    _privacityController?.close();

    _nameController?.close();

    _descriptionController?.close();

    //  _roomsController?.close();
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

final tabsViewScrollBLoC = TabsViewScrollBLoC();
