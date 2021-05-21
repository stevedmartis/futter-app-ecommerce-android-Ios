import 'dart:async';

import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/models/profile.dart';
import 'package:australti_ecommerce_app/pages/add_edit_category.dart';
import 'package:australti_ecommerce_app/pages/single_image_upload.dart';
import 'package:australti_ecommerce_app/profile_store.dart/product_detail.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/catalogo.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

class ProductsListPage extends StatefulWidget {
  ProductsListPage({this.bloc});
  final TabsViewScrollBLoC bloc;
  @override
  _CatalogosListPagePageState createState() => _CatalogosListPagePageState();
}

class _CatalogosListPagePageState extends State<ProductsListPage> {
  SocketService socketService;

  final category = new ProfileStoreCategory(id: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // roomBloc.disposeRooms();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    // final roomsModel = Provider.of<Room>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              makeHeaderCustom('Mi Tienda'),
              makeListCatalogos(context)
            ]),
      ),
    );
  }

  SliverList makeListCatalogos(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      CatalogsList(
        bloc: widget.bloc,
      ),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                        title: title,
                        isAdd: true,
                        action: Container(),
                        //   Container()
                        onPress: () => {
                              Navigator.of(context).push(
                                  createRouteAddEditCategory(
                                      category, false, widget.bloc)),
                            })))));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }
}

class CatalogsList extends StatefulWidget {
  CatalogsList({this.bloc});

  final TabsViewScrollBLoC bloc;

  @override
  _CatalogsListState createState() => _CatalogsListState();
}

class _CatalogsListState extends State<CatalogsList>
    with TickerProviderStateMixin {
  Profile profile;

  final catalogoService = new StoreCategoiesService();
  var _isVisible;

  ScrollController _hideBottomNavController;
  List<ProfileStoreProduct> products = [];
  SlidableController slidableController;

  @override
  void initState() {
    super.initState();

    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    widget.bloc.init(this, authBloc.storeAuth.user.uid);

    _chargeCatalogs();

    bottomControll();
  }

  _chargeCatalogs() async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    profile = authService.profile;

    products = widget.bloc.productsByCategoryList;

    //catalogoBloc.getMyCatalogos(profile.user.uid);
  }

  bottomControll() {
    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
            });
        }
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
      },
    );
  }

/*   _PatternVibrate() {
    HapticFeedback.mediumImpact();

    sleep(
      const Duration(milliseconds: 200),
    );

    HapticFeedback.mediumImpact();

    sleep(
      const Duration(milliseconds: 500),
    );

    HapticFeedback.mediumImpact();

    sleep(
      const Duration(milliseconds: 200),
    );
    HapticFeedback.mediumImpact();
  } */

  @override
  Widget build(BuildContext context) {
    return Container(
        child: (products.length > 0)
            ? Container(
                height: 160 * (products.length).toDouble(),
                child: _buildProductsList())
            : Container(
                padding: EdgeInsets.all(50),
                child: Center(child: Text('Vacio')),
              ));

    /*  Container(
      height: double.maxFinite,
      child: StreamBuilder<StoreCategoriesResponse>(
        stream: _bloc.myCatalogos.stream,
        builder: (context, AsyncSnapshot<StoreCategoriesResponse> snapshot) {
          if (snapshot.hasData) {
            catalogos = snapshot.data.storeCategories;

            return (catalogos.length > 0)
                ? Container(child: _buildCatalogoWidget(catalogos))
                : _buildEmptyWidget(); // image is ready

          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
    ); */
  }

/*   Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildEmptyWidget() {
    return Container(
        height: 400.0, child: Center(child: Text('Sin Catalogos, crea nuevo')));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }
 */
/*   Future _deleteCategory(String id, int index) async {
    final res = await this.catalogoService.deleteCatalogo(id);
    if (res) {
      setState(() {
        catalogos.removeAt(index);

        return true;
        // catalogoBloc.getMyCatalogos(profile.user.uid);
      });

      return true;
    }
  }
 */

  Widget _buildProductsList() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Text(
            'Productos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 70),
          child: ListView.builder(
            shrinkWrap: true,
            controller: widget.bloc.scrollController,
            itemCount: widget.bloc.productsByCategoryList.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = widget.bloc.productsByCategoryList[index];

              return _ProfileAuthStoreProductItem(item);
            },
          ),
        )
      ],
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

void _showSnackBar(BuildContext context, String text) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: (currentTheme.customTheme) ? Colors.black : Colors.black,
      content: Text(text,
          style: TextStyle(
            color: (currentTheme.customTheme) ? Colors.white : Colors.white,
          ))));
}

Route createRouteAddEditCategory(
    ProfileStoreCategory category, bool isEdit, TabsViewScrollBLoC bloc) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateCategoryPage(category: category, isEdit: isEdit, bloc: bloc),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}

class _ProfileAuthStoreProductItem extends StatelessWidget {
  const _ProfileAuthStoreProductItem(this.product);
  final ProfileStoreProduct product;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    product: product, onProductAdded: (int quantity) {}),
              );
            },
          ),
        );
      },
      child: Container(
        height: productHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: currentTheme.currentTheme.cardColor,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Hero(
                      tag: 'list_${product.name}',
                      child: Image.network(product.image)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.description,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
