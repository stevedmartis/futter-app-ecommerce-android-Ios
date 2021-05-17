import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:australti_ecommerce_app/profile_store.dart/product_detail.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

const _blueColor = Color(0xFF00649FE);
const _textHighColor = Color(0xFF241E1E);
const _textColor = Color(0xFF5C5657);

class ProfileStoreAuth extends StatefulWidget {
  ProfileStoreAuth({this.isAuthUser = false});

  final bool isAuthUser;

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

Store storeCurrent;

class _ProfileStoreState extends State<ProfileStoreAuth>
    with TickerProviderStateMixin {
  final _bloc = TabsViewScrollBLoC();

  AnimationController _animationController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeCurrent = authBloc.storeAuth;
    _bloc.init(this, storeCurrent.user.uid);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 1300),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    _animationController.dispose();

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

    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => NestedScrollView(
            controller: _bloc.scrollController2,
            headerSliverBuilder: (context, value) {
              return [
                SliverPersistentHeader(
                  delegate: _ProfileStoreHeader(
                      bloc: _bloc,
                      animationController: _animationController,
                      isAuthUser: widget.isAuthUser,
                      store: storeCurrent),
                  pinned: true,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                      minHeight: 70,
                      maxHeight: 70,
                      child: Container(
                        color: currentTheme.scaffoldBackgroundColor,
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          onTap: _bloc.onCategorySelected,
                          controller: _bloc.tabController,
                          indicatorWeight: 0.1,
                          isScrollable: true,
                          tabs: _bloc.tabs
                              .map((e) => _TabWidget(
                                    tabCategory: e,
                                  ))
                              .toList(),
                        ),
                      )),
                ),
              ];
            },

            // tab bar view
            body: Container(
              child: ListView.builder(
                controller: _bloc.scrollController,
                itemCount: _bloc.items.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final item = _bloc.items[index];
                  if (item.isCategory) {
                    return Container(
                        child: _ProfileStoreCategoryItem(item.category));
                  } else {
                    return (widget.isAuthUser)
                        ? _ProfileAuthStoreProductItem(
                            item.product, widget.isAuthUser)
                        : _ProfileStoreProductItem(item.product);
                  }
                },
              ),
            ),
          ),
        )));
  }
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
            tabCategory.category.name,
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

class _ProfileStoreCategoryItem extends StatelessWidget {
  const _ProfileStoreCategoryItem(this.category);
  final ProfileStoreCategory category;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category.name,
        style: TextStyle(
          color: (!currentTheme.customTheme) ? Colors.black54 : Colors.white54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileAuthStoreProductItem extends StatelessWidget {
  const _ProfileAuthStoreProductItem(this.product, this.isAuthUser);
  final ProfileStoreProduct product;
  final bool isAuthUser;
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
                      child: Image.asset(product.image)),
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
                              : _textColor,
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
                        '\$${product.price.toStringAsFixed(2)}',
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
}

void _listenNotification(context) {
  final notifiModel = Provider.of<NotificationModel>(context, listen: false);
  int number = notifiModel.numberNotifiBell;
  number++;
  notifiModel.numberNotifiBell = number;

  if (number >= 2) {
    final controller = notifiModel.bounceControllerBell;
    controller.forward(from: 0.0);
  }
}

class _ProfileStoreProductItem extends StatelessWidget {
  const _ProfileStoreProductItem(
    this.product,
  );

  final ProfileStoreProduct product;
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    //final bloc = Provider.of<GroceryStoreBLoC>(context);

    return GestureDetector(
      onTap: () async {
        groceryStoreBloc.changeToDetails();
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    product: product,
                    onProductAdded: (int quantity) {
                      groceryStoreBloc.addProduct(product, quantity);

                      _listenNotification(context);
                    }),
              );
            },
          ),
        );
        groceryStoreBloc.changeToNormal();
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
                      child: Image.asset(product.image)),
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
                              : _textColor,
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
                        '\$${product.price.toStringAsFixed(2)}',
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
}

const _maxHeaderExtent = 410.0;
const _minHeaderExtent = 150.0;

const _maxImageSize = 160.0;
const _minImageSize = 60.0;

const _leftMarginDisc = 100.0;

const _bottomMarginDisc = 150.0;

const _bottomMarginName = 270.0;

const _maxTitleSize = 25.0;
const _maxSubTitleSize = 18.0;

const _minTitleSize = 16.0;
const _minSubTitleSize = 12.0;

class _ProfileStoreHeader extends SliverPersistentHeaderDelegate {
  _ProfileStoreHeader(
      {this.bloc,
      this.animationController,
      this.isAuthUser,
      @required this.store});
  final AnimationController animationController;

  final TabsViewScrollBLoC bloc;

  final bool isAuthUser;
  final Store store;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final percent = 1 -
        ((maxExtent - shrinkOffset - minExtent) / (maxExtent - minExtent))
            .clamp(0.0, 1.0);
    final size = MediaQuery.of(context).size;
    final currentImageSize = (_maxImageSize * (1 - percent)).clamp(
      _minImageSize,
      _maxImageSize,
    );
    final titleSize = (_maxTitleSize * (1.75 - percent)).clamp(
      _minTitleSize,
      _maxTitleSize,
    );

