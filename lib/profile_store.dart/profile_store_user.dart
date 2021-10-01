import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/notitification.dart';
import 'package:freeily/grocery_store/grocery_store_bloc.dart';
import 'package:freeily/models/store.dart';
import 'package:freeily/pages/principal_home_page.dart';

import 'package:freeily/preferences/user_preferences.dart';

import 'package:freeily/profile_store.dart/profile_store_auth.dart';
import 'package:freeily/responses/store_response.dart';
import 'package:freeily/routes/routes.dart';

import 'package:freeily/services/catalogo.dart';
import 'package:freeily/services/follow_service.dart';
import 'package:freeily/services/stores_Services.dart';

import 'package:freeily/store_principal/store_principal_bloc.dart';
import 'package:freeily/store_principal/store_principal_home.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/circular_progress.dart';

import 'package:freeily/widgets/elevated_button_style.dart';
import 'package:freeily/widgets/image_cached.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freeily/profile_store.dart/product_detail.dart';
import 'package:freeily/store_product_concept/store_product_bloc.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';
import 'package:freeily/widgets/show_alert_error.dart';

import 'package:freeily/widgets/sliver_card_animation/body_sliver.dart';

import 'package:freeily/widgets/sliver_card_animation/cut_rectangle.dart';
import 'package:freeily/widgets/sliver_card_animation/data_cut_rectangle.dart';

import 'package:intl/intl.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../global/extension.dart';

import 'package:url_launcher/url_launcher.dart';

class ProfileStoreSelect extends StatefulWidget {
  ProfileStoreSelect(
      {this.isAuthUser = false, this.store, this.storeUsername = '0'});

  final bool isAuthUser;

  final Store store;

  final String storeUsername;

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStoreSelect>
    with TickerProviderStateMixin {
  final _bloc = TabsViewScrollBLoC();

  bool isStoreRoute = false;

  AnimationController _animationController;

  bool loading = false;
  bool loadingok = false;

  Store store;

  int colorVibrant;

  String phoneStore;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    final followService = Provider.of<FollowService>(context, listen: false);

    setState(() {
      store = widget.store;

      phoneStore = store.user.phone.toString();
      colorVibrant = int.parse(store.colorVibrant);
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      followService.followers = store.followers;
    });

    categoriesStoreProducts();

    super.initState();
  }

  void categoriesStoreProducts() async {
    setState(() {
      loadingok = true;
      loading = true;
    });

    final storeService =
        Provider.of<StoreCategoiesService>(context, listen: false);

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final resp = await storeService.getAllCategoriesProducts(
        store.user.uid,
        (authService.storeAuth.user != null)
            ? authService.storeAuth.user.uid
            : '0');

    if (resp.ok) {
      _bloc.storeCategoriesProducts = resp.storeCategoriesProducts;

      _bloc.initStoreSelect(this, context, store);

      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 1300),
      );

