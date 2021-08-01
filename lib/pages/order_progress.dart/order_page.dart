import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/add_edit_product.dart';
import 'package:australti_ecommerce_app/pages/order_progress.dart/progressBar.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';

import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/order_service.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';

import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../../global/extension.dart';

class OrderPage extends StatefulWidget {
  final Order order;
  final bool goToPrincipal;
  final bool isStore;
  OrderPage(
      {@required this.order, this.goToPrincipal = false, this.isStore = false});
  @override
  _OrderPageState createState() => _OrderPageState();
}

Store storeAuth;

class _OrderPageState extends State<OrderPage> {
  final product = new ProfileStoreProduct(id: '', name: '');

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  int minTimes = 0;
  int maxTimes = 0;
  Order order;
  @override
  void initState() {
    order = widget.order;
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;

    _scrollController = ScrollController()..addListener(() => setState(() {}));
    updateNotifiOrderStore();
    super.initState();

    //final getTimeMin =  order.store.timeDelivery.toString().split("-").first.trim();

    // final minInt = int.parse(getTimeMin);

    //final getTimeMax =order.store.timeDelivery.toString().split("-").last.trim();

    //final maxInt = int.parse(getTimeMax);
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  void updateNotifiOrderStore() async {
    final orderBloc = Provider.of<OrderService>(context, listen: false);

    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;
    number--;
    notifiModel.numberNotifiBell = number;

    notifiModel.numberSteamNotifiBell.sink.add(number);

    if (widget.isStore && order.isNotifiCheckStore) {
      orderBloc.orderCheckNotifiStore(
        order.id,
      );
      orderBloc.editOrderNotifiOrder(order.id, true);
    } else {
      orderBloc.orderCheckNotifiClient(order.id);

      orderBloc.editOrderNotifiOrder(order.id, false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    storesByProduct = [];

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

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    void prepareOrder() async {
      final orderBloc = Provider.of<OrderService>(context, listen: false);
      final socketService = Provider.of<SocketService>(context, listen: false);

      orderBloc.orderPrepareStore(
        order.id,
      );
      final resp = await orderBloc.editOrderPrepare(order.id);

      if (resp.ok) {
        socketService
            .emit('orders-notification-client', {'client': order.client});

        Navigator.pop(context);
      }
    }

    final orderId = order.id.substring(11, 15);
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        bottomNavigationBar: (widget.isStore && !order.isPreparation)
            ? Container(
                padding:
                    EdgeInsets.only(top: 5, bottom: 10, right: 10, left: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
                    child: Container(
                        height: 50,
                        width: size.width / 2.2,
                        child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              prepareOrder();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              fixedSize: Size.fromWidth(size.width),
                              primary: currentTheme.primaryColor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Row(children: [
                              Text('Preparar', style: TextStyle(fontSize: 15)),
                              Spacer(),
                              FaIcon(
                                FontAwesomeIcons.boxOpen,
                                size: 15,
                                color: Colors.white,
                              )
                            ]))),
                  )
                ]),
              )
            : Container(
                width: 0,
                height: 0,
              ),

        // tab bar view
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            return false;
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                makeHeaderCustom('Pedido#$orderId', widget.goToPrincipal),
                progressOrderExpanded(context, order, widget.isStore),
                makeListProducts(
                    context, order, minTimes, maxTimes, widget.isStore),
              ]),
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderCustom(String title, bool goToPrinipal) {
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
              goToPrinipal: goToPrinipal,
              action: Container(),
              onPress: () => {
/*                         Navigator.of(context).push(createRouteAddEditProduct(
                            product, false, widget.category)), */
              },
            )))));
  }
}

List<Store> storesByProduct = [];

SliverToBoxAdapter progressOrderExpanded(context, Order order, bool isStore) {
  return SliverToBoxAdapter(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ProgressBar(
              order: order,
              isStore: isStore,
            )),
      ],
    ),
  );
}

SliverList makeListProducts(
    context, Order order, minTimes, maxTimes, bool isStore) {
  return SliverList(
      delegate: SliverChildListDelegate([
    _buildProductsList(context, order, minTimes, maxTimes, isStore),
  ]));
}

int totalPriceElements(Order order) => order.products.fold<int>(
      0,
      (previousValue, element) =>
          previousValue + (element.quantity * element.product.price),
    );

