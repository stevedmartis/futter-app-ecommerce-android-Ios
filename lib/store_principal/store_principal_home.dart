import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/bloc/cards_services_bloc.dart';

import 'package:freeily/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:freeily/bloc_globals/notitification.dart';
import 'package:freeily/grocery_store/grocery_store_bloc.dart';
import 'package:freeily/models/Address.dart';

import 'package:freeily/models/grocery_Store.dart';
import 'package:freeily/models/store.dart';

import 'package:freeily/pages/order_progress.dart/progressBar.dart';

import 'package:freeily/pages/search_principal_page.dart';
import 'package:freeily/preferences/user_preferences.dart';
import 'package:freeily/profile_store.dart/profile.dart';
import 'package:freeily/responses/orderStoresProduct.dart';
import 'package:freeily/responses/stores_list_principal_response.dart';
import 'package:freeily/routes/routes.dart';
import 'package:freeily/services/order_service.dart';
import 'package:freeily/services/stores_Services.dart';

import 'package:freeily/store_principal/store_Service.dart';
import 'package:freeily/store_principal/store_principal_bloc.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/circular_progress.dart';
import 'package:freeily/widgets/cross_fade.dart';
import 'package:freeily/widgets/image_cached.dart';
import 'package:freeily/widgets/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../global/extension.dart';
import 'package:freeily/services/stores_Services.dart' as storeServices;

class StorePrincipalHome extends StatefulWidget {
  @override
  _StorePrincipalHomeState createState() => _StorePrincipalHomeState();
}

class _StorePrincipalHomeState extends State<StorePrincipalHome> {
  ScrollController _scrollController;

