import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/grocery_Store.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/search_principal_page.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/responses/stores_list_principal_response.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/store_principal/store_Service.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:australti_ecommerce_app/widgets/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../global/extension.dart';
import 'package:australti_ecommerce_app/services/stores_Services.dart'
    as storeServices;

class StorePrincipalHome extends StatefulWidget {
  @override
  _StorePrincipalHomeState createState() => _StorePrincipalHomeState();
}

class _StorePrincipalHomeState extends State<StorePrincipalHome> {
  ScrollController _scrollController;
  bool _isVisible = true;
  final prefs = new AuthUserPreferences();

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 150;
  }

  bool isItems = false;

  ValueNotifier<bool> notifierBottomBarVisible = ValueNotifier(true);

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    final bloc = Provider.of<GroceryStoreBLoC>(context, listen: false);

    this.bottomControll();

    if (bloc.isReload) this.getCartSave();

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    bloc.changeReaload();
    final int followed = prefs.followed;

    storeBloc.selected = (followed > 0)
        ? storeBloc.servicesStores.first
        : storeBloc.servicesStores[1];

    super.initState();
  }

  bottomControll() {
    _isVisible = true;

    final bloc = Provider.of<StoreBLoC>(context, listen: false);
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    _scrollController.addListener(
      () {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
              bloc.bottomNavigation(false);
            });
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
              bloc.bottomNavigation(true);
            });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController?.dispose();
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final double snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _scrollController.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  getCartSave() async {
    final bloc = Provider.of<GroceryStoreBLoC>(context, listen: false);

    final stringCart = await getListCart('cart');

    final cart = cartProductsFromJson(stringCart);
    if (cart.length > 0) {
      bloc.cartSavetoCart(cart);
      bloc.totalCartElements();

      setState(() {
        isItems = bloc.totalCartElements() > 0 ? true : false;
      });
    }
  }

  pullToRefreshData() async {
    HapticFeedback.heavyImpact();
    if (storeAuth.user.uid != '0') {
      storesByLocationlistServices(storeAuth.city, storeAuth.user.uid);
    } else if (prefs.isLocationCurrent) {
      storesByLocationlistServices(
          prefs.addressSave['locality'], storeAuth.user.uid);
    } else {
      storeslistServices();
    }
  }

  void storesByLocationlistServices(String location, String uid) async {
    final storeService =
        Provider.of<storeServices.StoreService>(context, listen: false);

    final StoresListResponse resp =
        await storeService.getStoresLocationListServices(location, uid);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.storesListInitial = [];
      storeBloc.storesListInitial = resp.storeListServices;

      changeToCurrentService();
    }
  }

  changeToCurrentService() {
    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);
    if (storeBloc.selected.id == 1) storeBloc.changeToMarket();

    if (storeBloc.selected.id == 2) storeBloc.changeToRestaurant();

    if (storeBloc.selected.id == 3) storeBloc.changeToLiqueur();
  }

  void storeslistServices() async {
    final storeService =
        Provider.of<storeServices.StoreService>(context, listen: false);

    final StoresListResponse resp =
        await storeService.getStoresListServices(storeAuth.user.uid);

    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    if (resp.ok) {
      storeBloc.storesListInitial = resp.storeListServices;

      changeToCurrentService();
    }
  }

  Future<String> getListCart(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    return myPrefs.getString(key) ?? '[]';
  }

  Store storeAuth;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final authService = Provider.of<AuthenticationBLoC>(context);

    final bloc = Provider.of<StoreBLoC>(context);

    final groceryBloc = Provider.of<GroceryStoreBLoC>(context);

    isItems = groceryBloc.totalCartElements() > 0 ? true : false;
    storeAuth = authService.storeAuth;

    return SafeArea(
      child: Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (_) {
              _snapAppbar();

              return false;
            },
            child: RefreshIndicator(
              color: currentTheme.accentColor,
              onRefresh: () => pullToRefreshData(),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    leadingWidth: 60,
                    backgroundColor: currentTheme.scaffoldBackgroundColor,
                    leading: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            if (storeAuth.user.uid == '0') {
                              authService.redirect = 'profile';
                              Navigator.push(context, loginRoute(100));
                            } else {
                              authService.redirect = 'home';
                              Navigator.push(context, profileAuthRoute(true));
                            }
                          },
                          child: Container(
                              width: 100,
                              height: 100,
                              child: Hero(
                                tag: 'user_auth_avatar',
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                  child: (authService.storeAuth.imageAvatar !=
                                          "")
                                      ? Container(
                                          width: 150,
                                          height: 150,
                                          child: cachedNetworkImage(
                                            authService.storeAuth.imageAvatar,
                                          ),
                                        )
                                      : Image.asset(currentProfile.imageAvatar),
                                ),
                              )),
                        )),
                    actions: [
                      Swing(
                        animate: isItems,
                        delay: Duration(seconds: 1),
                        controller: (controller) =>
                            Provider.of<NotificationModel>(context)
                                .bounceControllerBell = controller,
                        child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              showMaterialCupertinoBottomSheet(
                                  context, 'hello', 'hello2');
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 10,
                                      top: (isItems) ? 12 : 15,
                                      right: 15),
                                  child: (isItems)
                                      ? Icon(
                                          Icons.shopping_bag,
                                          color: currentTheme.primaryColor,
                                          size: 40,
                                        )
                                      : Icon(
                                          Icons.shopping_bag_outlined,
                                          color: currentTheme.primaryColor,
                                          size: 35,
                                        ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 22, top: 30),
                                  child: (groceryBloc.totalCartElements() > 0)
                                      ? Container(
                                          child: Text(
                                            groceryBloc
                                                .totalCartElements()
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          alignment: Alignment.center,
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: Color(0xff32D73F),
                                              shape: BoxShape.circle),
                                        )
                                      : Container(),
                                ),
                              ],
                            )),
                      ),
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
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 700),
                                child: StoreServiceDetails(
                                  key: Key(bloc.selected.name),
                                  storeService: bloc.selected,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      centerTitle: true,
                      title: OpenContainer(
                          closedElevation: 5,
                          openElevation: 5,
                          closedColor: (_showTitle)
                              ? currentTheme.cardColor
                              : Colors.black.withOpacity(0.20),
                          openColor: (_showTitle)
                              ? currentTheme.cardColor
                              : Colors.black.withOpacity(0.20),
                          transitionType: ContainerTransitionType.fade,
                          openShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          openBuilder: (_, closeContainer) {
                            HapticFeedback.lightImpact();
                            return SearchPrincipalPage();
                          },
                          closedBuilder: (_, openContainer) {
                            return Container(child: MyTextField(_showTitle));
                          }),
                    ),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 150.0,
                    collapsedHeight: 150.0,
                    pinned: false,
                    actionsIconTheme: IconThemeData(opacity: 0.0),
                    flexibleSpace: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                  color: currentTheme.scaffoldBackgroundColor,
                                  child: StoreServicesList(
                                    onPhotoSelected: (item) => {
                                      _changeService(bloc, item.id),
                                      setState(() {
                                        HapticFeedback.lightImpact();
                                        bloc.selected = item;
                                      })
                                    },
                                  ))),
                        )
                      ],
                    ),
                  ),

                  // makeHeaderPrincipal(context),
                  makeHeaderTitle(context, bloc.selected.name),
                  makeListRecomendations(),
                ],
              ),
            ),
          )),
    );
  }
}

