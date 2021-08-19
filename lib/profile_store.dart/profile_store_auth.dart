import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/onboarding/pages/menu_drawer.dart';
import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:australti_ecommerce_app/profile_store.dart/product_detail.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../global/extension.dart';

const _blueColor = Color(0xFF00649FE);
const _textHighColor = Color(0xFF241E1E);
const _textColor = Color(0xFF5C5657);

class ProfileStoreAuth extends StatefulWidget {
  ProfileStoreAuth({this.isAuthUser = false});

  final bool isAuthUser;

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStoreAuth>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    if (!productsBloc.initialOK) productsBloc.init(this, context);

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
    final productsBloc = Provider.of<TabsViewScrollBLoC>(context);
    final authBloc = Provider.of<AuthenticationBLoC>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          endDrawer: PrincipalMenu(),
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          body: SafeArea(
              child: AnimatedBuilder(
            animation: productsBloc,
            builder: (_, __) => NestedScrollView(
                controller: productsBloc.scrollController2,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverPersistentHeader(
                      delegate: _ProfileStoreHeader(
                          animationController: _animationController,
                          isAuthUser: widget.isAuthUser,
                          store: authBloc.storeAuth),
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
                              onTap: productsBloc.onCategorySelected,
                              controller: productsBloc.tabController,
                              indicatorWeight: 0.1,
                              isScrollable: true,
                              tabs: productsBloc.tabs
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
                    controller: productsBloc.scrollController,
                    itemCount: productsBloc.items.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final item = productsBloc.items[index];
                      if (item.isCategory) {
                        return Container(
                            child: ProfileStoreCategoryItem(item.category));
                      } else {
                        return _ProfileStoreProductItem(
                            item.product, item.product.category);
                      }
                    },
                  ),
                )),
          ))),
    );
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

