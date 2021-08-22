import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc/favorites_bloc.dart';
import 'package:australti_ecommerce_app/pages/products_list.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/product.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/utils.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
  ScrollController _scrollController;
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
    _scrollController = ScrollController()..addListener(() => setState(() {}));
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
    _scrollController?.dispose();
    animatedController.dispose();
    super.dispose();
  }

  double _angle = 0.6;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final storeBloc = Provider.of<FavoritesBLoC>(context);
    final authService = Provider.of<AuthenticationBLoC>(context);
    final tag = 'list_${widget.product.images[0].url}' +
        '${widget.product.name}' +
        heroTag;
    final size = MediaQuery.of(context).size;

    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price * quantity);

    var type = widget.product.images[0].url.split(".").last;

    bool isPng = (type.toLowerCase() == 'png');
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: (!widget.isAuthUser)
              ? Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 10, right: 0, left: 10),
                  child: Row(children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
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
                                  if (quantity > 1) {
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
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 0),
                      child: SizedBox(
                          height: 50,
                          width: size.width / 2.2,
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
                              child: Row(children: [
                                Text('Add', style: TextStyle(fontSize: 15)),
                                Spacer(),
                                Text(
                                  '\$$priceformat',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                ),
                              ]))),
                    )
                  ]),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10,
                    bottom: 20,
                  ),
                  child: SizedBox(
                      height: 50,
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
                          SizedBox(
                              height: 100,
                              width: size.width / 3,
                              child: ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.of(context).push(
                                        createRouteAddEditProduct(
                                            widget.product,
                                            true,
                                            widget.category));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5.0,
                                    fixedSize: Size.fromWidth(size.width),
                                    primary: Colors.grey[200],
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Editar',
                                    style: TextStyle(color: Colors.black),
                                  )))
                        ],
                      )),
                ),
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 10),
                      child: CircleAvatar(
                        backgroundColor: currentTheme.scaffoldBackgroundColor
                            .withOpacity(0.70),
                        radius: 50,
                        child: InkResponse(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 35,
                            )),
                      ),
                    ),
                    leadingWidth: 70,
                    backgroundColor: currentTheme.scaffoldBackgroundColor,
                    actions: [
                      (!widget.isAuthUser)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 10.0, top: 10),
                              child: CircleAvatar(
                                backgroundColor: currentTheme
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.70),
                                radius: 20,
                                child: InkResponse(
                                    onTap: () {
                                      if (authService.storeAuth.user.uid ==
                                          '0') {
                                        authService.redirect = 'favoriteBtn';
                                        Navigator.push(context, loginRoute());
                                      } else
                                        HapticFeedback.lightImpact();
                                      if (animatedController.status ==
                                          AnimationStatus.completed) {
                                        addToFavoriteButtonTapped();
                                        animatedController.reverse();
                                        storeBloc.productsFavoritesList
                                            .removeWhere((item) =>
                                                item.id == widget.product.id);
                                        showSnackBar(context,
                                            'Se elimino de "Mis favoritos"');
                                      }
                                      if (animatedController.status ==
                                          AnimationStatus.dismissed) {
                                        addToFavoriteButtonTapped();
                                        animatedController.forward();
                                        storeBloc.productsFavoritesList
                                            .insert(0, widget.product);
                                        showSnackBar(context,
                                            'Agregado en "Mis favoritos"');
                                      }
                                    },
                                    child: Transform.scale(
                                      scale: _angle,
                                      child: Icon(
                                        (_angle > 0.6)
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: (_angle > 0.6)
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 35,
                                      ),
                                    )),
                              ),
                            )
                          : Container(),
                    ],
                    stretch: true,
                    expandedHeight: 250.0,
                    collapsedHeight: 70,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.fadeTitle,
                        // StretchMode.blurBackground
                      ],
                      background: Material(
                        type: MaterialType.transparency,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                          child: (widget.product.images.length > 1)
                              ? Swiper(
                                  itemCount: widget.product.images.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Hero(
                                      tag: tag + '$index',
                                      child: Container(
                                        padding:
                                            EdgeInsets.all((isPng) ? 20 : 0),
                                        child: cachedContainNetworkImage(
                                          widget.product.images[index].url,
                                        ),
                                      ),
                                    );
                                  },
                                  pagination: new SwiperPagination(
                                      margin: new EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 0.0),
                                      builder: new DotSwiperPaginationBuilder(
                                          color: Colors.grey,
                                          activeColor:
                                              currentTheme.primaryColor,
                                          size: 14.0,
                                          activeSize: 18.0)),
                                  autoplay: false,
                                )
                              : Container(
                                  child: Hero(
                                    tag: tag + '$index',
                                    child: Container(
                                      padding: EdgeInsets.all((isPng) ? 20 : 0),
                                      child: cachedContainNetworkImage(
                                        widget.product.images[0].url,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      centerTitle: true,
                    )),
                makeInfoProduct(tag)
              ])),
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
    productProvider.removeProductById(
        this, widget.product, widget.product.user, context);
    if (res) {
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

  SliverToBoxAdapter makeInfoProduct(String tag) {
    return SliverToBoxAdapter(
      child: infoProduct(tag),
    );
  }

  Widget infoProduct(String tag) {
    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 20.0, right: 20.0, bottom: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.product.name.capitalize(),
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '\$$priceformat',
                      style: TextStyle(color: Color(0xff32D73F), fontSize: 25),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'c/u',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
      ],
    );
  }
}