      setState(() {
        loadingok = true;
        loading = false;
      });
    }
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    textCtrl.text = "";
    textCtrl.clear();
    _animationController.dispose();

    _bloc.scrollController.dispose();

    super.dispose();
  }

  TabController controller;

  int itemCount;
  IndexedWidgetBuilder tabBuilder;
  IndexedWidgetBuilder pageBuilder;
  Widget stub;
  ValueChanged<int> onPositionChange;
  ValueChanged<double> onScroll;
  int initPosition;
  bool isFallow;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    //  final followService = Provider.of<FollowService>(context);

    void messageToWhatsapp(String number) async {
      await launch("https://wa.me/56$number?text=Hola!");
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          body: (loadingok)
              ? AnimatedBuilder(
                  animation: _bloc,
                  builder: (_, __) => CustomScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      controller: _bloc.scrollController2,
                      slivers: [
                        SliverAppBar(
                          leading: Container(),
                          actions: [
                            Container(),
                          ],
                          leadingWidth: 0,
                          backgroundColor: Color(colorVibrant),
                          title: Container(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: currentTheme.cardColor),
                                    child: Material(
                                      color: currentTheme.cardColor,
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
                                            color: currentTheme.primaryColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          width: size.width,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: currentTheme.cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: currentTheme
                                                            .cardColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100)),
                                                    padding: EdgeInsets.only(
                                                        top: 20, left: 20),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      inputFormatters: [
                                                        new LengthLimitingTextInputFormatter(
                                                            20),
                                                      ],
                                                      focusNode: _focusNode,

                                                      controller: textCtrl,
                                                      //  keyboardType: TextInputType.emailAddress,

                                                      maxLines: 1,

                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: currentTheme
                                                                  .cardColor),
                                                        ),
                                                        border:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                        // icon: Icon(Icons.perm_identity),
                                                        //  fillColor: currentTheme.accentColor,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: currentTheme
                                                                  .cardColor,
                                                              width: 0.0),
                                                        ),
                                                        hintText:
                                                            'Buscar productos',
                                                        //  labelText: 'Buscar ...',
                                                        //counterText: snapshot.data,
                                                        //  errorText: snapshot.error
                                                      ),
                                                      onChanged: (value) => _bloc
                                                          .sharedProductOnStoreCurrent(
                                                              value),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: -2,
                                                  child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            ShapeDecoration(
                                                          shadows: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.50),
                                                              offset: Offset(
                                                                  3.0, 3.0),
                                                              blurRadius: 2.0,
                                                              spreadRadius: 1.0,
                                                            )
                                                          ],
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0)),
                                                          gradient: LinearGradient(
                                                              colors: gradients,
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight),
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
                                  if (phoneStore != "")
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: currentTheme.cardColor),
                                      child: Material(
                                        color: currentTheme.cardColor,
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          splashColor: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          radius: 30,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            messageToWhatsapp(
                                                store.user.phone.toString());
                                          },
                                          highlightColor: Colors.grey,
                                          child: Container(
                                              alignment: Alignment.center,
                                              width: 34,
                                              height: 34,
                                              child: FaIcon(
                                                FontAwesomeIcons.whatsapp,
                                                color:
                                                    currentTheme.primaryColor,
                                                size: 25,
                                              )),
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                          stretch: true,
                          expandedHeight: size.height / 3.2,
                          collapsedHeight: 100,
                          floating: false,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            title: FadeInUp(
                                duration: Duration(milliseconds: 300),
                                child: SABT(
                                    child: Text(
                                  store.name,
                                  style: TextStyle(color: Colors.white),
                                ))),
                            stretchModes: [
                              StretchMode.zoomBackground,
                              StretchMode.fadeTitle,
                              // StretchMode.blurBackground
                            ],
                            background: GestureDetector(
                              onTap: () => {_bloc.onTapStore()},
                              child: Material(
                                type: MaterialType.transparency,
                                child: ClipRRect(
                                  /*  borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ), */
                                  child: StoreProfileData(
                                    storeAuth: store,
                                    size: size,
                                    isAuth: false,
                                  ),
                                ),
                              ),
                            ),
                            centerTitle: true,
                          ),
                        ),
                        /*  SliverPersistentHeader(
                pinned: true,
                delegate: _AppBarStore(
                    store: widget.store,
                    minExtended: kToolbarHeight,
                    maxExtended: size.height * 0.35,
                    size: size,
                    bloc: _bloc),
              ), */

                        SliverToBoxAdapter(
                          child: Body(
                            size: size,
                            store: store,
                            isAuth: false,
                          ),
                        ),
                        /*  SliverPersistentHeader(
                delegate: _ProfileStoreHeader(
                    bloc: _bloc,
                    animationController: _animationController,
                    isAuthUser: widget.isAuthUser,
                    store: widget.store),
                pinned: false,
              ), */

                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverAppBarDelegate(
                              minHeight: 50,
                              maxHeight: 50,
                              child: Container(
                                color: currentTheme.scaffoldBackgroundColor,
                                alignment: Alignment.centerLeft,
                                child: (!loading)
                                    ? TabBar(
                                        onTap: _bloc.onCategorySelected,
                                        controller: _bloc.tabController,
                                        indicatorWeight: 0.1,
                                        isScrollable: true,
                                        tabs: _bloc.tabs
                                            .map((e) =>
                                                (e.category.products.length > 0)
                                                    ? FadeInLeft(
                                                        child: _TabWidget(
                                                          tabCategory: e,
                                                        ),
                                                      )
                                                    : Container())
                                            .toList(),
                                      )
                                    : Container(),
                              )),
                        ),
                        SliverToBoxAdapter(
                          child: (!loading)
                              ? Container(
                                  child: ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    controller: _bloc.scrollController,
                                    itemCount: _bloc.items.length,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom:
                                            (_bloc.items.length > 4) ? 0 : 200),
                                    itemBuilder: (context, index) {
                                      final item = _bloc.items[index];
                                      if (item.isCategory) {
                                        return Container(
                                            child: ProfileStoreCategoryItem(
                                                item.category));
                                      } else {
                                        return _ProfileStoreProductItem(
                                            item.product,
                                            item.product.category,
                                            _bloc);
                                      }
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 200.0),
                                  child: buildLoadingWidget(context),
                                ),
                        ),
                      ]),
                )
              : Center(
                  child: Container(
                  child: buildLoadingWidget(context),
                ))),
    );
  }
}