class ProfileStoreCategoryItem extends StatelessWidget {
  const ProfileStoreCategoryItem(this.category);
  final ProfileStoreCategory category;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category.name.capitalize(),
        style: TextStyle(
          color: (!currentTheme.customTheme) ? Colors.black54 : Colors.white54,
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
  const _ProfileStoreProductItem(this.product, this.category);

  final String category;

  final ProfileStoreProduct product;
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final bloc = Provider.of<GroceryStoreBLoC>(context);

    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(product.price);

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        HapticFeedback.lightImpact();
        bloc.changeToDetails();
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    category: category,
                    isAuthUser: true,
                    product: product,
                    onProductAdded: (int quantity) {
                      bloc.addProduct(product, quantity);

                      _listenNotification(context);
                    }),
              );
            },
          ),
        );
        bloc.changeToNormal();
      },
      child: Container(
        height: size.height / 5.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: currentTheme.currentTheme.cardColor,
            child: Row(
              children: [
                Container(
                  child: Hero(
                      tag: 'list_${product.images[0].url + product.name + '0'}',
                      child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                              width: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
}

final textCtrl = TextEditingController();

FocusNode _focusNode;

const List<Color> gradients = [
  Color(0xffEC4E56),
  Color(0xffF78C39),
  Color(0xffFEB42C),
];

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
      {this.animationController, this.isAuthUser, @required this.store});
  final AnimationController animationController;

  final bool isAuthUser;
  final Store store;

  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final productsBloc = Provider.of<TabsViewScrollBLoC>(context);

    final authBloc = Provider.of<AuthenticationBLoC>(context);

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

    final username = authBloc.storeAuth.user.username;

    return GestureDetector(
      onTap: () => {
        productsBloc.snapAppbar(),
      },
      child: Container(
        color: currentTheme.currentTheme.scaffoldBackgroundColor,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 18.0,
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.chevronLeft,
                    color: currentTheme.currentTheme.primaryColor),
                iconSize: 25,
                onPressed: () => {
                  HapticFeedback.lightImpact(),
                  if (authBloc.storeAuth.user.first)
                    {
                      Navigator.push(context, principalHomeRoute()),
                      Provider.of<MenuModel>(context, listen: false)
                          .currentPage = 0,
                    }
                  else
                    {
                      Navigator.pop(context),
                    }
                },
                color: Colors.blueAccent,
              ),
            ),
            if (productsBloc.items.length > 0)
              Positioned(
                top: 20,
                left: 50,
                width: size.width / 1.4,
                height: 40,
                child: GestureDetector(
                  onTap: () => {
                    FocusScope.of(context).requestFocus(_focusNode),
                  },
                  child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          color: currentTheme.currentTheme.cardColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: size.width,
                              padding: EdgeInsets.only(top: 20, left: 20),
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(20),
                                ],
                                focusNode: _focusNode,
                                controller: textCtrl,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: currentTheme
                                            .currentTheme.cardColor),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white54),
                                  // icon: Icon(Icons.perm_identity),
                                  //  fillColor: currentTheme.accentColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            currentTheme.currentTheme.cardColor,
                                        width: 0.0),
                                  ),
                                  hintText: 'Buscar productos ...',
                                ),
                                onChanged: (value) => productsBloc
                                    .sharedProductOnStoreCurrent(value),
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
                                        color: Colors.black.withOpacity(0.50),
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
                      )),
                ),
              ),
            Positioned(
              top: (_bottomMarginName * (1 - percent))
                  .clamp(75.0, _bottomMarginName),
              left: leftTextMargin,
              height: _maxImageSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width:
                        (percent <= 0.9) ? size.width / 2.1 : size.width / 2.8,
                    child: Text(
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
                  ),
                  AnimatedContainer(
                    width: (percent <= 0.9) ? size.width / 1.3 : size.width / 3,
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      '@$username',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: subTitleSize,
                        letterSpacing: -0.5,
                        color: (currentTheme.customTheme)
                            ? Colors.white54
                            : _textColor,
                      ),
                    ),
                  ),
                  if (authBloc.storeAuth.followers > 0)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      child: Text(
                        '${authBloc.storeAuth.followers}  Seguidores',
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
            ButtonEditProfile(percent: percent, left: leftTextMargin),

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
                      ? (authBloc.redirect != 'header')
                          ? 'user_auth_avatar'
                          : 'user_auth_avatar-header'
                      : 'user_auth_avatar_list',
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: (authBloc.storeAuth.imageAvatar != "")
                        ? Container(
                            height: currentImageSize,
                            width: currentImageSize,
                            child: cachedNetworkImage(
                              authBloc.storeAuth.imageAvatar,
                            ),
                          )
                        : Image.asset(currentProfile.imageAvatar),
                  ),
                )),
            /* Positioned(
              right: 40,
              top: 18.0,
              child: IconButton(
                icon: Icon(Icons.share,
                    color: currentTheme.currentTheme.primaryColor),
                iconSize: 25,
                onPressed: () => Navigator.pop(context),
                color: Colors.blueAccent,
              ),
            ), */
            Positioned(
              right: 0,
              top: 18.0,
              child: IconButton(
                icon: Icon(Icons.menu,
                    color: currentTheme.currentTheme.primaryColor),
                iconSize: 30,
                onPressed: () => {Scaffold.of(context).openEndDrawer()},
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
  const ButtonEditProfile({Key key, @required this.percent, this.left})
      : super(key: key);

  final num percent;

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
                  child: elevatedButtonCustom(
                      context: context,
                      title: 'Editar perfil',
                      onPress: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(context, profileEditRoute());
                      },
                      isEdit: true,
                      isDelete: false),
                ))
            : Positioned(
                top: 90,
                right: 20,
                child: Container(
                  width: 100,
                  height: 35,
                  child: elevatedButtonCustom(
                      context: context,
                      title: 'Editar',
                      onPress: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(context, profileEditRoute());
                      },
                      isEdit: true,
                      isDelete: false),
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
