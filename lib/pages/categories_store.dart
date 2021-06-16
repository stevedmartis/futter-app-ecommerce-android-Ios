import 'dart:async';

import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/models/profile.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/add_edit_category.dart';
import 'package:australti_ecommerce_app/responses/store_categories_response.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/services/catalogo.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import '../global/extension.dart';

class CatalogosListPage extends StatefulWidget {
  @override
  _CatalogosListPagePageState createState() => _CatalogosListPagePageState();
}

class _CatalogosListPagePageState extends State<CatalogosListPage> {
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
              makeHeaderCustom('Mis Catalogos'),
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
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                        showTitle: _showTitle,
                        title: title,
                        isAdd: true,
                        action: Container(),
                        //   Container()
                        onPress: () => {
                              (loading)
                                  ? null
                                  : Navigator.of(context).push(
                                      createRouteAddEditCategory(
                                          category, false, tabsViewScrollBLoC)),
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
  var _isVisible;

  ScrollController _hideBottomNavController;
  List<TabCategory> catalogos = [];

  List<TabCategory> catalogosOrderPosition = [];
  SlidableController slidableController;
  Store storeAuth;
  @override
  void initState() {
    super.initState();

    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);
    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;
    if (!productsBloc.initialOK) productsBloc.init(this, context);

    _chargeCatalogs();

    bottomControll();
  }