/* class NestedScrollModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: ScrollController(),
      physics: ScrollPhysics(parent: PageScrollPhysics()),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(height: 100, color: Colors.blue),
              ],
            ),
          ),
        ];
      },
      body: ListView.builder(
        controller: ModalScrollController.of(context),
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            color: index.isOdd ? Colors.green : Colors.orange,
          );
        },
        itemCount: 12,
      ),
    );
  }
} */

SliverPersistentHeader makeHeaderPrincipal(context) {
  final size = MediaQuery.of(context).size;

  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 120,
          maxHeight: size.height / 1.55,
          child: Container(
              color: currentTheme.scaffoldBackgroundColor,
              child: Container(color: Colors.black, child: HeaderCustom()))));
}

SliverPersistentHeader makeSpaceTitle() {
  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 10, maxHeight: 10, child: Container()));
}

SliverPersistentHeader makeHeaderTitle(context, String titleService) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 45,
          maxHeight: 45,
          child: FadeIn(
            child: Container(
              color: currentTheme.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Text(
                  titleService,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )));
}

SliverList makeListRecomendations() {
  return SliverList(
    delegate: SliverChildListDelegate([
      Container(child: StoresListByService()),
    ]),
  );
}

class StoresListByService extends StatelessWidget {
  const StoresListByService({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<StoreBLoC>(context);

    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bloc.storesListState.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final store = bloc.storesListState[index];

            return (bloc.storesListState.length) > 0
                ? Stack(
                    children: [
                      FadeIn(
                        child: StoreCard(
                          store: store,
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text('No hay tiendas cercanas a tu ubicación'),
                    ),
                  );
          }),
    );
  }
}

