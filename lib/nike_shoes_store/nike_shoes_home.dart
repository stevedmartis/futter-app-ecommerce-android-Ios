import 'package:flutter/material.dart';
import 'nike_shoes.dart';
import 'nike_shoes_details.dart';

class NikeShoesHome extends StatelessWidget {
  final ValueNotifier<bool> notifierBottomBarVisible = ValueNotifier(true);

  void _onShoesPressed(NikeShoes shoes, BuildContext context) async {
    notifierBottomBarVisible.value = false;
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          return FadeTransition(
            opacity: animation1,
            child: NikeShoesDetails(
              shoes: shoes,
            ),
          );
        },
      ),
    );
    notifierBottomBarVisible.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'assets/nike_shoes_store/nike_logo.png',
                  height: 40,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: shoes.length,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) {
                      final shoesItem = shoes[index];
                      return NikeShoesItem(
                        shoesItem: shoesItem,
                        onTap: () {
                          _onShoesPressed(shoesItem, context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: notifierBottomBarVisible,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.home),
                    ),
                    Expanded(
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: Icon(Icons.favorite_border),
                    ),
                    Expanded(
                      child: Icon(Icons.shopping_cart),
                    ),
                    Expanded(
                      child: Center(
                        child: CircleAvatar(
                          radius: 13,
                          backgroundImage: AssetImage('assets/logo.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              builder: (context, value, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: 0,
                  right: 0,
                  bottom: value ? 0.0 : -kToolbarHeight,
                  height: kToolbarHeight,
                  child: child,
                );
              }),
        ],
      ),
    );
  }
}

class NikeShoesItem extends StatelessWidget {
  final NikeShoes shoesItem;
  final VoidCallback onTap;

  const NikeShoesItem({
    Key key,
    this.shoesItem,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const itemHeight = 290.0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: SizedBox(
          height: itemHeight,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: Hero(
                  tag: 'background_${shoesItem.model}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(shoesItem.color),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: 'number_${shoesItem.model}',
                  child: SizedBox(
                    height: itemHeight * 0.6,
                    child: Material(
                      color: Colors.transparent,
                      child: FittedBox(
                        child: Text(
                          shoesItem.modelNumber.toString(),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.05),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 100,
                height: itemHeight * 0.65,
                child: Hero(
                  tag: 'image_${shoesItem.model}',
                  child: Image.asset(
                    shoesItem.images.first,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        shoesItem.model,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              Text(
                                '\$${shoesItem.oldPrice.toInt().toString()}',
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '\$${shoesItem.currentPrice.toInt().toString()}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          Icon(
                            Icons.shopping_basket,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
