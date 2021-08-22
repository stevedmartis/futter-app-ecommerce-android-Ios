import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/cards_services_bloc.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../global/extension.dart';

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
    final creditCardBloc = Provider.of<CreditCardServices>(context);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        'Mi Bolsa',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 0, top: 10),
                        child: ListView.builder(
                          itemCount: bloc.cart.length,
                          itemBuilder: (context, index) {
                            final item = bloc.cart[index];

                            final priceformat = NumberFormat.currency(
                                    locale: 'id', symbol: '', decimalDigits: 0)
                                .format(item.product.price);
                            return Container(
                              padding: EdgeInsets.only(top: 20),
                              child: FadeInUp(
                                delay: Duration(milliseconds: 100 * index),
                                child: Slidable.builder(
                                  key: Key(item.product.id),
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
                                    height: size.height / 7.2,
                                    child: ListTile(
                                      leading: Container(
                                          width: 60,
                                          height: 120,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              child: cachedNetworkImage(bloc
                                                  .cart[index]
                                                  .product
                                                  .images[0]
                                                  .url))),
                                      title: Container(
                                        width: size.width / 2,
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: size.width / 2.2,
                                                  child: Text(
                                                    '${item.product.name.capitalize()}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: size.width / 2.5,
                                                  child: Text(
                                                    (item.product.description !=
                                                            "")
                                                        ? '${item.product.description.capitalize()}'
                                                        : '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '\$$priceformat',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              margin: EdgeInsets.only(
                                                  left: size.width / 8.5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    color: Colors.black,
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        (item.quantity == 1)
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    HapticFeedback
                                                                        .lightImpact();
                                                                    if (item.quantity >
                                                                        0) {
                                                                      setState(
                                                                          () {
                                                                        item.quantity--;
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            item.quantity
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              HapticFeedback
                                                                  .lightImpact();
                                                              item.quantity++;
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 20),
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {
                HapticFeedback.mediumImpact(),
                /* (bloc.cart.length > 0)
                    ? Navigator.push(context, orderDetailRoute())
                    : null */

                (bloc.cart.length > 0)
                    ? (creditCardBloc.cardselectedToPay.valueOrNull != null)
                        ? Navigator.push(context, orderDetailRoute())
                        : Navigator.push(
                            context, paymentMethodsOptionsRoute(true))
                    : null
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.0),
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
