import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/store_principal/store_Service.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/vinyl_disc/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class StorePrincipalHome extends StatefulWidget {
  @override
  _StorePrincipalHomeState createState() => _StorePrincipalHomeState();
}

class _StorePrincipalHomeState extends State<StorePrincipalHome> {
  ScrollController _scrollController;
  bool _isVisible = true;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 150;
  }

  ValueNotifier<bool> notifierBottomBarVisible = ValueNotifier(true);

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    // final bloc = CustomProvider.storeBlocIn(context);
    this.bottomControll();
    //  _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  bottomControll() {
    _isVisible = true;

    final bloc = Provider.of<StoreBLoC>(context, listen: false);
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    // final bloc = StoreBLoC();

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

  @override
  Widget build(BuildContext context) {
    StoreService _selected = storeService.last;

    final bloc = Provider.of<StoreBLoC>(context);

    return Scaffold(
        backgroundColor: Colors.black,
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            _snapAppbar();

            return false;
          },
          child: SafeArea(
              child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
                leading: GestureDetector(
                  onTap: () {
                    {
                      Navigator.push(context, profileAuthRoute(true));
                    }
                  },
                  child: Hero(
                    tag: 'user_auth_avatar',
                    child: Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        width: 100,
                        height: 100,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage(
                                    currentProfile.imageAvatar)))),
                  ),
                ),
                actions: [
                  GestureDetector(
                      onTap: () {
                        {}
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 15, right: 15),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            top: 32,
                            left: 22,
                            child: BounceInDown(
                              from: 5,
                              animate: (1 > 0) ? true : false,
                              child: Bounce(
                                delay: Duration(seconds: 2),
                                from: 10,
                                controller: (controller) =>
                                    Provider.of<NotificationModel>(context)
                                        .bounceControllerBell = controller,
                                child:
                                    (groceryStoreBloc.totalCartElements() > 0)
                                        ? Container(
                                            child: Text(
                                              groceryStoreBloc
                                                  .totalCartElements()
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            alignment: Alignment.center,
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                          )
                                        : Container(),
                              ),
                            ),
                          ),
                        ],
                      )),
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
                              key: Key(_selected.name),
                              storeService: _selected,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  centerTitle: true,
                  title: Container(child: _MyTextField(_showTitle)),
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
                              color: Colors.black,
                              child: Container(
                                color: Colors.black,
                                child: StoreServicesList(
                                  onPhotoSelected: (item) => {
                                    _changeService(bloc, item.id),
                                    setState(() {
                                      _selected = item;
                                    })
                                  },
                                ),
                              ))),
                    )
                  ],
                ),
              ),

              /* SliverAppBar(
                      backgroundColor: Colors.black,
                      automaticallyImplyLeading: false,
                      expandedHeight: 60.0,
                      collapsedHeight: 60.0,
                      pinned: true,
                      actionsIconTheme: IconThemeData(opacity: 0.0),
                      title: Container(
                          alignment: Alignment.centerLeft,
                          child: FadeIn(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10),
                              child: Text(
                                _selected.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ))), */

              /*  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.black,
                    stretch: true,
                    //stretchTriggerOffset: 100.0,
                    expandedHeight: 150.0,
                    collapsedHeight: 70,
                    // floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      /*  stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.fadeTitle,
                        // StretchMode.blurBackground
                      ], */
                      background: Material(
                          type: MaterialType.transparency,
                          child: Container(
                              color: Colors.black,
                              child: Container(
                                color: Colors.black,
                                child: StoreServicesList(
                                  onPhotoSelected: (item) => {
                                    _changeService(bloc, item.id),
                                    setState(() {
                                      _selected = item;
                                    })
                                  },
                                ),
                              ))),
                      //centerTitle: true,
                    ),
                  ), */

              /*  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: SliverCustomHeaderDelegate(
                        minHeight: 150,
                        maxHeight: 150,
                        child: Container(
                            color: Colors.black,
                            child: Container(
                              color: Colors.black,
                              child: StoreServicesList(
                                onPhotoSelected: (item) => {
                                  _changeService(bloc, item.id),
                                  setState(() {
                                    _selected = item;
                                  })
                                },
                              ),
                            ))),
                  ), */

              // makeHeaderPrincipal(context),
              makeHeaderTitle(context, _selected.name),
              makeListRecomendations(),
            ],
          )),
        ));
  }
}

SliverPersistentHeader makeHeaderPrincipal(context) {
  final size = MediaQuery.of(context).size;

  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 120,
          maxHeight: size.height / 1.55,
          child: Container(
              color: Colors.black,
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
  return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 45,
          maxHeight: 45,
          child: FadeIn(
            child: Container(
              color: Colors.black,
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
/*     final isRest = bloc.storeState != StoreState.restaurant ? true : false;

    print(isRest); */
    final bloc = Provider.of<StoreBLoC>(context);

    return SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bloc.storesListState.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final store = bloc.storesListState[index];

            return Stack(
              children: [
                StoreCard(
                  store: store,
                ),
              ],
            );
          }),
    );
  }
}

class HeaderCustom extends StatefulWidget {
  @override
  _HeaderCustomState createState() => _HeaderCustomState();
}

StoreService selected = storeService.last;

class _HeaderCustomState extends State<HeaderCustom> {
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
  if (id == 1) {
    bloc.changeToRestaurant();
  } else if (id == 2) {
    bloc.changeToMarket();
  } else if (id == 3) {
    bloc.changeToLiqueur();
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

class FakeReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 90,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                storeService.first.backImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      'MON 11 DIC 13 20',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Nice days in a good place',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Fly ticket',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  StoreCard({this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final id = store.id;
    return GestureDetector(
      onTap: () {
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
                    child: Image.asset(
                      'assets/travel_photos/rest_logo.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        '${store.name}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Nice days in a good place',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '15 - 30 min',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
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
  final StoreService storeService;

  const StoreServiceDetails({Key key, this.storeService}) : super(key: key);

  @override
  _StoreServiceDetailsState createState() => _StoreServiceDetailsState();
}

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
            ],
          );
        });
  }
}

const List<Color> gradients = [
  Color(0xffEC4E56),
  Color(0xffF78C39),
  Color(0xffFEB42C),
];

class _MyTextField extends StatelessWidget {
  _MyTextField(this.showTitle);
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
                child: Container(
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
  final ValueChanged<StoreService> onPhotoSelected;

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
    return AnimatedList(
      key: _animatedListKey,
      physics: PageScrollPhysics(),
      controller: _pageController,
      itemBuilder: (context, index, animation) {
        final travelPhotoItem = storeService[index];
        final percent = page - page.floor();
        final factor = percent > 0.5 ? (1 - percent) : percent;
        return InkWell(
          onTap: () {
            storeService.insert(storeService.length, travelPhotoItem);
            _animatedListKey.currentState.insertItem(storeService.length - 1);
            final itemToDelete = travelPhotoItem;
            widget.onPhotoSelected(travelPhotoItem);
            storeService.removeAt(index);
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
          child: Transform(
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
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      initialItemCount: storeService.length,
    );
  }
}

class TravelPhotoListItem extends StatelessWidget {
  final StoreService travelPhoto;

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