  bool _isVisible = true;
  final prefs = new AuthUserPreferences();

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 150;
  }

  bool isItems = false;
  bool loading = true;

  bool loadingOrders = false;
  ValueNotifier<bool> notifierBottomBarVisible = ValueNotifier(true);

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    this.bottomControll();

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    storeBloc.selected = storeBloc.servicesStores[0];

    super.initState();
  }

  bottomControll() {
    _isVisible = true;

    final bloc = Provider.of<StoreBLoC>(context, listen: false);
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    _scrollController.addListener(
      () {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
              bloc.bottomNavigation(false);
            });
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
              bloc.bottomNavigation(true);
            });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController?.dispose();
  }

  getCartSave() async {
    final bloc = Provider.of<GroceryStoreBLoC>(context, listen: false);

    final stringCart = await getListCart('cart');

    final cart = cartProductsFromJson(stringCart);
    if (cart.length > 0) {
      bloc.cartSavetoCart(cart);
      bloc.totalCartElements();

      setState(() {
        isItems = bloc.totalCartElements() > 0 ? true : false;
      });
    }
  }

  pullToRefreshData() async {
    final cardBloc = Provider.of<CreditCardServices>(context, listen: false);
    HapticFeedback.heavyImpact();

    if (storeAuth.user.uid != '0') {
      final address = storeAuth.address.split(',').first;
      storesByLocationlistServices(address, storeAuth.city, storeAuth.user.uid);
      _myOrdersClient();

      cardBloc.getMyCreditCards(storeAuth.user.uid);
      if (storeAuth.service != 0) {
        _myOrdersStore();
      }
    } else if (prefs.addressSearchSave != '') {
      final address =
          prefs.addressSearchSave.mainText.toString().split(",").first;
      storesByLocationlistServices(
          address, prefs.addressSearchSave.secondaryText, storeAuth.user.uid);
    } else {
      storeslistServices();
    }
  }

  void _myOrdersClient() async {
    final orderService = Provider.of<OrderService>(context, listen: false);

    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;

    if (orderService.loading)
      setState(() {
        orderService.loading = false;
      });

    final OrderStoresProducts resp =
        await orderService.getMyOrders(storeAuth.user.uid);

    orderService.orders = [];
    if (resp.ok) {
      final List<Order> orderNotificationStore = resp.orders
          .where((i) =>
              !i.isFinalice ||
              i.isNotifiCheckClient ||
              i.isCancelByClient ||
              i.isCancelByStore)
          .toList();
      orderService.orders = orderNotificationStore;

      number = orderNotificationStore.length;

      notifiModel.numberNotifiBell = number;

      if (!orderService.loading)
        Timer(new Duration(milliseconds: 300), () {
          setState(() {
            orderService.loading = true;
          });
        });

      notifiModel.numberSteamNotifiBell.sink.add(number);
      if (number >= 2) {
        notifiModel.bounceControllerBell;
        //controller.forward(from: 0.0);
      }
    }
  }

  void _myOrdersStore() async {
    final orderService = Provider.of<OrderService>(context, listen: false);

    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;

    orderService.ordersStore = [];

    if (orderService.loading)
      setState(() {
        orderService.loading = false;
      });

    final OrderStoresProducts resp =
        await orderService.getMyOrdesStore(storeAuth.user.uid);

    if (resp.ok) {
      final List<Order> orderNotificationStore = resp.orders
          .where((i) =>
              !i.isFinalice ||
              i.isNotifiCheckStore ||
              i.isCancelByClient ||
              i.isCancelByStore)
          .toList();

      orderService.ordersStore = orderNotificationStore;

      notifiModel.numberNotifiBell = number;

      if (!orderService.loading)
        Timer(new Duration(milliseconds: 300), () {
          setState(() {
            orderService.loading = true;
          });
        });

      number = orderNotificationStore.length;
      notifiModel.numberSteamNotifiBell.sink.add(number);
      if (number >= 2) {
        notifiModel.bounceControllerBell;
        //controller.forward(from: 0.0);
      }
    }
  }

  void storesByLocationlistServices(
      String address, String location, String uid) async {
    final storeService =
        Provider.of<storeServices.StoreService>(context, listen: false);

    final StoresListResponse resp = await storeService
        .getStoresLocationListServices(address, location, uid);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.chargeServicesStores(resp.storeListServices);
      changeToCurrentService();
    }
  }

  changeToCurrentService() {
    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);
    if (storeBloc.selected.id == 1) storeBloc.changeToMarket();

    if (storeBloc.selected.id == 2) storeBloc.changeToRestaurant();

    if (storeBloc.selected.id == 3) storeBloc.changeToLiqueur();
  }

  void storeslistServices() async {
    final storeService =
        Provider.of<storeServices.StoreService>(context, listen: false);

    final StoresListResponse resp =
        await storeService.getStoresListServices(storeAuth.user.uid);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.chargeServicesStores(resp.storeListServices);

      changeToCurrentService();

      setState(() {
        loading = false;
      });
    }
  }

  Future<String> getListCart(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    return myPrefs.getString(key) ?? '[]';
  }

  Store storeAuth;
  bool loadingOK = false;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final authService = Provider.of<AuthenticationBLoC>(context);

    final bloc = Provider.of<StoreBLoC>(context);

    final groceryBloc = Provider.of<GroceryStoreBLoC>(context);

    final orderService = Provider.of<OrderService>(context);

    final notifiBloc = Provider.of<NotificationModel>(context);
    final size = MediaQuery.of(context).size;

    isItems = groceryBloc.totalCartElements() > 0 ? true : false;
    storeAuth = authService.storeAuth;

    List<Order> orderClientActive =
        orderService.orders.where((i) => i.isActive && !i.isFinalice).toList();

    List<Order> ordersStoreActive = orderService.ordersStore
        .where((i) => i.isActive && !i.isFinalice)
        .toList();

    if (groceryBloc.isReload) this.getCartSave();
    groceryBloc.changeReaload();

    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: RefreshIndicator(
          color: currentTheme.primaryColor,
          onRefresh: () => pullToRefreshData(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                leadingWidth: 70,
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                leading: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        if (storeAuth.user.uid == '0') {
                          authService.redirect = 'profile';
                          Navigator.push(context, loginRoute());
                        } else {
                          authService.redirect = 'home';
                          Navigator.push(context, profileAuthRoute(true));
                        }
                      },
                      child: Container(
                          width: 100,
                          height: 100,
                          child: Hero(
                            tag: 'user_auth_avatar',
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              child: (authService.storeAuth.imageAvatar != "")
                                  ? Container(
                                      width: 150,
                                      height: 150,
                                      child: cachedNetworkImage(
                                        authService.storeAuth.imageAvatar,
                                      ),
                                    )
                                  : Image.asset(currentProfile.imageAvatar),
                            ),
                          )),
                    )),
                actions: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(context, notificationsRoute());
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                            stream: notifiBloc.numberSteamNotifiBell,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              int number =
                                  (snapshot.data != null) ? snapshot.data : 0;

                              return Container(
                                child: Swing(
                                  animate: number > 0,
                                  delay: Duration(seconds: 1),
                                  controller: (controller) =>
                                      Provider.of<NotificationModel>(context)
                                          .bounceControllerBell = controller,
                                  child: Stack(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: FaIcon(
                                            FontAwesomeIcons.bell,
                                            color: Colors.white,
                                            size: 25,
                                          )),
                                      if (number > 0)
                                        Container(
                                          child: Container(
                                            child: Text(
                                              '$number',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            alignment: Alignment.center,
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color:
                                                    currentTheme.primaryColor,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Swing(
                            animate: isItems,
                            delay: Duration(seconds: 1),
                            controller: (controller) =>
                                Provider.of<NotificationModel>(context)
                                    .bounceControllerBell = controller,
                            child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();

                                  if (bloc.loadingStores)
                                    showMaterialCupertinoBottomSheet(context);
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: isItems ? 0 : 5),
                                  child: Stack(
                                    children: [
                                      Container(
                                          child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                      Container(
                                        child: (groceryBloc
                                                    .totalCartElements() >
                                                0)
                                            ? Container(
                                                child: Text(
                                                  groceryBloc.cart.length
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                alignment: Alignment.center,
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff32D73F),
                                                    shape: BoxShape.circle),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                stretch: true,
                expandedHeight: size.height / 4,
                collapsedHeight: 70,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                    // StretchMode.blurBackground
                  ],
                  background: Material(
                    type: MaterialType.transparency,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 700),
                            child: StoreServiceDetails(
                              key: Key(bloc.selected.name),
                              storeService: bloc.selected,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                  title: OpenContainer(
                      closedElevation: 5,
                      openElevation: 5,
                      closedColor: (_showTitle)
                          ? currentTheme.cardColor
                          : Colors.black.withOpacity(0.20),
                      openColor: (_showTitle)
                          ? currentTheme.cardColor
                          : Colors.black.withOpacity(0.20),
                      transitionType: ContainerTransitionType.fade,
                      openShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      openBuilder: (_, closeContainer) {
                        return SearchPrincipalPage(
                            storeListServices: bloc.storesListInitial);
                      },
                      closedBuilder: (_, openContainer) {
                        return Container(child: MyTextField(_showTitle));
                      }),
                ),
              ),
              if (orderClientActive.length > 0) makeSpaceTitle(),
              if (orderClientActive.length > 0)
                makeListHorizontalCarouselOrdersProgress(
                    context, orderClientActive, ordersStoreActive),
              if (storeAuth.service != 0 && ordersStoreActive.length > 0)
                if (ordersStoreActive.length > 0 &&
                    orderClientActive.length == 0)
                  makeSpaceTitle(),
              makeListHorizontalCarouselOrdersStoreProgress(
                  context, ordersStoreActive),
              makeSpaceTitle(),
              if (orderService.loading)
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: size.height / 5.5,
                  collapsedHeight: size.height / 5.5,
                  pinned: false,
                  actionsIconTheme: IconThemeData(opacity: 0.0),
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Material(
                            type: MaterialType.transparency,
                            child: Container(
                                color: currentTheme.scaffoldBackgroundColor,
                                child: StoreServicesList(
                                  onPhotoSelected: (item) => {
                                    _changeService(bloc, item.id),
                                    setState(() {
                                      HapticFeedback.lightImpact();
                                      bloc.selected = item;
                                    })
                                  },
                                ))),
                      )
                    ],
                  ),
                ),
              makeSpaceTitle(),
              if (orderService.loading)
                makeHeaderTitle(context, bloc.selected.name),
              if (orderService.loading) makeListRecomendations(loading),
            ],
          ),
        ));
  }
}