    final subTitleSize = (_maxSubTitleSize * (1.80 - percent)).clamp(
      _minSubTitleSize,
      _maxSubTitleSize,
    );

    final maxMargin = size.width / 4;
    final textMovement = 5.0;
    final leftTextMargin = maxMargin + (textMovement * percent);

    final username = storeCurrent.user.username;

    return GestureDetector(
      onTap: () => bloc.snapAppbar(),
      child: Container(
        color: currentTheme.currentTheme.scaffoldBackgroundColor,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 18.0,
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.chevronLeft,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
                iconSize: 25,
                onPressed: () => Navigator.pop(context),
                color: Colors.blueAccent,
              ),
            ),
            Positioned(
              top: 20,
              left: 50,
              child: GestureDetector(
                  onTap: () => {},
                  child: Container(
                      width: size.width / 1.6,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              currentTheme.currentTheme.cardColor,
                              currentTheme.currentTheme.cardColor
                            ]),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: SearchContent())),
            ),
            Positioned(
              top: (_bottomMarginName * (1 - percent))
                  .clamp(75.0, _bottomMarginName),
              left: leftTextMargin,
              height: _maxImageSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    store.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                      letterSpacing: -0.5,
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : _textHighColor,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: subTitleSize,
                        letterSpacing: -0.5,
                        color: (currentTheme.customTheme)
                            ? Colors.white54
                            : _textColor,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      '300 followers',
                      style: TextStyle(
                        fontSize: subTitleSize,
                        letterSpacing: -0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (!isAuthUser)
                ? ButtonFollow(
                    percent: percent, bloc: bloc, left: leftTextMargin)
                : ButtonEditProfile(
                    percent: percent, bloc: bloc, left: leftTextMargin),

            /*  Positioned(
              bottom: 20.0,
              left: (_leftMarginDisc * (1 - percent))
                  .clamp(33.0, _leftMarginDisc),
              height: currentImageSize,
              child: Transform.rotate(
                angle: vector.radians(360 * -percent),
                child: Image.asset(
                  currentAlbum.imageDisc,
                ),
              ),
            ), */
            Positioned(
                bottom: (_bottomMarginDisc * (1 - percent))
                    .clamp(20.0, _bottomMarginDisc),
                left: (_leftMarginDisc * (1 - percent))
                    .clamp(20.0, _leftMarginDisc),
                height: currentImageSize,
                child: Hero(
                  tag: (isAuthUser)
                      ? 'user_auth_avatar'
                      : 'user_auth_avatar_list',
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: Image.asset(
                      currentProfile.imageAvatar,
                    ),
                  ),
                )),
            Positioned(
              right: 40,
              top: 18.0,
              child: IconButton(
                icon: Icon(Icons.share,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
                iconSize: 25,
                onPressed: () => Navigator.pop(context),
                color: Colors.blueAccent,
              ),
            ),
            Positioned(
              right: 0,
              top: 18.0,
              child: IconButton(
                icon: Icon(Icons.menu,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
                iconSize: 30,
                onPressed: () =>
                    //  Navigator.pushReplacement(context, createRouteProfile()),
                    Navigator.pop(context),
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class ButtonFollow extends StatefulWidget {
  const ButtonFollow(
      {Key key, @required this.percent, @required this.bloc, this.left})
      : super(key: key);

  final num percent;
  final TabsViewScrollBLoC bloc;
  final double left;

  @override
  _ButtonFollowState createState() => _ButtonFollowState();
}

class _ButtonFollowState extends State<ButtonFollow> {
  bool isFollow = false;
  void changeFollow() {
    isFollow = !isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.percent <= 0.9)
            ? Positioned(
                top: 350,
                left: widget.left,
                child: Container(
                  width: 180,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: (!isFollow) ? Colors.white : _blueColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          (isFollow) ? 'Follow' : 'Following',
                          style: TextStyle(
                              color: (isFollow) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                ))
            : Positioned(
                top: 90,
                right: 20,
                child: Container(
                  width: 100,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: (!isFollow) ? Colors.white : _blueColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          (isFollow) ? 'Follow' : 'Following',
                          style: TextStyle(
                              color: (isFollow) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                )),
      ],
    );
  }
}

class ButtonEditProfile extends StatefulWidget {
  const ButtonEditProfile(
      {Key key, @required this.percent, @required this.bloc, this.left})
      : super(key: key);

  final num percent;
  final TabsViewScrollBLoC bloc;
  final double left;

  @override
  _ButtonEditProfileState createState() => _ButtonEditProfileState();
}

class _ButtonEditProfileState extends State<ButtonEditProfile> {
  bool isFollow = false;
  void changeFollow() {
    isFollow = !isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.percent <= 0.9)
            ? Positioned(
                top: 350,
                left: widget.left,
                child: Container(
                  width: 180,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          'Editar perfil',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                ))
            : Positioned(
                top: 90,
                right: 20,
                child: Container(
                  width: 100,
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10),
                        child: Text(
                          'Editar',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      onPressed: () => {
                            setState(() {
                              this.changeFollow();
                            })
                          }),
                )),
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