Widget _buildProductsList(
    context, Order order, minTimes, maxTimes, bool isStore) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  final size = MediaQuery.of(context).size;
  final prefs = new AuthUserPreferences();

  final bloc = Provider.of<GroceryStoreBLoC>(context);

  final storeBloc = Provider.of<StoreBLoC>(context);

  final authBloc = Provider.of<AuthenticationBLoC>(context);

  final totalFormat =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
          .format(totalPriceElements(order));

  final Store store = order.store;
  int totalQuantity = 0;

  totalQuantity = order.products.length;

  final storeFind = storeBloc.getStoreByProducts(store.user.uid);

  if (storeFind != null) {
    store.notLocation = true;
  } else {
    storeBloc.getStoreAllDbByProducts(store.user.uid);
    store.notLocation = false;
  }

  void closeOrder() async {
    final orderBloc = Provider.of<OrderService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (isStore) {
      orderBloc.orderCancelByStore(
        order.id,
      );
      final resp = await orderBloc.editOrderClose(order.id, true);

      if (resp.ok) {
        socketService
            .emit('orders-notification-client', {'client': order.client});
        Navigator.pop(context);
      }
    } else {
      orderBloc.orderCancelByClient(order.id);

      final resp = await orderBloc.editOrderClose(order.id, false);

      if (resp.ok) {
        socketService.emit('orders-notification-store', {
          'storesIds': [order.store],
        });
        Navigator.pop(context);
      }
    }
  }

  final List<ProductElement> products = order.products;

  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Card(
      elevation: 6,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: currentTheme.cardColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'order/${order.id}',
                          child: Container(
                            width: 70,
                            height: 70,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
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
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: size.width / 2,
                                margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  '${store.name.capitalize()}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width / 2,
                                  margin: EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    '${store.address}, ${store.number}, ${store.city}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            )
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                )),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20, bottom: 10, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'DIRECCIÓN DE ENTREGA',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
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
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (!order.isSend)
                  if (!isStore)
                    Container(
                      alignment: Alignment.centerRight,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: currentTheme.scaffoldBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Material(
                            color: currentTheme.scaffoldBackgroundColor,
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
                                            secondaryText: place.secondaryText,
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
                                  color: currentTheme.primaryColor,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 5),
                  child: Text(
                    '$totalQuantity',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 20),
                  child: Text(
                    bloc.cart.length == 1 ? 'producto' : 'productos',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: size.width / 5, bottom: 10),
                  alignment: Alignment.centerRight,
                  height: 60,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: (products.length >= 3) ? 2 : products.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = products[index];
                      return FadeInRight(
                        child: Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 5.0),
                                alignment: Alignment.topRight,
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100.0)),
                                        child: cachedNetworkImage(
                                            item.product.images[0].url)))),
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
                                          fontWeight: FontWeight.w500))),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (products.length >= 3)
                  Container(
                    padding: EdgeInsets.only(right: size.width / 9, top: 10),
                    alignment: Alignment.centerRight,
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
                  ),
                Container(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right,
                      size: 30,
                    ))
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.only(left: 20, bottom: 0, top: 10, right: 20),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (isStore) ? 'Tu pago' : 'Tu cargo',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\$$totalFormat',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (order.isPreparation)
            SizedBox(
              height: 20,
            ),
          if (!order.isCancelByClient &&
              !order.isCancelByStore &&
              !order.isPreparation)
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      {
                        HapticFeedback.heavyImpact();

                        final act = CupertinoActionSheet(
                            title: Text('Cancelar este pedido?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            message: Text(
                                'Se cancelara el pago, se notificara al cliente y no podras volver a modifcar el pedido'),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text(
                                  'Si',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  HapticFeedback.heavyImpact();

                                  closeOrder();
                                  Navigator.pop(context);
                                },
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ));
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => act);
                      }
                    },
                    child: Container(
                      child: Text(
                        'Cancelar pedido',
                        style: TextStyle(color: currentTheme.primaryColor),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
              ],
            )

          /* Container(
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
          ), */
        ],
      ),
    ),
  );
}

SliverToBoxAdapter orderDetailInfo(context) {
  final currentTheme = Provider.of<ThemeChanger>(context);

  final size = MediaQuery.of(context).size;
  final bloc = Provider.of<GroceryStoreBLoC>(context);

  final totalFormat =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
          .format(bloc.totalPriceElements());

  return SliverToBoxAdapter(
    child: Container(
      child: Column(
        children: [
          Divider(),
          FadeIn(
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
                              'Detalle de la orden',
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
          ),
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
