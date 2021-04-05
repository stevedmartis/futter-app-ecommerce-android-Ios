import 'package:flutter/material.dart';
import 'package:australti_feriafy_app/grocery_store/grocery_store_bloc.dart';

import 'grocery_provider.dart';

const _blueColor = Color(0xFF0D1863);

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
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    item.product.image,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(item.quantity.toString()),
                                const SizedBox(width: 10),
                                Text('x'),
                                const SizedBox(width: 10),
                                Text(item.product.name),
                                Spacer(),
                                Text(
                                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    bloc.deleteProduct(item);
                                  },
                                ),
                              ],
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
