import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/cards_services_bloc.dart';

import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/credit_Card.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/add_edit_product.dart';

import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/responses/bank_account.dart';
import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';
import 'package:australti_ecommerce_app/responses/stores_products_order.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/bank_Service.dart';
import 'package:australti_ecommerce_app/services/order_service.dart';

import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';

import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../../global/extension.dart';

class OrdenDetailPage extends StatefulWidget {
  @override
  _OrdenDetailPageState createState() => _OrdenDetailPageState();
}

Store storeAuth;

class _OrdenDetailPageState extends State<OrdenDetailPage> {
  final product = new ProfileStoreProduct(id: '', name: '');

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  int minTimes = 0;
  int maxTimes = 0;
  @override
  void initState() {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;

    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();

    var map = Map();

    final bloc = Provider.of<GroceryStoreBLoC>(context, listen: false);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    bloc.cart.forEach(
        (e) => map.update(e.product.user, (x) => e, ifAbsent: () => e));

    mapList = map.values.toList();

    storesByProduct = [];

    mapList.forEach((item) {
      final store = storeBloc.getStoreByProducts(item.product.user);

      if (store != null) {
        store.notLocation = true;
        storesByProduct.add(store);
      } else {
        final store = storeBloc.getStoreAllDbByProducts(item.product.user);

        if (store != null) {
          store.notLocation = false;
          storesByProduct.add(store);
        }
      }
    });

    minTimes = storesByProduct.fold<int>(0, (previousValue, store) {
      if (store.timeDelivery != "") {
        final replaced = store.timeDelivery.replaceFirst(RegExp('min'), '');

        final getTimeMin = replaced.toString().split("-").first.trim();

        final minInt = int.parse(getTimeMin);

        return previousValue + minInt;
      } else {
        return 24;
      }
    });

    maxTimes = storesByProduct.fold<int>(0, (previousValue, store) {
      if (store.timeDelivery != "") {
        final replaced =
            store.timeDelivery.replaceFirst(RegExp('min'), ''); // h*llo hello

        final getTimeMax = replaced.toString().split("-").last.trim();

        final maxInt = int.parse(getTimeMax.split("mins").first);

        return previousValue + maxInt;
      } else {
        return 48;
      }
    });

    storesByProduct.forEach((item) {
      getbankAccountByUser(item.user.uid);
    });
  }

  void getbankAccountByUser(String uid) async {
    final bankService = Provider.of<BankService>(context, listen: false);
    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    final resp = await bankService.getAccountBankByUser(uid);

    if (resp.ok) {
      storeBloc.addBanksAccountStoresOrder(resp.bankAccount);
    } else {}
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    storesByProduct = [];

    mapList = [];
    minTimes = 0;
    maxTimes = 0;

    super.dispose();
  }

  TabController controller;

  int itemCount;
  IndexedWidgetBuilder tabBuilder;
  IndexedWidgetBuilder pageBuilder;
  Widget stub;
  ValueChanged<int> onPositionChange;
  ValueChanged<double> onScroll;
  int initPosition;
  bool isFallow;

  List<ProfileStoreProduct> productsByCategoryList = [];

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  bool isCreated = false;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthenticationBLoC>(context);

    if (authService.redirect == 'is_auth' && !isCreated) {
      setState(() {
        isCreated = true;
      });
      _createOrder(context);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,

        // tab bar view
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: <Widget>[
              makeHeaderCustom('Tu pedido'),
              titleBox(context),
              addressDeliveryInfo(context, minTimes, maxTimes),
              makeListProducts(
                context,
              ),
              orderDetailInfo(context),
            ]),

        bottomNavigationBar: GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();

