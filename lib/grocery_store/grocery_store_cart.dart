import 'package:flutter/material.dart';
import 'package:australti_feriafy_app/grocery_store/grocery_store_bloc.dart';

import 'grocery_provider.dart';

const _blueColor = Color(0xFF00649FE);

class GroceryStoreCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GroceryProvider.of(context).bloc;
    return SafeArea(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: bloc.groceryState != GroceryState.cart
            ? Tween(begin: 0.0, end: 1.0)
            : Tween(begin: 1.0, end: 0.0),
        builder: (_, value, child) {
          return Transform.translate(
            offset: Offset(0.0, 200 * value),
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
                      'Cart',
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) =>
                                  {bloc.deleteProduct(item)},
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
                                      backgroundImage: AssetImage(
                                        item.product.image,
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
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
                    '\$${bloc.totalPriceElements().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _blueColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () => null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
