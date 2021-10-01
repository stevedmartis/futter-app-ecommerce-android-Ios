import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/models/store.dart';
import 'package:freeily/profile_store.dart/profile_store_auth.dart';
import 'package:freeily/services/stores_Services.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/cross_fade.dart';
import 'package:freeily/widgets/image_cached.dart';
import 'package:flutter/material.dart';
import 'package:freeily/grocery_store/grocery_store_bloc.dart';
import 'package:freeily/profile_store.dart/profile_store_user.dart';
import 'package:freeily/widgets/show_alert_error.dart';
import 'package:provider/provider.dart';

import 'grocery_store_cart.dart';

const backgroundColor = Color(0xFFF6F5F2);
const cartBarHeight = 65.0;
const _panelTransition = Duration(milliseconds: 500);

class GroceryStoreHome extends StatefulWidget {
  GroceryStoreHome({this.store, this.userName});
  final Store store;

  final String userName;
  @override
  _GroceryStoreHomeState createState() => _GroceryStoreHomeState();
}

class _GroceryStoreHomeState extends State<GroceryStoreHome> {
  double get toolBarHeight => kToolbarHeight;
  Store store;
  bool loadingStore = false;
  bool isAuth = false;
  bool isStoreRoute = false;
  @override
  void initState() {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    print(' username: ${widget.userName}');

    if (widget.userName != '0')
      setState(() {
        isStoreRoute = true;
      });

    if (!isStoreRoute) {
      setState(() {
        store = widget.store;

        loadingStore = true;

        isAuth = (store.user.uid == authService.storeAuth.user.uid);
      });
    } else {
      storeByUsername();
    }

    super.initState();
  }

  void _onVerticalGesture(
    DragUpdateDetails details,
  ) {
    final bloc = Provider.of<GroceryStoreBLoC>(context, listen: false);

    if (details.primaryDelta < -7) {
      bloc.changeToCart();
    } else if (details.primaryDelta > 12) {
      bloc.changeToNormal();
    }
  }

  double _getTopForWhitePanel(GroceryState state, Size size) {
    if (state == GroceryState.normal) {
      return -cartBarHeight +
          toolBarHeight -
          MediaQuery.of(context).padding.bottom +
          10;
    } else if (state == GroceryState.cart) {
      return -(size.height - toolBarHeight - cartBarHeight) -
          MediaQuery.of(context).padding.bottom;
    }
    return 0.0;
  }

  double _getTopForBlackPanel(GroceryState state, Size size) {
    if (state == GroceryState.normal) {
      return size.height -
          cartBarHeight -
          MediaQuery.of(context).padding.bottom / 2;
    } else if (state == GroceryState.cart) {
      return cartBarHeight - MediaQuery.of(context).padding.bottom;
    }
    return size.height;
  }

  storeByUsername() async {
    final storeService = Provider.of<StoreService>(context, listen: false);
    final storeResponse =
        await storeService.getStoreByUsername(widget.userName);

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    print(storeResponse.ok);

    if (storeResponse.ok) {
      setState(() {
        print(store);
        store = storeResponse.store;

        loadingStore = true;

        isAuth = (store.user.uid == authService.storeAuth.user.uid);
      });
    } else {
      print(storeResponse.msg);

      Navigator.pushReplacementNamed(context, '/');
      showSnackBar(context, storeResponse.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bloc = Provider.of<GroceryStoreBLoC>(context);

    final authService = Provider.of<AuthenticationBLoC>(context);
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return AnimatedBuilder(
        animation: bloc,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                if (loadingStore)
                  AnimatedPositioned(
                    duration: _panelTransition,
                    curve: Curves.decelerate,
                    left: 0,
                    right: 0,
                    top: _getTopForWhitePanel(bloc.groceryState, size),
                    height: size.height - toolBarHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          30,
                        ),
                        bottomRight: Radius.circular(
                          30,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child: (!isAuth)
                            ? ProfileStoreSelect(
                                isAuthUser: isAuth,
                                store: store,
                              )
                            : ProfileStoreAuth(isAuthUser: isAuth),
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  curve: Curves.decelerate,
                  duration: _panelTransition,
                  left: 0,
                  right: 0,
                  top: _getTopForBlackPanel(bloc.groceryState, size),
                  height: size.height - toolBarHeight,
                  child: GestureDetector(
                    onVerticalDragUpdate: _onVerticalGesture,
                    onTap: () {
                      bloc.changeToCart();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: AnimatedSwitcher(
                              duration: _panelTransition,
                              child: SizedBox(
                                height: toolBarHeight,
                                child: bloc.groceryState == GroceryState.normal
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Container(
                                                      child: Row(
                                                    children: List.generate(
                                                        bloc.cart.length,
                                                        (index) => FadeIn(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Stack(
                                                                  children: [
                                                                    Hero(
                                                                      tag: 'list_${bloc.cart[index].product.images[0].url}' +
                                                                          '${bloc.cart[index].product.name}' +
                                                                          'details' +
                                                                          '0',
                                                                      child: Container(
                                                                          width: 50,
                                                                          height: 50,
                                                                          child: ClipRRect(
                                                                              borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                                                              child: cachedNetworkImage(
                                                                                bloc.cart[index].product.images[0].url,
                                                                              ))),
                                                                    ),
                                                                    Positioned(
                                                                      right: 0,
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            10,
                                                                        backgroundColor:
                                                                            currentTheme.primaryColor,
                                                                        child: CrossFade<
                                                                            String>(
                                                                          initialData:
                                                                              '',
                                                                          data: bloc
                                                                              .cart[index]
                                                                              .quantity
                                                                              .toString(),
                                                                          builder: (value) =>
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              bloc.cart[index].quantity.toString(),
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Color(0xFF1CD60B),
                                            child: Text(
                                              bloc
                                                  .totalCartElements()
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          Expanded(child: GroceryStoreCart()),
                        ],
                      ),
                    ),
                  ),
                ),
                /* AnimatedPositioned(
                  curve: Curves.decelerate,
                  duration: _panelTransition,
                  left: 0,
                  right: 0,
                  top: _getTopForAppBar(bloc.groceryState),
                  child: _AppBarGrocery(),
                ), */
              ],
            ),
          );
        });
  }
}
