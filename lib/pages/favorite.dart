import 'package:animate_do/animate_do.dart';

import 'package:freeily/bloc_globals/bloc/favorites_bloc.dart';
import 'package:freeily/bloc_globals/notitification.dart';
import 'package:freeily/grocery_store/grocery_store_bloc.dart';
import 'package:freeily/models/profile.dart';
import 'package:freeily/models/store.dart';

import 'package:freeily/profile_store.dart/product_detail.dart';

import 'package:freeily/services/catalogo.dart';
import 'package:freeily/sockets/socket_connection.dart';
import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:freeily/store_product_concept/store_product_bloc.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/header_pages_custom.dart';
import 'package:freeily/widgets/image_cached.dart';
import 'package:freeily/widgets/show_alert_error.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../global/extension.dart';

class MyFavorites extends StatefulWidget {
  @override
  _MyFavoritesState createState() => _MyFavoritesState();
}

const _textColor = Color(0xFF5C5657);

class _MyFavoritesState extends State<MyFavorites> {
  SocketService socketService;

  final category = new ProfileStoreCategory(id: '');

  bool loading = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
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
            controller: _scrollController,
            slivers: <Widget>[
              makeHeaderCustom('Mis Favoritos'),
              makeListCatalogos(context)
              //makeListProducts(context)
            ]),
      ),
    );
  }

  SliverList makeListCatalogos(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      CatalogsList(bloc: tabsViewScrollBLoC, loading: loading),
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
                child: CustomAppBarHeaderPages(
                  showTitle: _showTitle,
                  title: title,
                  isAdd: false,
                  action: Container(),
                  //   Container()
                ))));
  }
}

class CatalogsList extends StatefulWidget {
  CatalogsList({this.bloc, this.loading});

  final TabsViewScrollBLoC bloc;

  final bool loading;

  @override
  _CatalogsListState createState() => _CatalogsListState();
}

class _CatalogsListState extends State<CatalogsList>
    with TickerProviderStateMixin {
  Profile profile;

  final catalogoService = new StoreCategoiesService();

  List<TabCategory> catalogos = [];

  List<TabCategory> catalogosOrderPosition = [];
  SlidableController slidableController;
  Store storeAuth;
  @override
  void initState() {
    super.initState();
  }

  bool expanded = false;
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

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<FavoritesBLoC>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'Mis Favoritos',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
          (_bloc.productsFavoritesList.length > 0)
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: _bloc.productsFavoritesList.length,
                    itemBuilder: (context, index) {
                      if (_bloc.productsFavoritesList.length > 0) {
                        final item = _bloc.productsFavoritesList[index];
                        return FadeIn(
                            child:
                                ProfileStoreProductItem(item, item.category));
                      } else {
                        return Center(
                            child: Container(
                          child: Text('Sin Favoritos'),
                        ));
                      }
                    },
                  ))
              : Center(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text('Sin favoritos',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
        ],
      ),
    );
  }
}

class ProfileStoreProductItem extends StatelessWidget {
  const ProfileStoreProductItem(this.product, this.categoryId);

  final String categoryId;

  final ProfileStoreProduct product;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final groceryBloc = Provider.of<GroceryStoreBLoC>(context);

    final _bloc = Provider.of<TabsViewScrollBLoC>(context);

    final tag = 'list_${product.images[0].url + product.name + '0'}';
    final size = MediaQuery.of(context).size;
    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(product.price);

    return GestureDetector(
      onTap: () async {
        groceryBloc.changeToDetails();
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    fromFavorites: true,
                    category: categoryId,
                    isAuthUser: false,
                    product: product,
                    bloc: _bloc,
                    onProductAdded: (int quantity) {
                      groceryBloc.addProduct(product, quantity);

                      _listenNotification(context);

                      showSnackBar(context, 'Agregado a la bolsa');
                    }),
              );
            },
          ),
        );
        groceryBloc.changeToNormal();
      },
      child: Container(
        height: size.height / 5.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: currentTheme.currentTheme.cardColor,
            child: Row(
              children: [
                Container(
                  child: Hero(
                      tag: tag,
                      child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  child: cachedContainNetworkImage(
                                      product.images[0].url))))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width / 2,
                        child: Text(
                          product.name.capitalize(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: (currentTheme.customTheme)
                                ? Colors.white
                                : _textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: size.width / 2,
                        child: Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$$priceformat',
                        style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : _textColor,
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

  void _listenNotification(context) {
    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;
    number++;
    notifiModel.numberNotifiBell = number;

    if (number >= 2) {
      //final controller = notifiModel.bounceControllerBell;
      //controller.forward(from: 0.0);
    }
  }
}