SliverPersistentHeader makeHeaderPrincipal(context) {
  final size = MediaQuery.of(context).size;

  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 120,
          maxHeight: size.height / 1.55,
          child: Container(
              color: currentTheme.scaffoldBackgroundColor,
              child: Container(color: Colors.black, child: HeaderCustom()))));
}

SliverPersistentHeader makeSpaceTitle() {
  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 10.0, maxHeight: 10.0, child: Container()));
}

SliverPersistentHeader makeHeaderTitle(context, String titleService) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 40,
          maxHeight: 40,
          child: FadeIn(
            delay: Duration(milliseconds: 500),
            child: Container(
              color: currentTheme.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 10),
                child: CrossFade<String>(
                  initialData: '',
                  data: titleService,
                  builder: (value) => Container(
                    child: Text(
                      titleService,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )));
}

SliverList makeListRecomendations(bool loading) {
  return SliverList(
    delegate: SliverChildListDelegate([
      FadeIn(
        delay: Duration(milliseconds: 600),
        child: Container(
            child: StoresListByService(
          loading: loading,
        )),
      ),
    ]),
  );
}

SliverList makeListHorizontalCarouselOrdersProgress(context,
    List<Order> orderNotificationClient, List<Order> orderNotificationStore) {
  final orderService = Provider.of<OrderService>(context);
  final size = MediaQuery.of(context).size;
  return SliverList(
    delegate: SliverChildListDelegate([
      SizedBox(
        child: (orderService.orders.length > 0)
            ? FadeInRight(
                child: CarouselSlider(
                  items: List.generate(
                    orderNotificationClient.length,
                    (index) => OrderprogressStoreCard(
                      order: orderNotificationClient[index],
                      isStore: false,
                    ),
                  ),
                  options: CarouselOptions(
                      viewportFraction:
                          (orderNotificationClient.length > 1) ? 0.8 : 0.9,
                      aspectRatio: size.height / 250,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {}),
                ),
              )
            : Container(),
      ),
    ]),
  );
}