class HeaderCustom extends StatefulWidget {
  @override
  _HeaderCustomState createState() => _HeaderCustomState();
}

StoreServices selected;

class _HeaderCustomState extends State<HeaderCustom> {
  @override
  void initState() {
    final storeBloc = Provider.of<StoreBLoC>(context, listen: false);

    selected = storeBloc.servicesStores.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topCardHeight = 50;
    final horizontalListHeight = 160.0;
    final bloc = Provider.of<StoreBLoC>(context);

    return Stack(
      children: <Widget>[
        /*  Positioned(
          height: topCardHeight,
          left: 0,
          right: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: StoreServiceDetails(
              key: Key(_selected.name),
              storeService: _selected,
            ),
          ),
        ), */
        Positioned(
          left: 0,
          right: 0,
          top: topCardHeight - horizontalListHeight / 3,
          height: horizontalListHeight,
          child: StoreServicesList(
            onPhotoSelected: (item) => {
              _changeService(bloc, item.id),
              setState(() {
                HapticFeedback.lightImpact();
                selected = item;
              })
            },
          ),
        ),
      ],
    );
  }
}

void _changeService(StoreBLoC bloc, int id) {
  if (id == 2) {
    bloc.changeToRestaurant();
  } else if (id == 1) {
    bloc.changeToMarket();
  } else if (id == 3) {
    bloc.changeToLiqueur();
  } else if (id == 0) {
    bloc.changeToFollowed();
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverCustomHeaderDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class StoreCard extends StatelessWidget {
  StoreCard({this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final id = store.id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(context, profileCartRoute(store));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 90,
          child: Row(
            children: <Widget>[
              Hero(
                tag: 'user_auth_avatar_list_$id',
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: (store.imageAvatar != "")
                        ? Container(
                            child: cachedNetworkImage(
                              store.imageAvatar,
                            ),
                          )
                        : Image.asset(currentProfile.imageAvatar),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${store.name.capitalize()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Container(
                        child: Text(
                          '${store.about.capitalize()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: -0.5,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        /*  Icon(Icons.delivery_dining,
                            size: 20, color: Colors.white54),
                        SizedBox(width: 5.0), */
                        Container(
                          child: Text(
                            '${store.timeDelivery}',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ],
                    ),
                    if (store.percentOff != 0)
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                FaIcon(FontAwesomeIcons.certificate,
                                    size: 15, color: Colors.blueAccent),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 4,
                                    top: 4,
                                  ),
                                  child: FaIcon(FontAwesomeIcons.percent,
                                      size: 7,
                                      color:
                                          currentTheme.scaffoldBackgroundColor),
                                ),
                              ],
                            ),
                            SizedBox(width: 5.0),
                            Container(
                              child: Text(
                                'Hasta ${store.percentOff}% OFF',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreServiceDetails extends StatefulWidget {
  final StoreServices storeService;

  const StoreServiceDetails({Key key, this.storeService}) : super(key: key);

  @override
  _StoreServiceDetailsState createState() => _StoreServiceDetailsState();
}

List<Address> addresses = [];
Address nameAddress = Address(addressLine: '');

class _StoreServiceDetailsState extends State<StoreServiceDetails>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final _movement = -100.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//

// From coordinates

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final prefsAuthBloc = Provider.of<AuthenticationBLoC>(context).prefs;

    final _size = MediaQuery.of(context).size;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                left: _movement * _controller.value,
                right: _movement * (1 - _controller.value),
                child: Image.asset(
                  widget.storeService.backImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                left: _movement * _controller.value,
                right: _movement * (1 - _controller.value),
                child: Container(
                  child: Image.asset(
                    widget.storeService.frontImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 70,
                left: 10,
                right: 10,
                height: 40,
                child: FittedBox(
                  child: Text(
                    widget.storeService.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              (prefsAuthBloc.locationCurrent)
                  ? Positioned(
                      top: 20,
                      left: 10,
                      right: 10,
                      height: 40,
                      child: AnimatedOpacity(
                          opacity: (prefsAuthBloc.locationCurrent) ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.location_on,
                                    color: currentTheme.accentColor, size: 22),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: _size.width / 3,
                                  alignment: Alignment.center,
                                  child: Text(
                                    prefsAuthBloc.locationCurrent
                                        ? '${prefsAuthBloc.addressSave['featureName']}'
                                        : '...',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    //'${state.location.latitude}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white70),
                                  )),
                            ],
                          )))
                  : Positioned(
                      top: 20,
                      left: 10,
                      right: 10,
                      height: 40,
                      child: AnimatedOpacity(
                          opacity: (prefsAuthBloc.locationSearch) ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 200),
                          child: Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.location_on,
                                    color: currentTheme.accentColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: _size.width / 3,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        prefsAuthBloc.locationSearch
                                            ? '${prefsAuthBloc.addressSearchSave.mainText}'
                                            : '...',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        //'${state.location.latitude}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.white70),
                                      )),
                                ),
                              ],
                            ),
                          ))),
            ],
          );
        });
  }
}

