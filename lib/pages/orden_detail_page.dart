import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/add_edit_product.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

const _blueColor = Color(0xFF00649FE);

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
    super.dispose();
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final double snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _scrollController.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
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
            _snapAppbar();

            return false;
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                makeHeaderCustom('Tu Orden'),

                titleBox(context),
                addressDeliveryInfo(context),

                makeListProducts(context),

                //makeListProducts(context)
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
}

SliverToBoxAdapter addressDeliveryInfo(context) {
  final currentTheme = Provider.of<ThemeChanger>(context);

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
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                          ),
                          if (prefs.locationCurrent)
                            Container(
                              width: size.width / 1.7,
                              child: Text(
                                prefs.locationCurrent
                                    ? '${prefs.addressSave['featureName']}'
                                    : '...',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          if (prefs.locationSearch)
                            Container(
                              width: size.width / 1.7,
                              child: Text(
                                prefs.locationSearch
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
          if (prefs.locationCurrent)
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
              child: Row(
                children: [
                  Container(
                    child: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      prefs.locationCurrent
                          ? '${prefs.addressSave['adminArea']}'
                          : '...',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      prefs.locationSearch
                          ? '${prefs.addressSave['locality']}'
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
          if (prefs.locationSearch)
            Container(
              padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
              child: Row(
                children: [
                  Container(
                    child: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      prefs.locationSearch
                          ? '${prefs.addressSearchSave.number}'
                          : '...',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      prefs.locationSearch
                          ? '${prefs.addressSearchSave.secondaryText}'
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
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.schedule,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Entrega',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  '24 - 45 mins',
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
              'Tu Orden',
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

Widget _buildProductsList(context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  var map = Map();

  final bloc = Provider.of<GroceryStoreBLoC>(context);

  bloc.cart
      .forEach((e) => map.update(e.product.user, (x) => e, ifAbsent: () => e));

  final mapList = map.values.toList();

  return Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mapList.length,
      itemBuilder: (context, index) {
        final item = mapList[index];

        final store = storeBloc.getStoreByProducts(item.product.user);

        final products = bloc.cart
            .where((element) => element.product.user == store.user.uid)
            .toList();

        return FadeInLeft(
          delay: Duration(milliseconds: 100 * index),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Image.asset(
                        'assets/rest_logo.jpeg',
                        fit: BoxFit.cover,
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
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          '${store.name}',
                          style: TextStyle(
                              color: Colors.white,
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
                            '${products.length}',
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
                            bloc.cart.length == 1 ? 'Producto' : 'Productos',
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
                  textDirection: TextDirection.rtl,
                  fit: StackFit.loose,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Container(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: (products.length == 3) ? 2 : products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = products[index].product;

                          return Container(
                              margin: EdgeInsets.only(left: 5.0),
                              alignment: Alignment.topRight,
                              child: FadeInLeft(
                                delay: Duration(milliseconds: 200 * index),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        NetworkImage(product.images[0].url),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    if (products.length == 3)
                      Container(
                        child: FadeInRight(
                          duration: Duration(milliseconds: 400),
                          delay: Duration(milliseconds: 500),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: currentTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.centerRight,
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
                )
              ],
            ),
          ),
        );
      },
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

class ButtonFollow extends StatefulWidget {
  const ButtonFollow(
      {Key key, @required this.percent, @required this.bloc, this.left})
      : super(key: key);

  final num percent;
  final TabsViewScrollBLoC bloc;
  final double left;

  @override
  _ButtonFollowState createState() => _ButtonFollowState();
}

class _ButtonFollowState extends State<ButtonFollow> {
  bool isFollow = false;
  void changeFollow() {
    isFollow = !isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.percent <= 0.9)
            ? Positioned(
                top: 350,
                left: widget.left,
                child: Container(
                  width: 180,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: (!isFollow) ? Colors.white : _blueColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          (isFollow) ? 'Follow' : 'Following',
                          style: TextStyle(
                              color: (isFollow) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                ))
            : Positioned(
                top: 90,
                right: 20,
                child: Container(
                  width: 100,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: (!isFollow) ? Colors.white : _blueColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          (isFollow) ? 'Follow' : 'Following',
                          style: TextStyle(
                              color: (isFollow) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                )),
      ],
    );
  }
}

class ButtonEditProfile extends StatefulWidget {
  const ButtonEditProfile(
      {Key key, @required this.percent, @required this.bloc, this.left})
      : super(key: key);

  final num percent;
  final TabsViewScrollBLoC bloc;
  final double left;

  @override
  _ButtonEditProfileState createState() => _ButtonEditProfileState();
}

class _ButtonEditProfileState extends State<ButtonEditProfile> {
  bool isFollow = false;
  void changeFollow() {
    isFollow = !isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.percent <= 0.9)
            ? Positioned(
                top: 350,
                left: widget.left,
                child: Container(
                  width: 180,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          'Editar perfil',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                ))
            : Positioned(
                top: 90,
                right: 20,
                child: Container(
                  width: 100,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10),
                        child: Text(
                          'Editar',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                )),
      ],
    );
  }
}

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
    ProfileStoreProduct product, bool isEdit, ProfileStoreCategory category) {
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
