import 'package:animate_do/animate_do.dart';
import 'package:freeily/authentication/auth_bloc.dart';

import 'package:freeily/models/store.dart';
import 'package:freeily/pages/add_edit_product.dart';
import 'package:freeily/profile_store.dart/profile.dart';

import 'package:freeily/responses/orderStoresProduct.dart';

import 'package:freeily/routes/routes.dart';

import 'package:freeily/services/order_service.dart';

import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:freeily/theme/theme.dart';

import 'package:freeily/widgets/header_pages_custom.dart';
import 'package:freeily/widgets/image_cached.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:freeily/store_product_concept/store_product_data.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../../global/extension.dart';

class OrderListPage extends StatefulWidget {
  OrderListPage({this.fromOrderPage = false, this.isSale = false});
  final bool fromOrderPage;
  final bool isSale;
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

Store storeAuth;

class _OrderListPageState extends State<OrderListPage> {
  final product = new ProfileStoreProduct(id: '', name: '');

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  int minTimes = 0;
  int maxTimes = 0;
  List<Order> orders = [];
  bool loading = false;

  @override
  void initState() {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;

    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _scrollController.dispose();

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,

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
                makeHeaderCustom('Mis pedidos'),
                makeListOrders(loading, widget.isSale)
              ]),
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
              goToPrinipal: widget.fromOrderPage,
              action: Container(),
              onPress: () => {
/*                         Navigator.of(context).push(createRouteAddEditProduct(
                            product, false, widget.category)), */
              },
            )))));
  }
}

SliverList makeListOrders(bool loading, bool isSale) {
  return SliverList(
    delegate: SliverChildListDelegate([
      Container(child: StoresListByService(loading: loading, isSale: isSale)),
    ]),
  );
}

class StoresListByService extends StatefulWidget {
  const StoresListByService({Key key, this.loading, this.isSale = false})
      : super(key: key);

  final bool loading;

  final bool isSale;

  @override
  _StoresListByServiceState createState() => _StoresListByServiceState();
}

class _StoresListByServiceState extends State<StoresListByService> {
  List<Order> orders = [];

  List<Order> ordersStore = [];
  bool loading = false;

  @override
  void initState() {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    orders = orderService.orders;
    ordersStore = orderService.ordersStore;
    final List<Order> ordersActiveClient = orders
        .where((i) => i.isActive && !i.isCancelByClient || !i.isCancelByStore)
        .toList();

    final List<Order> ordersCancelClient = orders
        .where((i) => !i.isActive && i.isCancelByClient || i.isCancelByStore)
        .toList();

    final List<Order> ordersActiveStore = ordersStore
        .where((i) => i.isActive && !i.isCancelByClient || !i.isCancelByStore)
        .toList();

    final List<Order> ordersCancelStore = ordersStore
        .where((i) => !i.isActive && i.isCancelByClient || i.isCancelByStore)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              (!widget.isSale) ? 'Mis compras' : 'Mis ventas',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Container(
            child: Text(
              (!widget.isSale)
                  ? 'Encuentra aquí tus pedidos comprados.'
                  : 'Encuentra aquí tus pedidos vendidos.',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          if (ordersActiveClient.length > 0) SizedBox(height: 20),
          if (ordersActiveClient.length > 0)
            Container(
              child: Text(
                'Pedidos en curso',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: currentTheme.accentColor),
              ),
            ),
          SizedBox(
            height: 20,
          ),
          if (!widget.isSale)
            SizedBox(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ordersActiveClient.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      final order = ordersActiveClient[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: FadeIn(
                          child: OrderStoreCard(
                            order: order,
                            isStore: widget.isSale,
                          ),
                        ),
                      );
                    })),
          if (!widget.isSale && ordersCancelClient.length > 0)
            Container(
              child: Text(
                'Pedidos cancelados',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.grey),
              ),
            ),
          if (!widget.isSale)
            SizedBox(
              height: 20,
            ),
          if (!widget.isSale)
            SizedBox(
                child: (ordersCancelClient.length > 0)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ordersCancelClient.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          final order = ordersCancelClient[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: FadeIn(
                              child: OrderStoreCard(
                                order: order,
                                isStore: widget.isSale,
                              ),
                            ),
                          );
                        })
                    : Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(),
                      )),
          if (widget.isSale)
            SizedBox(
                child: (ordersActiveStore.length > 0)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ordersActiveStore.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          final order = ordersActiveStore[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: FadeIn(
                              child: OrderStoreCard(
                                order: order,
                                isStore: widget.isSale,
                              ),
                            ),
                          );
                        })
                    : Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(
                            'No hay pedidos',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )),
          if (widget.isSale && ordersCancelStore.length > 0)
            Container(
              child: Text(
                'Pedidos cancelados',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.grey),
              ),
            ),
          if (widget.isSale)
            SizedBox(
              height: 20,
            ),
          if (widget.isSale)
            SizedBox(
                child: (ordersCancelStore.length > 0)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ordersCancelStore.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          final order = ordersCancelStore[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: FadeIn(
                              child: OrderStoreCard(
                                order: order,
                                isStore: widget.isSale,
                              ),
                            ),
                          );
                        })
                    : Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(),
                      )),
        ],
      ),
    );
  }
}

class OrderStoreCard extends StatelessWidget {
  OrderStoreCard({this.order, this.isStore});

  final Order order;

  final bool isStore;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final id = order.id;

    final store = order.store;

    String textOne = (isStore) ? "Pendido pendiente" : "Pedido en proceso ...";

    String textTwo =
        (isStore) ? "Preparas el pedido ..." : "En preparación ...";

    String textThree =
        (isStore) ? "Envias el pedido ..." : "Pedido en camino ...";

    String textFour = (isStore)
        ? "Entregado, evalua la experiencia!"
        : "Pedido en tu dirección!";

    String actualText = "";
    if (order.isActive && !order.isPreparation) {
      actualText = textOne;
    } else if (order.isPreparation && !order.isDelivery) {
      actualText = textTwo;
    } else if (order.isDelivery && !order.isDelivered) {
      actualText = textThree;
    } else if (order.isDelivered) {
      actualText = textFour;
    }

    if (isStore && order.isCancelByStore) actualText = 'Pedido cancelado.';

    if (!isStore && order.isCancelByStore) actualText = 'La tienda cancelo.';

    if (isStore && order.isCancelByClient) actualText = 'El cliente cancelo.';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(context, orderProggressRoute(order, false, isStore));
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: currentTheme.cardColor,
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 60,
              child: Row(
                children: <Widget>[
                  Hero(
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${store.name.capitalize()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, right: 10),
                          child: (order.isDelivered)
                              ? Text(
                                  actualText,
                                  style: TextStyle(
                                      color: currentTheme.primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                )
                              : Text(
                                  actualText,
                                  style: TextStyle(
                                      color: (order.isCancelByClient ||
                                              order.isCancelByStore)
                                          ? Colors.grey
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                            context, orderProggressRoute(order, false, false));
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: currentTheme.primaryColor,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