SliverList makeListHorizontalCarouselOrdersStoreProgress(
    context, List<Order> orderNotificationStore) {
  final size = MediaQuery.of(context).size;
  return SliverList(
    delegate: SliverChildListDelegate([
      SizedBox(
        child: (orderNotificationStore.length > 0)
            ? FadeInRight(
                child: CarouselSlider(
                  items: List.generate(
                    orderNotificationStore.length,
                    (index) => OrderprogressStoreCard(
                      order: orderNotificationStore[index],
                      isStore: true,
                    ),
                  ),
                  options: CarouselOptions(
                      viewportFraction:
                          (orderNotificationStore.length > 1) ? 0.8 : 0.9,
                      aspectRatio: size.height / 250,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {}),
                ),
              )
            : Container(),
      ),
    ]),
  );
}

class OrderprogressStoreCard extends StatefulWidget {
  OrderprogressStoreCard({this.order, this.isStore = false});

  final Order order;

  final bool isStore;

  @override
  _OrderprogressStoreCardState createState() => _OrderprogressStoreCardState();
}

class _OrderprogressStoreCardState extends State<OrderprogressStoreCard> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final notifiBloc = Provider.of<NotificationModel>(context);

    final id = widget.order.id;

    final store = widget.order.store;

    final timeDelivery =
        '${store.timeDelivery}  ${store.timeSelect.toLowerCase()}';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
            context, orderProggressRoute(widget.order, false, widget.isStore));
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: currentTheme.cardColor,
        child: Padding(
          padding: EdgeInsets.only(left: 15, bottom: 0),
          child: SizedBox(
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: Hero(
                    tag: 'order/$id',
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        child: (store.imageAvatar != "")
                            ? Container(
                                child: cachedNetworkImage(
                                  store.imageAvatar,
                                ),
                              )
                            : Image.asset(currentProfile.imageAvatar),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Row(
                        children: [
                          if (!widget.isStore)
                            Container(
                                padding: EdgeInsets.only(top: 10, right: 10),
                                child: Text(
                                  (!widget.order.isCancelByClient &&
                                          !widget.order.isCancelByStore)
                                      ? (!widget.order.isPreparation &&
                                              !widget.order.isDelivery)
                                          ? 'Pedido enviado'
                                          : (widget.order.isPreparation &&
                                                  !widget.order.isDelivery)
                                              ? 'Pedido en preparación'
                                              : (widget.order.isDelivery &&
                                                      !widget.order.isDelivered)
                                                  ? 'Pedido en camino'
                                                  : 'Pedido Entregado.'
                                      : 'Pedido cancelado',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                          if (widget.isStore)
                            Container(
                                padding: EdgeInsets.only(top: 10, right: 10),
                                child: Text(
                                  (!widget.order.isCancelByClient &&
                                          !widget.order.isCancelByStore)
                                      ? (!widget.order.isPreparation &&
                                              !widget.order.isDelivery)
                                          ? 'Pedido recibido'
                                          : (widget.order.isPreparation &&
                                                  !widget.order.isDelivery)
                                              ? 'Pedido en preparación'
                                              : (widget.order.isDelivery &&
                                                      !widget.order.isDelivered)
                                                  ? 'Pedido en curso'
                                                  : 'Pedido Entregado.'
                                      : 'Pedido cancelado',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                          if (widget.isStore)
                            if (widget.order.isNotifiCheckStore)
                              StreamBuilder(
                                stream: notifiBloc.numberSteamNotifiBell,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  int number = (snapshot.data != null)
                                      ? snapshot.data
                                      : 0;

                                  if (number > 0)
                                    return Container(
                                      margin: EdgeInsets.only(right: 0),
                                      alignment: Alignment.centerRight,
                                      child: BounceInDown(
                                        from: 5,
                                        animate: (number > 0) ? true : false,
                                        child: Bounce(
                                          delay: Duration(seconds: 2),
                                          from: 5,
                                          controller: (controller) =>
                                              Provider.of<NotificationModel>(
                                                          context)
                                                      .bounceControllerBell =
                                                  controller,
                                          child: Container(
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            alignment: Alignment.center,
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color:
                                                    currentTheme.primaryColor,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                                    );

                                  return Container();
                                },
                              ),
                          if (!widget.isStore)
                            if (widget.order.isNotifiCheckClient)
                              StreamBuilder(
                                stream: notifiBloc.numberSteamNotifiBell,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  int number = (snapshot.data != null)
                                      ? snapshot.data
                                      : 0;

                                  if (number > 0)
                                    return Container(
                                      margin: EdgeInsets.only(right: 0),
                                      alignment: Alignment.centerRight,
                                      child: BounceInDown(
                                        from: 5,
                                        animate: (number > 0) ? true : false,
                                        child: Bounce(
                                          delay: Duration(seconds: 2),
                                          from: 5,
                                          controller: (controller) =>
                                              Provider.of<NotificationModel>(
                                                          context)
                                                      .bounceControllerBell =
                                                  controller,
                                          child: Container(
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            alignment: Alignment.center,
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color:
                                                    currentTheme.primaryColor,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                                    );

                                  return Container();
                                },
                              )
                        ],
                      ),
                      Container(
                        child: Text(
                          (!widget.isStore)
                              ? (store.timeDelivery != "")
                                  ? 'Entrega estimada: $timeDelivery'
                                  : 'Entrega estimada: 24 - 48 hrs.'
                              : 'Entrega estimada: $timeDelivery',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            child: ProgressBar(
                          key: ValueKey('order/$id'),
                          order: widget.order,
                          principal: true,
                          isStore: widget.isStore,
                        )),
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoresListByService extends StatelessWidget {
  const StoresListByService({Key key, this.loading}) : super(key: key);

  final bool loading;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<StoreBLoC>(context);

    return SizedBox(
      child: (bloc.loadingStores)
          ? (bloc.storesListState.length > 0)
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bloc.storesListState.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    final store = bloc.storesListState[index];

                    return Stack(
                      children: [
                        FadeIn(
                          child: StoreCard(
                            store: store,
                          ),
                        ),
                      ],
                    );
                  })
              : Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      (bloc.selected.id == 0)
                          ? 'No tienes ${bloc.selected.name} en esta ubicación'
                          : 'No hay ${bloc.selected.name} en esta ubicación',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
          : buildLoadingWidget(context),
    );
  }
}

class HeaderCustom extends StatefulWidget {
  @override
  _HeaderCustomState createState() => _HeaderCustomState();
}

StoreServices selected;

class _HeaderCustomState extends State<HeaderCustom> {
  @override
  void initState() {
    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    selected = storeBloc.servicesStores.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topCardHeight = 50;
    final horizontalListHeight = 160.0;
    final bloc = Provider.of<StoreBLoC>(context);

    return Stack(
      children: <Widget>[
        /*  Positioned(
          height: topCardHeight,
          left: 0,
          right: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: StoreServiceDetails(
              key: Key(_selected.name),
              storeService: _selected,
            ),
          ),
        ), */

        Positioned(
          left: 0,
          right: 0,
          top: topCardHeight - horizontalListHeight / 3,
          height: horizontalListHeight,
          child: StoreServicesList(
            onPhotoSelected: (item) => {
              _changeService(bloc, item.id),
              setState(() {
                HapticFeedback.lightImpact();
                selected = item;
              })
            },
          ),
        ),
      ],
    );
  }
}

void _changeService(StoreBLoC bloc, int id) {
  if (id == 2) {
    bloc.changeToRestaurant();
  } else if (id == 1) {
    bloc.changeToMarket();
  } else if (id == 3) {
    bloc.changeToLiqueur();
  } else if (id == 0) {
    bloc.changeToFollowed();
  } else if (id == 4) {
    bloc.changeToModa();
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverCustomHeaderDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class StoreCard extends StatelessWidget {
  StoreCard({this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final timeDelivery =
        '${store.timeDelivery}  ${store.timeSelect.toLowerCase()}';
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(context, profileCartRoute(store));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: size.height / 7,
          child: Row(
            children: <Widget>[
              Hero(
                tag: 'user_auth_avatar_list_${store.imageAvatar}',
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: (store.imageAvatar != "")
                        ? Container(
                            child: cachedNetworkImage(
                              store.imageAvatar,
                            ),
                          )
                        : Image.asset(currentProfile.imageAvatar),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      (store.timeDelivery != "") ? '$timeDelivery' : '',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  Container(
                    child: Text(
                      '${store.name.capitalize()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        if (store.about != "")
                          Container(
                            child: Chip(
                              backgroundColor:
                                  Color(int.parse(store.colorVibrant)),
                              labelStyle: TextStyle(color: Colors.white),
                              label: Text('${store.about.capitalize()}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (store.percentOff != 0)
                    Container(
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              FaIcon(FontAwesomeIcons.certificate,
                                  size: 15, color: Colors.blueAccent),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 4,
                                  top: 4,
                                ),
                                child: FaIcon(FontAwesomeIcons.percent,
                                    size: 7,
                                    color:
                                        currentTheme.scaffoldBackgroundColor),
                              ),
                            ],
                          ),
                          SizedBox(width: 5.0),
                          Container(
                            child: Text(
                              'Hasta ${store.percentOff}% OFF',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreServiceDetails extends StatefulWidget {
  final StoreServices storeService;

  const StoreServiceDetails({Key key, this.storeService}) : super(key: key);

  @override
  _StoreServiceDetailsState createState() => _StoreServiceDetailsState();
}

List<Address> addresses = [];
Address nameAddress = Address(addressLine: '');
final prefs = new AuthUserPreferences();

class _StoreServiceDetailsState extends State<StoreServiceDetails>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final _movement = -100.0;

  int _selectedGender = 0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//

// From coordinates

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final authBloc = Provider.of<AuthenticationBLoC>(context);

    final _size = MediaQuery.of(context).size;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  left: _movement * _controller.value,
                  right: _movement * (1 - _controller.value),
                  child: ClipRRect(
                    child: Container(
                        child: cachedServiceNetworkImage(
                            widget.storeService.backImage)),
                  ),
                ),
                Positioned.fill(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                          ),
                        ),
                      )),
                ),
                /* Positioned(
                  top: 70,
                  left: 10,
                  right: 10,
                  height: 40,
                  child: FittedBox(
                    child: Text(
                      widget.storeService.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ), */
                Positioned(
                    top: 15.0,
                    left: 10,
                    right: 10,
                    height: 40,
                    child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();

                            showModalLocation(
                                context,
                                _selectedGender,
                                (prefs.addressSearchSave != '')
                                    ? prefs.addressSearchSave.secondaryText
                                    : '',
                                authBloc.storeAuth.user.uid);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.location_on,
                                    color: currentTheme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: _size.width / 3,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        prefs.addressSearchSave != ''
                                            ? '${prefs.addressSearchSave.mainText}'
                                            : 'Mi ubicación',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        //'${state.location.latitude}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.white70),
                                      )),
                                ),
                                GestureDetector(
                                  child: Container(
                                    child: Icon(Icons.expand_more,
                                        color: currentTheme.primaryColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))),
              ],
            ),
          );
        });
  }
}

void storesByLocationlistServices(
    context, String address, String location, String uid) async {
  final storeService = Provider.of<StoreService>(context, listen: false);
  final StoresListResponse resp =
      await storeService.getStoresLocationListServices(address, location, uid);
  final storeBloc = Provider.of<StoreBLoC>(context, listen: false);
  if (resp.ok) {
    storeBloc.chargeServicesStores(resp.storeListServices);
  }
}

const List<Color> gradients = [
  Color(0xffEC4E56),
  Color(0xffF78C39),
  Color(0xffFEB42C),
];

class MyTextField extends StatelessWidget {
  MyTextField(this.showTitle);
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);

    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: size.width / 1.7,
        height: 40,
        decoration: BoxDecoration(
            color: (showTitle)
                ? currentTheme.currentTheme.cardColor
                : currentTheme.currentTheme.cardColor.withOpacity(0.0),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 0),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 2,
                  child: Text('Tiendas o productos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300))),
              Expanded(
                child: AnimatedContainer(
                    margin: EdgeInsets.all(3),
                    duration: Duration(milliseconds: 200),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 35,
                      height: 36,
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            offset: Offset(3.0, 3.0),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          )
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        gradient: LinearGradient(
                            colors: gradients,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}

void showModalLocation(context, selectedGender, String uid, String location) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  showLocationMaterialCupertinoBottomSheet(
    context,
    () {
      HapticFeedback.lightImpact();
      myLocationBloc.initPositionLocation(context);

      Navigator.pop(context);
    },
    () {
      Navigator.pop(context);
    },
    Radio(
      activeColor: currentTheme.primaryColor,
      value: 0,
      groupValue: 0,
      onChanged: (value) {
        selectedGender = value;
      },
    ),
  );
}

class StoreServicesList extends StatefulWidget {
  const StoreServicesList({Key key, this.onPhotoSelected}) : super(key: key);
  final ValueChanged<StoreServices> onPhotoSelected;

  @override
  _StoreServicesListState createState() => _StoreServicesListState();
}

class _StoreServicesListState extends State<StoreServicesList> {
  final _animatedListKey = GlobalKey<AnimatedListState>();

  final _pageController = PageController();

  double page = 0.0;

  void _listenScroll() {
    setState(() {
      page = _pageController.page;
    });
  }

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeBloc = Provider.of<StoreBLoC>(context);

    return AnimatedList(
      key: _animatedListKey,
      physics: PageScrollPhysics(),
      controller: _pageController,
      itemBuilder: (context, index, animation) {
        final travelPhotoItem = storeBloc.servicesStores[index];
        final percent = page - page.floor();
        final factor = percent > 0.5 ? (1 - percent) : percent;
        return InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              storeBloc.servicesStores
                  .insert(storeBloc.servicesStores.length, travelPhotoItem);
              _animatedListKey.currentState
                  .insertItem(storeBloc.servicesStores.length - 1);
              final itemToDelete = travelPhotoItem;
              widget.onPhotoSelected(travelPhotoItem);
              storeBloc.servicesStores.removeAt(index);
              _animatedListKey.currentState.removeItem(
                index,
                (context, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: TravelPhotoListItem(
                      travelPhoto: itemToDelete,
                    ),
                  ),
                ),
              );
            },
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(
                  vector.radians(
                    90 * factor,
                  ),
                ),
              child: TravelPhotoListItem(
                travelPhoto: travelPhotoItem,
              ),
            ));
      },
      scrollDirection: Axis.horizontal,
      initialItemCount: storeBloc.servicesStores.length,
    );
  }
}

class TravelPhotoListItem extends StatelessWidget {
  final StoreServices travelPhoto;

  const TravelPhotoListItem({Key key, this.travelPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Container(
          width: size.width / 3,
          height: size.height / 3,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Container(
                    child: cachedServiceNetworkImage(
                      travelPhoto.frontImage,
                    ),
                  ),
                ),
              ),
              if (!UniversalPlatform.isWeb)
                Positioned.fill(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(0, 0, 0, 0),
                              Color.fromARGB(200, 0, 0, 0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      )),
                ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        travelPhoto.name,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${travelPhoto.stores} tiendas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