SliverPersistentHeader makeHeaderCustom(BuildContext context, String title) {
  //final catalogo = new ProfileStoreCategory();
  final currentTheme = Provider.of<ThemeChanger>(context);
  final size = MediaQuery.of(context).size;

  final storeBLoC = Provider.of<StoreBLoC>(context);

  final authBLoC = Provider.of<AuthenticationBLoC>(context);

  return SliverPersistentHeader(
      pinned: true,
      floating: false,
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
                                    padding: EdgeInsets.only(top: 20, left: 10),
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
                                        //  fillColor: currentTheme.accentColor,
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
                                          .searchStoresOrProductsByQuery(value,
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
                                                  BorderRadius.circular(30.0)),
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

SliverPersistentHeader makeSpaceTitle() {
  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 10.0, maxHeight: 10.0, child: Container()));
}

class _TabWidget extends StatelessWidget {
  const _TabWidget({
    this.tabCategory,
  });
  final TabCategory tabCategory;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final selected = tabCategory.selected;

    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        color: currentTheme.cardColor,
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name.capitalize(),
            style: TextStyle(
              color: (selected) ? currentTheme.primaryColor : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

void _listenNotification(context) {
  final notifiModel = Provider.of<NotificationModel>(context, listen: false);
  int number = notifiModel.numberNotifiBell;
  number++;
  notifiModel.numberNotifiBell = number;
}

String heroTag = '';

class _ProfileStoreProductItem extends StatefulWidget {
  const _ProfileStoreProductItem(this.product, this.category, this.bloc);

  final String category;

  final ProfileStoreProduct product;

  final TabsViewScrollBLoC bloc;

  @override
  __ProfileStoreProductItemState createState() =>
      __ProfileStoreProductItemState();
}

class __ProfileStoreProductItemState extends State<_ProfileStoreProductItem> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final groceryBloc = Provider.of<GroceryStoreBLoC>(context);
    final size = MediaQuery.of(context).size;
    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price);

    int quantityInitial = 1;

    var productAdd = groceryBloc.cart.firstWhere(
        (item) => item.product.id == widget.product.id,
        orElse: () => null);

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        FocusScope.of(context).requestFocus(new FocusNode());

