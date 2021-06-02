import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Mi Bolsa',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                                    const EdgeInsets.symmetric(vertical: 15.0),
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
                                              },
                                            );
                                          }),
                                  child: SizedBox(
                                    height: 70,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                          bloc.cart[index].product.images[0]
                                              .url,
                                        ),
                                      ),
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
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          BoxConstraints(),
                                                      onPressed: () {
                                                        if (item.quantity > 2) {
                                                          setState(() {
                                                            item.quantity--;
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
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
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          BoxConstraints(),
                                                      onPressed: () {
                                                        setState(() {
                                                          item.quantity++;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 0.0),
                                      dense: true,
                                    ),
                                  ),
                                )),

                            /*  Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) => {
                                  setState(() {
                                    groceryStoreBloc.deleteProduct(item);
                                  })
                                },
                                background: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    )),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                          groceryStoreBloc.cart[index].product
                                              .images[0].url,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                        child: Text(item.quantity.toString())),
                                    const SizedBox(width: 10),
                                    Text('x'),
                                    const SizedBox(width: 10),
                                    Text(item.product.name),
                                    Spacer(),
                                    Text(
                                        '\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              
                              
                              
                              ),
                            
                            
                             */
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*  Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$${groceryStoreBloc.totalPriceElements().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ), */
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
                        bloc.cart.length > 0),
                  ),
                ),

                /* elevatedButtonCustom(

                      context: context,
                      title: 'Continuar compa',
                      onPress: () {
                        print('hello');
                        Navigator.push(context, ordenDetailImageRoute());
                      }) */
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
