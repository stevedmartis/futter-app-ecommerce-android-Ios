import 'package:animate_do/animate_do.dart';
import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/models/store.dart';

import 'package:freeily/pages/favorite.dart';
import 'package:freeily/sockets/socket_connection.dart';
import 'package:freeily/store_principal/store_principal_bloc.dart';
import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/circular_progress.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class SearchPrincipalPage extends StatefulWidget {
  SearchPrincipalPage({this.storeListServices});
  final List<Store> storeListServices;
  @override
  _SearchPrincipalPageState createState() => _SearchPrincipalPageState();
}

class _SearchPrincipalPageState extends State<SearchPrincipalPage> {
  SocketService socketService;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    storeBloc.storesSearch = widget.storeListServices;

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

  /*  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  } */

  final textCtrl = TextEditingController();

  FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    // final roomsModel = Provider.of<Room>(context);
    final storeBLoC = Provider.of<StoreBLoC>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                makeHeaderCustom('Mis Catalogos'),

                if (storeBLoC.loadingSearch)
                  SliverToBoxAdapter(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: buildLoadingWidget(context)),
                  ),

                if (!storeBLoC.loadingSearch &&
                    widget.storeListServices.length != 0 &&
                    storeBLoC.storesSearch.length == 0 &&
                    storeBLoC.productsSearch.length == 0)
                  SliverToBoxAdapter(
                    child: FadeIn(
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No se encontraron resultados',
                              style: TextStyle(color: Colors.grey),
                            )),
                      ),
                    ),
                  ),

                if (!storeBLoC.loadingSearch &&
                    widget.storeListServices.length == 0 &&
                    storeBLoC.storesSearch.length == 0)
                  SliverToBoxAdapter(
                    child: FadeIn(
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No hay tiendas en esta ubicación',
                              style: TextStyle(color: Colors.grey),
                            )),
                      ),
                    ),
                  ),

                if (storeBLoC.storesSearch.length > 0) makeListStores(context),
                if (!storeBLoC.loadingSearch &&
                    storeBLoC.productsSearch.length > 0)
                  makeListProducts(context)

                //makeListProducts(context)
              ]),
        ),
      ),
    );
  }

  SliverList makeListStores(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      SearchStoresResultList(),
    ]));
  }

  SliverList makeListProducts(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      SearchProductsResultList(),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    final storeBLoC = Provider.of<StoreBLoC>(context);

    final authBLoC = Provider.of<AuthenticationBLoC>(context);

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: currentTheme.currentTheme.scaffoldBackgroundColor,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentTheme.currentTheme.cardColor),
                      child: Row(
                        children: [
                          Material(
                            color: currentTheme.currentTheme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              splashColor: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              radius: 30,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              highlightColor: Colors.grey,
                              child: Container(
                                width: 34,
                                height: 34,
                                child: Icon(
                                  Icons.chevron_left,
                                  color: currentTheme.currentTheme.primaryColor,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                color: currentTheme.currentTheme.cardColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 20, left: 10),
                                      child: TextField(
                                        style: TextStyle(color: Colors.white),
                                        inputFormatters: [
                                          new LengthLimitingTextInputFormatter(
                                              20),
                                        ],
                                        focusNode: _focusNode,
                                        autofocus: true,
                                        controller: textCtrl,
                                        //  keyboardType: TextInputType.emailAddress,

                                        maxLines: 1,

                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: currentTheme
                                                    .currentTheme.cardColor),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.white54),
                                          // icon: Icon(Icons.perm_identity),
                                          //  fillColor: currentTheme.primaryColor,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: currentTheme
                                                    .currentTheme.cardColor,
                                                width: 0.0),
                                          ),
                                          hintText: '',
                                          //  labelText: 'Buscar ...',
                                          //counterText: snapshot.data,
                                          //  errorText: snapshot.error
                                        ),
                                        onChanged: (value) => storeBLoC
                                            .searchStoresOrProductsByQuery(
                                                value,
                                                authBLoC.storeAuth.user.uid),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: -2,
                                    child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: ShapeDecoration(
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 2.0,
                                                spreadRadius: 1.0,
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            gradient: LinearGradient(
                                                colors: gradients,
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight),
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ))),
                    SizedBox(width: 10),
                  ],
                ))));
  }
}

class SearchStoresResultList extends StatefulWidget {
  @override
  _SearchResultListState createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchStoresResultList>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  ScrollController _scrollController;

  bool expanded = false;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final storeBLoC = Provider.of<StoreBLoC>(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: storeBLoC.storesSearch.length,
            itemBuilder: (context, index) {
              if (storeBLoC.storesSearch.length > 0) {
                final store = storeBLoC.storesSearch[index];
                return FadeIn(
                  child: StoreCard(
                    store: store,
                  ),
                );
              } else {
                return Center(
                    child: Container(
                  child: Text('No'),
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}

class SearchProductsResultList extends StatefulWidget {
  @override
  _SearchProductsResultListState createState() =>
      _SearchProductsResultListState();
}

class _SearchProductsResultListState extends State<SearchProductsResultList>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  ScrollController _scrollController;

  bool expanded = false;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final storeBLoC = Provider.of<StoreBLoC>(context);
    return Stack(
      children: [
        if (storeBLoC.storesSearch.length > 0)
          Container(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Divider()),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: storeBLoC.productsSearch.length,
            itemBuilder: (context, index) {
              if (storeBLoC.productsSearch.length > 0) {
                final product = storeBLoC.productsSearch[index];
                return FadeIn(
                    child: ProfileStoreProductItem(product, product.category));
              } else {
                return Center(
                    child: Container(
                  child: Text('No'),
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}
