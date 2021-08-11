import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/validators.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

const categoryHeight = 50.0;

class TabsViewScrollBLoC with ChangeNotifier {
  List<TabCategory> tabs = [];

  bool loading = false;
  List<ProfileStoreCategory> myCategories = [];
  List<ProfileStoreItem> items = [];
  List<ProfileStoreItem> itemsOrder = [];
  List<ProfileStoreProduct> productsByCategoryList = [];
  TabController tabController;
  ScrollController scrollController = ScrollController();
  ScrollController hideBottomNavController;

  ScrollController scrollController2 =
      ScrollController(initialScrollOffset: 200.0);

  double initialOffset = 0.0;

  List<http.MultipartFile> imagesProducts = [];

  List<ProfileStoreCategory> storeCategoriesProducts = [];

  bool _listen = true;
  bool initial = true;

  bool initialOK = false;

  bool isFollow = false;

  void addImageProduct(http.MultipartFile file) {
    imagesProducts.add(file);
  }

  void initStoreSelect(
      TickerProvider ticker, BuildContext context, Store store) {
    initialOffset = 220.0;
    scrollController2 = ScrollController(initialScrollOffset: initialOffset);

    final categoriesByStoreUserId = storeCategoriesProducts
        .where((i) => i.store.user.uid == store.user.uid)
        .toList();

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < categoriesByStoreUserId.length; i++) {
      final category = categoriesByStoreUserId[i];

      offsetFrom = offsetTo;
      offsetTo = offsetFrom +
          storeCategoriesProducts[i].products.length * 110 +
          categoryHeight;

      category.position = i;

      if (category.visibility)
        tabs.add(TabCategory(
          category: category,
          selected:
              (category.position == 0 || categoriesByStoreUserId.length == 1),
          offsetFrom: offsetFrom,
          offsetTo: offsetTo,
        ));

      if (category.visibility) {
        items.add(ProfileStoreItem(category: category));

        for (int j = 0; j < category.products.length; j++) {
          final product = category.products[j];

          items.add(ProfileStoreItem(product: product));
        }
      }

      tabController = TabController(vsync: ticker, length: tabs.length);

      initialOK = true;

      tabs.sort((a, b) {
        return a.category.position.compareTo(b.category.position);
      });
    }

    scrollController.addListener(_onScrollListener);