            if (storeAuth.user.uid == '0') {
              authService.redirect = 'create_order';
              Navigator.push(context, loginRoute());
            } else {
              _createOrder(context);
            }
          },
          child: SizedBox(
            height: size.height / 8,
            child: Center(
              child: goPayCartBtnSubtotal(
                'Enviar pedido',
                [
                  currentTheme.primaryColor,
                  currentTheme.primaryColor,
                ],
                false,
                true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                child: Container(
                    child: CustomAppBarHeaderPages(
              showTitle: _showTitle,
              title: title,

              leading: true,
              action: Container(),
              onPress: () => {
/*                         Navigator.of(context).push(createRouteAddEditProduct(
                            product, false, widget.category)), */
              },
              //   Container()
              /*  IconButton(
                              icon: Icon(
                                Icons.add,
                                color: currentTheme.accentColor,
                              ),
                              iconSize: 30,
                              onPressed: () => {
                                    /*  Navigator.of(context).push(
                                        createRouteAddCatalogo(
                                            catalogo, false)), */
                                  }), */
            )))));
  }

  _createOrder(context) async {
    final List<StoresProduct> storesProducts = [];
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    final storeBloc = Provider.of<GroceryStoreBLoC>(context, listen: false);
    final creditCardService =
        Provider.of<CreditCardServices>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final clientId = authService.storeAuth.user.uid;
    final creditCardClient = (prefs.pyamentMethodCashOption)
        ? 'cash'
        : creditCardService.cardselectedToPay.value.id;
    final idsStores = storesByProduct.map((e) => e.user.uid).toList();

    idsStores.forEach((storeId) {
      final products = storeBloc.cart
          .where((element) => element.product.user == storeId)
          .toList();

      List<Product> arrayProducts = [];
      products.forEach((item) {
        final product = Product(id: item.product.id, quantity: item.quantity);
        arrayProducts.add(product);
      });

      final storeProducts =
          StoresProduct(storeUid: storeId, products: arrayProducts);
      storesProducts.add(storeProducts);
    });

    final OrderStoresProducts createOrderResp = await orderService.createOrder(
        clientId, storesProducts, creditCardClient);

    orderService.ordersClientInitial = [];
    if (createOrderResp != null) {
      if (createOrderResp.ok) {
        loading = false;

        createOrderResp.orders.forEach((order) {
          orderService.ordersClientInitial.add(order);
        });

        orderService.orders = orderService.ordersClientInitial;

        /*  setState(() {
        isCreated = true;
      }); */

        Navigator.push(context, dataRoute(orderService.ordersClientInitial));

        socketService.emit('orders-notification-store', {
          'storesIds': idsStores,
        });

        orderService.loading = false;

        storeBloc.emptyCart();
      } else {
        showAlertError(context, 'Error', 'Error');
      }
    } else {
      showAlertError(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }
}

List<Store> storesByProduct = [];
List<BankAccount> bankAccountsByStore = [];

SliverToBoxAdapter addressDeliveryInfo(context, minTimes, maxTimes) {
  final currentTheme = Provider.of<ThemeChanger>(context);
  final authBloc = Provider.of<AuthenticationBLoC>(context);
  final size = MediaQuery.of(context).size;
  final prefs = new AuthUserPreferences();

  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          FadeIn(
            child: Container(
                padding: EdgeInsets.only(top: 0.0),
                color: currentTheme.currentTheme.scaffoldBackgroundColor,
                child: Container(
                  padding: EdgeInsets.only(left: size.width / 20, top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //Navigator.of(context).pop();
                        },
                        child: new Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 2, color: Colors.grey)),
                              child: Icon(
                                Icons.location_on,
                                size: 30,
                                color: currentTheme.currentTheme.accentColor,
                              ),
                            )),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'DIRECCIÓN DE ENTREGA',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                          ),
                          Container(
                            width: size.width / 1.7,
                            child: Text(
                              prefs.addressSearchSave != ''
                                  ? '${prefs.addressSearchSave.mainText}'
                                  : '...',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              currentTheme.currentTheme.scaffoldBackgroundColor,
                        ),
                        child: Row(
                          children: [
                            Material(
                              color: currentTheme
                                  .currentTheme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                splashColor: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                                radius: 40,
                                onTap: () {
                                  HapticFeedback.lightImpact();

                                  final place = prefs.addressSearchSave;

                                  var placeSave = new PlaceSearch(
                                      description: authBloc.storeAuth.user.uid,
                                      placeId: authBloc.storeAuth.user.uid,
                                      structuredFormatting:
                                          new StructuredFormatting(
                                              mainText: place.mainText,
                                              secondaryText:
                                                  place.secondaryText,
                                              number: place.number));
                                  Navigator.push(
                                      context, confirmLocationRoute(placeSave));
                                },
                                highlightColor: Colors.grey,
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  alignment: Alignment.center,
                                  width: 34,
                                  height: 34,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color:
                                        currentTheme.currentTheme.primaryColor,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                )),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Divider(),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    prefs.addressSearchSave != ''
                        ? '${prefs.addressSearchSave.secondaryText}'
                        : '...',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.grey),
                  ),
                ),
                Spacer(),
                Container(
                  child: Icon(
                    Icons.home_outlined,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    prefs.addressSearchSave != ''
                        ? '${prefs.addressSearchSave.number}'
                        : '...',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Entrega',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.grey),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  (minTimes == 24 && maxTimes == 48)
                      ? '$minTimes - $maxTimes hrs.'
                      : '$minTimes - $maxTimes mins.',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
        ],
      ),
    ),
  );
}