        groceryBloc.changeToDetails();
        widget.bloc.onTapProducts();

        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    category: widget.category,
                    isAuthUser: false,
                    product: widget.product,
                    bloc: widget.bloc,
                    onProductAdded: (int quantity) {
                      groceryBloc.addProduct(widget.product, quantity);
                      HapticFeedback.lightImpact();
                      _listenNotification(context);
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
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: currentTheme.cardColor,
            child: Row(
              children: [
                Container(
                  child: Hero(
                      tag:
                          'list_${widget.product.images[0].url + widget.product.name + '0'}' +
                              heroTag,
                      child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                              width: size.width / 4,
                              height: size.height / 4,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: cachedContainNetworkImage(
                                    widget.product.images[0].url),
                              )))),
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
                          widget.product.name.capitalize(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: size.width / 2,
                        child: Text(
                          widget.product.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '\$$priceformat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          if (productAdd == null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, bottom: 0),
                              child: SizedBox(
                                  height: size.height / 25,
                                  width: size.width / 4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();

                                      groceryBloc.changeToNormal();

                                      groceryBloc.addProduct(
                                          widget.product, quantityInitial);

                                      _listenNotification(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5.0,
                                      fixedSize: Size.fromWidth(size.width),
                                      primary: currentTheme.primaryColor,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    child: Text('Agregar',
                                        style: TextStyle(fontSize: 15)),
                                  )),
                            ),
                          if (productAdd != null)
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  (productAdd.quantity == 1)
                                      ? Container(
                                          padding: EdgeInsets.only(right: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              groceryBloc
                                                  .deleteProduct(productAdd);
                                            },
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(right: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              if (productAdd.quantity > 0) {
                                                setState(() {
                                                  productAdd.quantity--;
                                                });
                                              }
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Text(
                                      productAdd.quantity.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        productAdd.quantity++;
                                      });

                                      Timer(new Duration(milliseconds: 100),
                                          () {
                                        groceryBloc.changeToNormal();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )
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

final textCtrl = TextEditingController();

FocusNode _focusNode;

const List<Color> gradients = [
  Color(0xffEC4E56),
  Color(0xffF78C39),
  Color(0xffFEB42C),
];

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}

class ButtonFollow extends StatefulWidget {
  const ButtonFollow({Key key, this.left, this.store}) : super(key: key);

  final Store store;

  final double left;

  @override
  _ButtonFollowState createState() => _ButtonFollowState();
}

final prefs = new AuthUserPreferences();

class _ButtonFollowState extends State<ButtonFollow> {
  void changeFollow() async {
    final followService = Provider.of<FollowService>(context, listen: false);

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    final storeService = Provider.of<StoreBLoC>(context, listen: false);

    final resp = await followService.followStore(
        widget.store.user.uid, authService.storeAuth.user.uid);

    if (resp.ok) {
      setState(() {
        widget.store.isFollowing = resp.follow.isFollowing;
      });

      int followed = prefs.followed;

      if (resp.follow.isFollowing) {
        followService.followers++;
        storeService.addFallowed();

        int newfollowed = followed + 1;

        prefs.followed = newfollowed;

        storeService.changeToFollowed();
      } else {
        followService.followers--;

        storeService.removeFallowed();

        int newfollowed = followed - 1;
        storeService.changeToFollowed();

        prefs.followed = newfollowed;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationBLoC>(context);
    //  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Row(
      children: [
        FadeIn(
          child: Container(
              width: 100,
              height: 35,
              child: elevatedButtonCustom(
                  context: context,
                  title: (!widget.store.isFollowing) ? 'Seguir' : 'Siguiendo',
                  onPress: () {
                    HapticFeedback.lightImpact();
                    if (authService.storeAuth.user.uid == '0') {
                      authService.redirect = 'follow';
                      Navigator.push(context, loginRoute());
                    } else
                      this.changeFollow();
                  },
                  isEdit: true,
                  isDelete: false,
                  isAccent: (!widget.store.isFollowing))),
        ),
      ],
    );
  }
}

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search,
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
            SizedBox(width: 10),
            Container(
                // margin: EdgeInsets.only(top: 0, left: 0),
                child: Text('Search product ...',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _CustomBottomSliver extends StatefulWidget {
  const _CustomBottomSliver(
      {Key key,
      @required this.size,
      @required this.percent,
      @required this.store})
      : super(key: key);

  final Size size;
  final double percent;
  final Store store;

  @override
  __CustomBottomSliverState createState() => __CustomBottomSliverState();
}

class __CustomBottomSliverState extends State<_CustomBottomSliver>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    // Properly dispose the controller. This is important!
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percent > 0.6) _animationController.forward();
    if (widget.percent < 0.6) _animationController.reset();
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    return Container(
      height: widget.size.height * 0.12,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: CutRectangle(
                _animationController.view,
                currentTheme.scaffoldBackgroundColor,
                Color(int.parse(widget.store.colorVibrant))),
          ),
          DataCutRectangle(
            size: widget.size,
            percent: widget.percent,
            store: widget.store,
          )
        ],
      ),
    );
  }
}
