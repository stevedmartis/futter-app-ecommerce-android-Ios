import 'package:australti_ecommerce_app/pages/products_list.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/utils.dart';
import 'package:australti_ecommerce_app/widgets/carousel_images_indicator.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:provider/provider.dart';

class ProductStoreDetails extends StatefulWidget {
  const ProductStoreDetails({
    Key key,
    @required this.product,
    @required this.isAuthUser,
    @required this.category,
    this.onProductAdded,
  }) : super(key: key);
  final ProfileStoreProduct product;
  final ValueChanged<int> onProductAdded;
  final bool isAuthUser;
  final ProfileStoreCategory category;

  @override
  _GroceryStoreDetailsState createState() => _GroceryStoreDetailsState();
}

class _GroceryStoreDetailsState extends State<ProductStoreDetails> {
  String heroTag = '';
  int quantity = 1;

  void _addToCart(BuildContext context) {
    setState(() {
      heroTag = 'details';
    });
    widget.onProductAdded(quantity);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CarouselImagesProductIndicator(
                          images: widget.product.images,
                          tag: 'list_${widget.product.images[0].url}' +
                              '${widget.product.name}' +
                              heroTag,
                        ),
                      ),
                      Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '100',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 2) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            '\$${widget.product.price}',
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Sobre el producto',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.description,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!widget.isAuthUser)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 25,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                            onPressed: () => null,
                          ),
                        )),
                    Spacer(),
                    Expanded(
                        flex: 6,
                        child: elevatedButtonCustom(
                            context: context,
                            title: 'Agregar a la bolsa',
                            onPress: () {
                              _addToCart(context);
                            })),
                  ],
                ),
              ),
            if (widget.isAuthUser)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 6,
                        child: elevatedButtonCustom(
                          context: context,
                          isDelete: true,
                          title: 'Eliminar',
                          onPress: () {
                            final act = CupertinoActionSheet(
                                title: Text('Eliminar este producto?',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                message: Text(
                                    'Se eliminara de tu lista de productos de forma permanente'),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      final productProvider =
                                          Provider.of<TabsViewScrollBLoC>(
                                              context,
                                              listen: false);
                                      productProvider
                                          .removeProductById(widget.product.id);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ));
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => act);
                          },
                        )),
                    Spacer(),
                    Expanded(
                        flex: 6,
                        child: elevatedButtonCustom(
                            isEdit: true,
                            context: context,
                            title: 'Editar',
                            onPress: () {
                              Navigator.of(context).push(
                                  createRouteAddEditProduct(
                                      widget.product, true, widget.category));
                            })),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  int index = 0;
  static List<String> values = ['Eliminar'];

  Widget buildCustomPicker() => SizedBox(
        height: 100,
        child: CupertinoPicker(
          itemExtent: 1,
          diameterRatio: 0.7,
          looping: false,
          onSelectedItemChanged: (index) => setState(() => this.index = index),
          // selectionOverlay: Container(),
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: Colors.red.withOpacity(0.12),
          ),
          children: Utils.modelBuilder<String>(
            values,
            (index, value) {
              final isSelected = this.index == index;
              final color = isSelected ? Colors.pink : Colors.black;

              return Center(
                child: Text(
                  value,
                  style: TextStyle(color: color, fontSize: 24),
                ),
              );
            },
          ),
        ),
      );
}