    scrollController2 = ScrollController()..addListener(() => {});
  }

  void init(TickerProvider ticker, BuildContext context) {
    initialOffset = 260.0;
    scrollController2 = ScrollController(initialScrollOffset: initialOffset);
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    final categoriesByStoreUserId = storeCategoriesProducts
        .where((i) => i.store.user.uid == authBloc.storeAuth.user.uid)
        .toList();

    tabController =
        TabController(vsync: ticker, length: categoriesByStoreUserId.length);

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < categoriesByStoreUserId.length; i++) {
      final category = categoriesByStoreUserId[i];

      offsetFrom = offsetTo;
      offsetTo = offsetFrom +
          storeCategoriesProducts[i].products.length * 110 +
          categoryHeight;

      final item = tabs.firstWhere((item) => item.category.id == category.id,
          orElse: () => null);

      category.position = i;

      final exist = (item != null) ? true : false;

      if (!exist)
        tabs.add(TabCategory(
          category: category,
          selected:
              (category.position == 0 || categoriesByStoreUserId.length == 1),
          offsetFrom: offsetFrom,
          offsetTo: offsetTo,
        ));

      if (!exist) items.add(ProfileStoreItem(category: category));

      if (!exist)
        for (int j = 0; j < category.products.length; j++) {
          final product = category.products[j];

          items.add(ProfileStoreItem(product: product));
        }

      tabs.sort((a, b) {
        return a.category.position.compareTo(b.category.position);
      });
    }

    scrollController.addListener(_onScrollListener);

    if (authBloc.storeAuth.user.first && categoriesByStoreUserId.length == 0)
      scrollController2 = ScrollController()..addListener(() => {});
  }

  sharedProductOnStoreCurrent(String value) {
    if (value.length >= 3) {
      final find = items.where((item) => (item.product != null)
          ? item.product.name.toLowerCase().contains(value.toLowerCase())
          : item.category.name.toLowerCase().contains(value.toLowerCase()));

      if (find.length > 0) {
        final item = tabs.where(
          (item) => item.category.id == find.first.product.category,
        );

        final indexCategory = tabs.indexOf(item.first);
        // final indexCategory = items.indexOf(categoryById);

        onCategorySelected(indexCategory, animationRequired: true);
      }
    } else if (value.length == 0) {
      onCategorySelected(0, animationRequired: true);
    }

    //value not exists
  }

  orderPosition(TickerProvider ticket,
      List<ProfileStoreCategory> storeCategories, BuildContext context) {
    items = [];
    tabs = [];

    storeCategoriesProducts = storeCategories;

    init(ticket, context);
    notifyListeners();
  }

  void changeLoading() {
    loading = !loading;
    notifyListeners();
  }

  void addNewCategory(TickerProvider ticket, ProfileStoreCategory newCategory,
      BuildContext context) {
    storeCategoriesProducts.add(newCategory);

    init(ticket, context);
  }

  void editCategory(TickerProvider ticket, ProfileStoreCategory editCategory,
      BuildContext context) {
    final item = tabs.firstWhere((item) => item.category.id == editCategory.id,
        orElse: () => null);

    item.category.name = editCategory.name;
    item.category.description = editCategory.description;
    item.category.visibility = editCategory.visibility;

    final categoryExit = storeCategoriesProducts
        .firstWhere((item) => item.id == editCategory.id, orElse: () => null);

    categoryExit.name = editCategory.name;
    categoryExit.description = editCategory.description;
    categoryExit.visibility = editCategory.visibility;

    init(ticket, context);
  }

  void removeCategoryById(TickerProvider ticket, String categoryId, String uid,
      BuildContext context) {
    tabs = [];
    items = [];
    storeCategoriesProducts
        .removeWhere((categories) => categories.id == categoryId);

    tabs.removeWhere((tab) => tab.category.id == categoryId);

    init(ticket, context);

    notifyListeners();
  }

  void productsByCategory(String categoryId) {
    final category = storeCategoriesProducts.where((i) => i.id == categoryId);

    if (category != null) productsByCategoryList = category.single.products;
  }

  void addProductsByCategory(TickerProvider ticket, ProfileStoreProduct product,
      BuildContext context) {
    productsByCategoryList.add(product);

    tabs = [];
    items = [];
    init(ticket, context);

    notifyListeners();
  }

  void removeProductById(TickerProvider ticket, ProfileStoreProduct product,
      String user, BuildContext context) {
    final item = tabs.firstWhere((item) => item.category.id == product.category,
        orElse: () => null);

    item.category.products.removeWhere((product) => product.id == product.id);
    productsByCategoryList.removeWhere((product) => product.id == product.id);

    tabs = [];
    items = [];

    init(ticket, context);
    notifyListeners();
  }

  void editProduct(TickerProvider ticket, ProfileStoreProduct product) {
    if (productsByCategoryList.length == 0)
      productsByCategory(product.category);

    final item = productsByCategoryList
        .firstWhere((item) => item.id == product.id, orElse: () => null);

    item.name = product.name;
    item.description = product.description;
    item.price = product.price;
    item.images = product.images;

    notifyListeners();
  }

  void favoriteProduct(TickerProvider ticket, ProfileStoreProduct product) {
    if (items.length > 0) {
      final item = items.firstWhere((item) => item.product.id == product.id,
          orElse: () => null);

      item.product.isLike = !item.product.isLike;

      notifyListeners();
    }
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
      if (tabs.length > 0)
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
    if (scrollController2.offset >= initialOffset || initial) {
      await scrollController2.animateTo(
        0.0,
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
        initialOffset,
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
        initialOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    scrollController2?.dispose();
    tabController.dispose();
    imagesProducts.clear();
    disposeImages();
    super.dispose();
  }

  void disposeImages() {
    imagesProducts = [];
    imagesProducts.clear();
  }
}

class CategoryBloc with Validators {
  final _nameController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _privacityController = BehaviorSubject<bool>();

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validationOk);

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(nameStream, descriptionStream, (a, b) => true);

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

class ProductBloc with Validators {
  final _nameController = BehaviorSubject<String>();

  final _descriptionController = BehaviorSubject<String>();

  final _privacityController = BehaviorSubject<bool>();

  final _priceController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get nameStream =>
      _nameController.stream.transform(validationNameRequired);
  Stream<String> get descriptionStream => _descriptionController.stream;

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  Stream<bool> get privacityStream => _privacityController.stream;

  Stream<String> get priceSteam => _priceController.stream;

  Function(String) get changePrice => _priceController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get description => _descriptionController.value;
  bool get privacity => _privacityController.value;
  String get price => _priceController.value;

  dispose() {
    _privacityController?.close();

    _nameController?.close();

    _descriptionController?.close();
    _priceController?.close();

    //  _roomsController?.close();
  }
}

class TabCategory {
  TabCategory({
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
  bool selected;
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