SliverToBoxAdapter titleBox(context) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Tu pedido',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ],
      ),
    ),
  );
}

SliverList makeListProducts(
  context,
) {
  return SliverList(
      delegate: SliverChildListDelegate([
    _buildProductsList(context),
  ]));
}

List<dynamic> mapList = [];

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}

List<Object> storesproducts = [];

Widget _buildProductsList(context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  var map = Map();
  final bloc = Provider.of<GroceryStoreBLoC>(context);

  final storeBloc = Provider.of<StoreBLoC>(context);

  bloc.cart
      .forEach((e) => map.update(e.product.user, (x) => e, ifAbsent: () => e));

  mapList = map.values.toList();
  final size = MediaQuery.of(context).size;
  final cardBloc = Provider.of<CreditCardServices>(context);
/*   mapList.forEach((item) {
    final product = item.singleWhere((i) => i.user.uid == item.id);

    storesByProduct.add(product);
  }); */

  return Container(
//    padding: EdgeInsets.only(left: 20, right: 20),
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mapList.length,
      itemBuilder: (context, index) {
        final item = mapList[index];

        Store store;

        store = storeBloc.getStoreByProducts(item.product.user);

        List<dynamic> products = [];

        int totalQuantity = 0;
        if (store != null) {
          products = bloc.cart
              .where((element) => element.product.user == store.user.uid)
              .toList();
          store.notLocation = true;
          totalQuantity = products.fold<int>(
            0,
            (previousValue, element) => previousValue + element.quantity,
          );
        } else {
          store = storeBloc.getStoreAllDbByProducts(item.product.user);
          store.notLocation = false;
          products = bloc.cart
              .where((element) => element.product.user == store.user.uid)
              .toList();
          totalQuantity = products.fold<int>(
            0,
            (previousValue, element) => previousValue + element.quantity,
          );
        }

        final bankAccountStoreCurrent =
            (storeBloc.bankAccountsByStore.length > 0)
                ? storeBloc.bankAccountsByStore.firstWhere(
                    (item) => item.user == store.user.uid,
                    orElse: () => BankAccount(id: '0', bankOfAccount: 'NONE'))
                : BankAccount(id: '0', bankOfAccount: 'NONE');

        return FadeInLeft(
          delay: Duration(milliseconds: 100 * index),
          child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  if (!store.notLocation)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //Navigator.of(context).pop();
                            },
                            child: new Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 2, color: Colors.grey)),
                                  child: Icon(
                                    Icons.fmd_bad,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                )),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Tienda no disponible',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                width: size.width / 1.7,
                                child: Text(
                                  'No se encuentra en esta ubicación',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width / 10,
                          height: size.height / 10,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: (store.imageAvatar != "")
                                  ? Container(
                                      child: (!store.notLocation)
                                          ? cachedProductNetworkImage(
                                              store.imageAvatar,
                                            )
                                          : cachedNetworkImage(
                                              store.imageAvatar,
                                            ),
                                    )
                                  : Image.asset(currentProfile.imageAvatar),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: size.width / 2.5,
                                margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  '${store.name.capitalize()}',
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: (!store.notLocation)
                                          ? Colors.grey
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    '$totalQuantity',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  child: Text(
                                    bloc.cart.length == 1
                                        ? 'Producto'
                                        : 'Productos',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Spacer(),
                        Stack(
                          fit: StackFit.loose,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Container(
                              height: size.height / 10,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: (products.length >= 3)
                                    ? 2
                                    : products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = products[index];
                                  return Stack(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          alignment: Alignment.topRight,
                                          child: FadeInLeft(
                                            delay: Duration(
                                                milliseconds: 200 * index),
                                            child: Container(
                                                width: size.width / 15,
                                                height: size.height / 15,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100.0)),
                                                    child: (!store.notLocation)
                                                        ? cachedProductNetworkImage(
                                                            item.product
                                                                .images[0].url)
                                                        : cachedNetworkImage(
                                                            item
                                                                .product
                                                                .images[0]
                                                                .url))),
                                          )),
                                      Container(
                                        decoration: new BoxDecoration(
                                          color: (!store.notLocation)
                                              ? Colors.grey
                                              : currentTheme.accentColor,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.bottomCenter,
                                        width: 20.0,
                                        height: 20.0,
                                        child: Center(
                                            child: Text('${item.quantity}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (products.length >= 3)
                              Container(
                                margin: EdgeInsets.only(left: size.width / 4),
                                child: FadeInRight(
                                  duration: Duration(milliseconds: 400),
                                  delay: Duration(milliseconds: 500),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: currentTheme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    width: 30.0,
                                    height: 30.0,
                                    child: Center(
                                        child: Text('+${products.length - 2}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider()),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<CreditCard>(
                      stream: cardBloc.cardselectedToPay.stream,
                      builder: (context, AsyncSnapshot<CreditCard> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          CreditCard cardSelected = snapshot.data;
                          return (cardSelected != null)
                              ? (cardSelected.id != '0' &&
                                      cardSelected.id != '1' &&
                                      (bankAccountStoreCurrent.id != '0'))
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: getCardTypeIcon(
                                                    (cardSelected.cardNumber !=
                                                            null)
                                                        ? cardSelected
                                                            .cardNumber
                                                        : ''),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      'METODO DE PAGO',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          '${cardSelected.brand.toUpperCase()}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                            ' *${cardSelected.cardNumberHidden}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        '${cardSelected.cardHolderName}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () => {
                                                  storeBloc
                                                      .currentBankAccountStorePaymentMethod(
                                                          bankAccountStoreCurrent),
                                                  Navigator.push(
                                                      context,
                                                      paymentMethodsOptionsRoute(
                                                          false))
                                                },
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text('Cambiar',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                          color: currentTheme
                                                              .primaryColor)),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : (cardSelected.id == '0' ||
                                          bankAccountStoreCurrent.id == '0')
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            border: Border.all(
                                                                width: 2,
                                                                color: Colors
                                                                    .grey)),
                                                        child: Icon(
                                                          Icons.attach_money,
                                                          size: 30,
                                                          color: currentTheme
                                                              .accentColor,
                                                        ),
                                                      )),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          'METODO DE PAGO',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'Pago en efectivo',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        width: size.width / 2,
                                                        child: Text(
                                                          'Efectivo al momento de recibir el pedido.',
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (bankAccountStoreCurrent
                                                          .id !=
                                                      '0')
                                                    GestureDetector(
                                                      onTap: () => {
                                                        storeBloc
                                                            .currentBankAccountStorePaymentMethod(
                                                                bankAccountStoreCurrent),
                                                        Navigator.push(
                                                            context,
                                                            paymentMethodsOptionsRoute(
                                                                false))
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 0),
                                                        child: Text('Cambiar',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: currentTheme
                                                                    .primaryColor)),
                                                      ),
                                                    )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : (cardSelected.id == '1')
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 20),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .grey)),
                                                            child: Icon(
                                                              Icons
                                                                  .account_balance,
                                                              size: 30,
                                                              color: currentTheme
                                                                  .accentColor,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'METODO DE PAGO',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                size.width / 2,
                                                            child: Text(
                                                              'Deposito bancario',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          MaterialButton(
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              shape:
                                                                  StadiumBorder(),
                                                              child: Text(
                                                                'Ver datos',
                                                                style: TextStyle(
                                                                    color: currentTheme
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              onPressed: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        new FocusNode());

                                                                Navigator.push(
                                                                    context,
                                                                    bankAccountStorePayment(
                                                                        true));
                                                              }),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () => {
                                                          storeBloc
                                                              .currentBankAccountStorePaymentMethod(
                                                                  bankAccountStoreCurrent),
                                                          Navigator.push(
                                                              context,
                                                              paymentMethodsOptionsRoute(
                                                                  false))
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: Text('Cambiar',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 14,
                                                                  color: currentTheme
                                                                      .primaryColor)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        '* Tansfiere desde tu banco a la cuenta de la tienda el total indicado.',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ],
                                              ))
                                          : Container()
                              : Container();
                        } else {
                          return Container();
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Divider(),
                  )
                ],
              )),
        );
      },
    ),
  );
}