Widget createLocation() {
  if (!myLocationBloc.state.isLocationCurrent)
    return Text(
      '...',
      //'${state.location.latitude}',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );

  return Text(
    '${myLocationBloc.state.isLocationCurrent}',
    //'${state.location.latitude}',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  );
}

const List<Color> gradients = [
  Color(0xffEC4E56),
  Color(0xffF78C39),
  Color(0xffFEB42C),
];

class MyTextField extends StatelessWidget {
  MyTextField(this.showTitle);
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);

    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: size.width / 1.6,
        height: 40,
        decoration: BoxDecoration(
            color: (showTitle)
                ? currentTheme.currentTheme.cardColor
                : Colors.black.withOpacity(0.40),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 0),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text('Buscar ...',
                      style: TextStyle(color: Colors.white, fontSize: 14))),
              Expanded(
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.50),
                            offset: Offset(3.0, 3.0),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          )
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
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
        ));
  }
}

class StoreServicesList extends StatefulWidget {
  const StoreServicesList({Key key, this.onPhotoSelected}) : super(key: key);
  final ValueChanged<StoreServices> onPhotoSelected;

  @override
  _StoreServicesListState createState() => _StoreServicesListState();
}

class _StoreServicesListState extends State<StoreServicesList> {
  final _animatedListKey = GlobalKey<AnimatedListState>();

  final _pageController = PageController();

  double page = 0.0;

  void _listenScroll() {
    setState(() {
      page = _pageController.page;
    });
  }

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeBloc = Provider.of<StoreBLoC>(context);

    return AnimatedList(
      key: _animatedListKey,
      physics: PageScrollPhysics(),
      controller: _pageController,
      itemBuilder: (context, index, animation) {
        final travelPhotoItem = storeBloc.servicesStores[index];
        final percent = page - page.floor();
        final factor = percent > 0.5 ? (1 - percent) : percent;
        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            storeBloc.servicesStores
                .insert(storeBloc.servicesStores.length, travelPhotoItem);
            _animatedListKey.currentState
                .insertItem(storeBloc.servicesStores.length - 1);
            final itemToDelete = travelPhotoItem;
            widget.onPhotoSelected(travelPhotoItem);
            storeBloc.servicesStores.removeAt(index);
            _animatedListKey.currentState.removeItem(
              index,
              (context, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  child: TravelPhotoListItem(
                    travelPhoto: itemToDelete,
                  ),
                ),
              ),
            );
          },
          child: (travelPhotoItem.stores > 0)
              ? Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(
                      vector.radians(
                        90 * factor,
                      ),
                    ),
                  child: TravelPhotoListItem(
                    travelPhoto: travelPhotoItem,
                  ),
                )
              : Container(),
        );
      },
      scrollDirection: Axis.horizontal,
      initialItemCount: storeBloc.servicesStores.length,
    );
  }
}

class TravelPhotoListItem extends StatelessWidget {
  final StoreServices travelPhoto;

  const TravelPhotoListItem({Key key, this.travelPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          width: 130,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.asset(
                    travelPhoto.backImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    )),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        travelPhoto.name,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${travelPhoto.stores} tiendas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
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
