import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/favorites_bloc.dart';
import 'package:australti_ecommerce_app/pages/products_list.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/product.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/utils.dart';
import 'package:australti_ecommerce_app/widgets/carousel_images_indicator.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../global/extension.dart';

class ProductStoreDetails extends StatefulWidget {
  const ProductStoreDetails(
      {Key key,
      @required this.product,
      @required this.isAuthUser,
      @required this.category,
      this.onProductAdded,
      this.fromFavorites = false,
      this.bloc})
      : super(key: key);
  final ProfileStoreProduct product;
  final ValueChanged<int> onProductAdded;
  final bool isAuthUser;
  final String category;

  final bool fromFavorites;

  final TabsViewScrollBLoC bloc;

  @override
  _GroceryStoreDetailsState createState() => _GroceryStoreDetailsState();
}

class _GroceryStoreDetailsState extends State<ProductStoreDetails>
    with TickerProviderStateMixin {
  String heroTag = '';
  int quantity = 1;

  final productService = new StoreProductService();

  AnimationController animatedController;

  void _addToCart(BuildContext context) {
    setState(() {
      heroTag = 'details';
    });
    widget.onProductAdded(quantity);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    animatedController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    animatedController.addListener(() {
      setState(() {
        _angle = (animatedController.value != 0.0)
            ? animatedController.value * 0.75
            : 0.5;
      });
    });

    if (widget.product.isLike) animatedController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animatedController.dispose();
    super.dispose();
  }

  double _angle = 0.6;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    final storeBloc = Provider.of<FavoritesBLoC>(context, listen: false);
    final authService = Provider.of<AuthenticationBLoC>(context);
    final tag = 'list_${widget.product.images[0].url}' +
        '${widget.product.name}' +
        heroTag;

    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        actions: [
          (!widget.isAuthUser)
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 25,
                    child: InkResponse(
                        onTap: () {
                          if (authService.storeAuth.user.uid == '0') {
                            authService.redirect = 'favoriteBtn';
                            Navigator.push(context, loginRoute(100));
                          } else
                            HapticFeedback.lightImpact();
                          if (animatedController.status ==
                              AnimationStatus.completed) {
                            addToFavoriteButtonTapped();
                            animatedController.reverse();
                            storeBloc.productsFavoritesList.removeWhere(
                                (item) => item.id == widget.product.id);
                            showSnackBar(
                                context, 'Se elimino de "Mis favoritos"');
                          }

                          if (animatedController.status ==
                              AnimationStatus.dismissed) {
                            addToFavoriteButtonTapped();

                            animatedController.forward();

                            storeBloc.productsFavoritesList
                                .insert(0, widget.product);

                            showSnackBar(
                                context, 'Agregado en "Mis favoritos"');
                          }
                        },
                        child: Transform.scale(
                          scale: _angle,
                          child: Icon(
                            (_angle > 0.6)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: (_angle > 0.6) ? Colors.red : Colors.grey,
                            size: 50,
                          ),
                        )),
                  ),
                )
              : Container(),
        ],
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CarouselImagesProductIndicator(
                            images: widget.product.images, tag: tag),
                      ),
                      Text(
                        widget.product.name.capitalize(),
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
                      if (!widget.isAuthUser)
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
                                      HapticFeedback.lightImpact();
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
                                      HapticFeedback.lightImpact();
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
                              '\$$priceformat',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      Text(
                        'Descripción',
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
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _addToCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        fixedSize: Size.fromWidth(size.width),
                        primary: currentTheme.primaryColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text('Agregar a la bolsa',
                          style: TextStyle(fontSize: 18))),
                ),
              ),
            if (widget.isAuthUser)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    elevatedButtonCustom(
                      context: context,
                      isDelete: true,
                      title: 'Eliminar',
                      onPress: () {
                        HapticFeedback.heavyImpact();

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
                                  HapticFeedback.heavyImpact();
                                  _deleteProduct();
                                },
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {},
                            ));
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => act);
                      },
                    ),
                    Spacer(),
                    elevatedButtonCustom(
                        context: context,
                        title: 'Editar',
                        onPress: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).push(createRouteAddEditProduct(
                              widget.product, true, widget.category));
                        },
                        isEdit: true,
                        isDelete: false),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<bool> addToFavoriteButtonTapped() async {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    final storeBLoC = Provider.of<StoreBLoC>(context, listen: false);
    final favoriteBloc = Provider.of<FavoritesBLoC>(context, listen: false);

    final success = await productService.addUpdateFavorite(
        widget.product.id, authBloc.storeAuth.user.uid);

    if (success.ok) {
      favoriteBloc.favoriteProduct(widget.product, success.favorite.isLike);
      storeBLoC.favoriteProduct(widget.product, success.favorite.isLike);
    }
    return true;
  }

  Future _deleteProduct() async {
    final productProvider =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);
    final res = await this.productService.deleteProduct(widget.product.id);

    if (res) {
      productProvider.removeProductById(
          this, widget.product, widget.product.user, context);
      setState(() {});

      showSnackBar(context, 'Producto eliminado');

      Navigator.pop(context);
      Navigator.pop(context);
    }
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
