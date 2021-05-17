import 'dart:ui';

import 'package:australti_ecommerce_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile_store_user.dart';

import 'grocery_store_cart.dart';

const backgroundColor = Color(0xFFF6F5F2);
const cartBarHeight = 65.0;
const _panelTransition = Duration(milliseconds: 500);

class GroceryStoreHome extends StatefulWidget {
  GroceryStoreHome(this.store);
  final Store store;
  @override
  _GroceryStoreHomeState createState() => _GroceryStoreHomeState();
}

class _GroceryStoreHomeState extends State<GroceryStoreHome> {
  // final bloc = GroceryStoreBLoC();

  double get toolBarHeight => kToolbarHeight;

  void _onVerticalGesture(
    DragUpdateDetails details,
  ) {
    if (details.primaryDelta < -7) {
      groceryStoreBloc.changeToCart();
    } else if (details.primaryDelta > 12) {
      groceryStoreBloc.changeToNormal();
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

  /*  double _getTopForAppBar(GroceryState state) {
    if (state == GroceryState.normal) {
      return 0.0;
    } else if (state == GroceryState.cart) {
      return -cartBarHeight;
    }
    return -toolBarHeight;
  } */

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //final bloc = Provider.of<GroceryStoreBLoC>(context);

    return AnimatedBuilder(
        animation: groceryStoreBloc,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                AnimatedPositioned(
                  duration: _panelTransition,
                  curve: Curves.decelerate,
                  left: 0,
                  right: 0,
                  top:
                      _getTopForWhitePanel(groceryStoreBloc.groceryState, size),
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
                      child: ProfileStoreSelect(
                        isAuthUser: false,
                        store: widget.store,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.decelerate,
                  duration: _panelTransition,
                  left: 0,
                  right: 0,
                  top:
                      _getTopForBlackPanel(groceryStoreBloc.groceryState, size),
                  height: size.height - toolBarHeight,
                  child: GestureDetector(
                    onVerticalDragUpdate: _onVerticalGesture,
                    onTap: () => groceryStoreBloc.changeToCart(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: AnimatedSwitcher(
                              duration: _panelTransition,
                              child: SizedBox(
                                height: toolBarHeight,
                                child: groceryStoreBloc.groceryState ==
                                        GroceryState.normal
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
                                                      groceryStoreBloc
                                                          .cart.length,
                                                      (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Stack(
                                                          children: [
                                                            Hero(
                                                              tag:
                                                                  'list_${groceryStoreBloc.cart[index].product.name}details',
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                  groceryStoreBloc
                                                                      .cart[
                                                                          index]
                                                                      .product
                                                                      .image,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 0,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 10,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                child: Text(
                                                                  groceryStoreBloc
                                                                      .cart[
                                                                          index]
                                                                      .quantity
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Color(0xFF1CD60B),
                                            child: Text(
                                              groceryStoreBloc
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
