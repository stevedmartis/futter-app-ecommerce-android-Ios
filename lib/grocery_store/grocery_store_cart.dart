import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class GroceryStoreCart extends StatefulWidget {
  GroceryStoreCart({this.cartHome = false});

  final bool cartHome;

  @override
  _GroceryStoreCartState createState() => _GroceryStoreCartState();
}

SlidableController slidableController;

class _GroceryStoreCartState extends State<GroceryStoreCart> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GroceryStoreBLoC>(context);
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: bloc.groceryState != GroceryState.cart
            ? Tween(begin: 0.0, end: 1.0)
            : Tween(begin: 1.0, end: 0.0),
        builder: (_, value, child) {
          return Transform.translate(
            offset: Offset(0.0, widget.cartHome ? 30 : 200 * value),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Mi Bolsa',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: bloc.cart.length,
                        itemBuilder: (context, index) {
                          final item = bloc.cart[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 50.0, left: 20),
                                child: Slidable.builder(
                                  key: UniqueKey(),
                                  controller: slidableController,
                                  direction: Axis.horizontal,
                                  actionPane: _getActionPane(index),
                                  actionExtentRatio: 0.25,
                                  dismissal: SlidableDismissal(
                                    child: SlidableDrawerDismissal(),
                                    closeOnCanceled: true,
                                  ),
                                  secondaryActionDelegate:
                                      SlideActionBuilderDelegate(
                                          actionCount: 1,
                                          builder: (context, index, animation,
                                              renderingMode) {
                                            return IconSlideAction(
                                              color: renderingMode ==
                                                      SlidableRenderingMode
                                                          .slide
                                                  ? Colors.red.withOpacity(
                                                      animation.value)
                                                  : Colors.red,
                                              icon: Icons.delete,
                                              onTap: () async {
                                                var state =
                                                    Slidable.of(context);

                                                state.dismiss();
                                                setState(() {
                                                  bloc.deleteProduct(item);
                                                });
                                              },
                                            );
                                          }),
                                  child: SizedBox(
                                    height: size.height / 10,
                                    child: ListTile(
                                      leading: Container(
                                          width: 50,
                                          height: 120,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              child: cachedNetworkImage(bloc
                                                  .cart[index]
                                                  .product
                                                  .images[0]
                                                  .url))),
                                      title: Text(
                                        '${item.product.name}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              '${item.product.description}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(),
                                            ),
                                          ),
                                          Text(
                                            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Colors.black),
                                                child: Row(
                                                  children: [
                                                    (item.quantity == 1)
                                                        ? Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 20),
                                                            child:
                                                                GestureDetector(
                                                              onDoubleTap: () {
                                                                bloc.deleteProduct(
                                                                    item);

                                                                /*     Slidable.of(context).open(
                                                                    actionType:
                                                                        SlideActionType
                                                                            .secondary) */
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: Colors
                                                                    .white,
                                                                size: 30,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 20),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (item.quantity >
                                                                    0) {
                                                                  setState(() {
                                                                    item.quantity--;
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                                size: 30,
                                                              ),
                                                            ),
                                                          ),
                                                    Container(
                                                      child: Text(
                                                        item.quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          item.quantity++;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 20),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 0.0),
                                      dense: true,
                                    ),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => {
                (bloc.cart.length > 0)
                    ? Navigator.push(context, ordenDetailImageRoute())
                    : null
              },
              child: Padding(
                padding: (widget.cartHome)
                    ? EdgeInsets.only(bottom: 50.0)
                    : EdgeInsets.all(20),
                child: Container(
                  child: Center(
                    child: goPayCartBtnSubtotal(
                      'Ir a pagar',
                      [
                        currentTheme.primaryColor,
                        currentTheme.primaryColor,
                      ],
                      false,
                      bloc.cart.length > 0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }
}