Map<CardType, Set<List<String>>> cardNumPatterns =
    <CardType, Set<List<String>>>{
  CardType.visa: <List<String>>{
    <String>['4'],
  },
  CardType.americanExpress: <List<String>>{
    <String>['34'],
    <String>['37'],
  },
  CardType.discover: <List<String>>{
    <String>['6011'],
    <String>['622126', '622925'],
    <String>['644', '649'],
    <String>['65']
  },
  CardType.mastercard: <List<String>>{
    <String>['51', '55'],
    <String>['2221', '2229'],
    <String>['223', '229'],
    <String>['23', '26'],
    <String>['270', '271'],
    <String>['2720'],
  },
};

CardType detectCCType(String cardNumber) {
  //Default card type is other
  CardType cardType = CardType.otherBrand;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        String ccPatternStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
        final int rangeLen = patternRange[0].length;

        if (rangeLen < cardNumber.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          final int ccPrefixAsInt = int.parse(ccPatternStr);
          final int startPatternPrefixAsInt = int.parse(patternRange[0]);
          final int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardType = type;
            break;
          }
        } else {
          if (ccPatternStr == patternRange[0]) {
            // Found a match
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}

bool isAmex = false;

Widget getCardTypeIcon(String cardNumber) {
  Widget icon;
  switch (detectCCType(cardNumber)) {
    case CardType.visa:
      icon = Image.asset(
        'icons/visa.png',
        height: 48,
        width: 48,
        package: 'flutter_credit_card',
      );
      isAmex = false;
      break;

    case CardType.americanExpress:
      icon = Image.asset(
        'icons/amex.png',
        height: 48,
        width: 48,
        package: 'flutter_credit_card',
      );
      isAmex = true;
      break;

    case CardType.mastercard:
      icon = Image.asset(
        'icons/mastercard.png',
        height: 48,
        width: 48,
        package: 'flutter_credit_card',
      );
      isAmex = false;
      break;

    case CardType.discover:
      icon = Image.asset(
        'icons/discover.png',
        height: 48,
        width: 48,
        package: 'flutter_credit_card',
      );
      isAmex = false;
      break;

    default:
      icon = Container(
        height: 48,
        width: 48,
      );
      isAmex = false;
      break;
  }

  return icon;
}

SliverToBoxAdapter orderDetailInfo(context) {
  final bloc = Provider.of<GroceryStoreBLoC>(context);

  final totalFormat =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
          .format(bloc.totalPriceElements());

  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          /*  FadeIn(
            child: Container(
                padding: EdgeInsets.only(top: 10.0),
                color: currentTheme.currentTheme.scaffoldBackgroundColor,
                child: Container(
                  padding: EdgeInsets.only(left: size.width / 20, top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Detalle del pedido',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          
            SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(),
          ), */

          Container(
            padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Productos',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.grey),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$$totalFormat',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          /* Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, bottom: 10, top: 0),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Entrega',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.grey),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$${bloc.totalPriceElements().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(), */
        ],
      ),
    ),
  );
}

/* class _ProfileStoreCategoryItem extends StatelessWidget {
  const _ProfileStoreCategoryItem(this.category);
  final ProfileStoreCategory category;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category.name,
        style: TextStyle(
          color: (!currentTheme.customTheme) ? Colors.black54 : Colors.white54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} */

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search,
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
            SizedBox(width: 10),
            Container(
                // margin: EdgeInsets.only(top: 0, left: 0),
                child: Text('Search product ...',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Route createRouteAddEditProduct(
    ProfileStoreProduct product, bool isEdit, String category) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateProductPage(
            product: product, isEdit: isEdit, category: category),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}