  _chargeCatalogs() async {
    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    catalogos = productsBloc.tabs;

    //catalogoBloc.getMyCatalogos(profile.user.uid);
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = this.catalogos.removeAt(oldindex);
      this.catalogos.insert(newindex, items);
    });
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
        child: Container(
            height: (catalogos.length > 0)
                ? 160 * (catalogos.length).toDouble()
                : 160,
            child: _buildCatalogoWidget()));
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
  Future _deleteCategory(String id, int index) async {
    final res = await this.catalogoService.deleteCatalogo(id);

    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    if (res) {
      setState(() {
        return true;
      });

      productsBloc.removeCategoryById(this, id, storeAuth.user.uid, context);

      return true;
    }
  }

  Widget _buildCatalogoWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Text(
            'Mis Catalogos',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: currentTheme.currentTheme.accentColor),
          ),
        ),
        (catalogos.length > 0)
            ? Container(
                child: ReorderableListView(
                    padding: EdgeInsets.only(top: 70),
                    scrollController: _hideBottomNavController,
                    children: List.generate(
                      catalogos.length,
                      (index) {
                        final item = catalogos[index].category;

                        final products = item.products.length;

                        final visibiliy = item.visibility;
                        return Slidable.builder(
                          key: Key(item.id),
                          controller: slidableController,
                          direction: Axis.horizontal,
                          dismissal: SlidableDismissal(
                            child: SlidableDrawerDismissal(),
                            closeOnCanceled: true,
                            onWillDismiss: (actionType) {
                              return showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    if (UniversalPlatform.isAndroid) {
                                      return AlertDialog(
                                        backgroundColor:
                                            currentTheme.currentTheme.cardColor,
                                        title: Text(
                                          'Eliminar Catalogo',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          'Seguro de realizar esta acción?',
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              child: Text(
                                                'Eliminar',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              ),
                                              onPressed: () => {
                                                    Navigator.of(context)
                                                        .pop(true),
                                                  }),
                                          TextButton(
                                              child: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 18),
                                              ),
                                              onPressed: () => {
                                                    Navigator.of(context)
                                                        .pop(false),
                                                  }),
                                        ],
                                      );
                                    } else {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                          'Eliminar Catalogo',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          'Seguro de realizar esta acción?',
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: Text(
                                              'Eliminar',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () => {
                                              Navigator.of(context).pop(true),
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            isDefaultAction: false,
                                            child: Text(
                                              'Cancelar',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            onPressed: () => {
                                              Navigator.of(context).pop(false),
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  }) as FutureOr<bool>;
                            } as FutureOr<bool> Function(SlideActionType),
                            onDismissed: (actionType) {
                              showSnackBar(context, 'Catalogo Eliminado');
                              setState(() {
                                catalogos.removeAt(index);
                                _deleteCategory(item.id, index);
                              });
                            },
                          ),
                          actionPane: _getActionPane(index),
                          actionExtentRatio: 0.25,
                          secondaryActionDelegate: SlideActionBuilderDelegate(
                              actionCount: 2,
                              builder:
                                  (context, index, animation, renderingMode) {
                                if (index == 0) {
                                  return IconSlideAction(
                                    caption: 'Editar',
                                    color: renderingMode ==
                                            SlidableRenderingMode.slide
                                        ? currentTheme.currentTheme.accentColor
                                            .withOpacity(animation.value)
                                        : (renderingMode ==
                                                SlidableRenderingMode.dismiss
                                            ? currentTheme
                                                .currentTheme.accentColor
                                            : currentTheme
                                                .currentTheme.accentColor),
                                    icon: Icons.edit,
                                    onTap: () async {
                                      Navigator.of(context).push(
                                          createRouteAddEditCategory(
                                              item, true, widget.bloc));
                                    },
                                    closeOnTap: true,
                                  );
                                } else {
                                  return IconSlideAction(
                                    caption: 'Eliminar',
                                    color: renderingMode ==
                                            SlidableRenderingMode.slide
                                        ? Colors.red
                                            .withOpacity(animation.value)
                                        : Colors.red,
                                    icon: Icons.delete,
                                    onTap: () async {
                                      var state = Slidable.of(context);

                                      state.dismiss();
                                    },
                                  );
                                }
                              }),
                          child: Container(
                            decoration: BoxDecoration(
                                color: currentTheme.currentTheme.cardColor),
                            child: Material(
                              color: currentTheme.currentTheme.cardColor,
                              child: InkWell(
                                splashColor: Colors.white,
                                radius: 30,
                                onTap: () => {
                                  Navigator.push(context,
                                      groceryListRoute(item, widget.bloc)),
                                  HapticFeedback.selectionClick()
                                },
                                child: Container(
                                  key: Key(item.id),
                                  padding: EdgeInsets.only(bottom: 1.0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: SizedBox(
                                          height: size.height / 8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20.0, 10.0, 2.0, 0.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            item.name
                                                                .capitalize(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: (currentTheme
                                                                      .customTheme)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              FaIcon(
                                                                (visibiliy)
                                                                    ? FontAwesomeIcons
                                                                        .eye
                                                                    : FontAwesomeIcons
                                                                        .eyeSlash,
                                                                size: 20,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text(
                                                                (visibiliy)
                                                                    ? 'Publico'
                                                                    : 'Privado',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                  color: (currentTheme
                                                                          .customTheme)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                'Productos: ',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                  color: (currentTheme
                                                                          .customTheme)
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              Text(
                                                                ' $products',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: (currentTheme
                                                                          .customTheme)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ])),
                                              ),
                                              SizedBox(
                                                  width: 50,
                                                  child: Center(
                                                      child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons
                                                          .format_list_bulleted,
                                                      color: currentTheme
                                                          .currentTheme
                                                          .primaryColor,
                                                      size: 30,
                                                    ),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.0,
                                        child: Center(
                                          child: Container(
                                            height: 1.0,
                                            color: currentTheme.currentTheme
                                                .scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onReorder: (int oldIndex, int newIndex) => {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }

                            final TabCategory catalogo =
                                catalogos.removeAt(oldIndex);
                            catalogo.category.position = newIndex;
                            catalogos.insert(newIndex, catalogo);
                          }),
                          _updateCatalogo(catalogos)
                        }),
              )
            : Center(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text('Sin catalogos',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
      ],
    );
  }

  _updateCatalogo(List<TabCategory> catalogos) async {
    final List<Map<String, Object>> orderArray = [];
    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    for (var item in catalogos) {
      final category = {
        'id': item.category.id,
        'name': item.category.name,
        'description': item.category.description,
        'position': item.category.position
      };
      orderArray.add(category);
    }
    final resp = await this.catalogoService.updatePositionCatalogo(orderArray);

    if (resp) {
      final StoreCategoriesResponse respMyCategories = await this
          .catalogoService
          .getMyCategoriesProducts(storeAuth.user.uid);

      if (respMyCategories.ok) {
        productsBloc.orderPosition(
            this, respMyCategories.storeCategoriesProducts, context);
        showSnackBar(context, 'Posición editada con exito!');
      }
    }
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
