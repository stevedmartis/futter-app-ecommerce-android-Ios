import 'package:animate_do/animate_do.dart';
import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/bloc_globals/notitification.dart';
import 'package:freeily/grocery_store/grocery_store_bloc.dart';

import 'package:freeily/profile_store.dart/profile_store_user.dart';
import 'package:freeily/routes/routes.dart';
import 'package:freeily/services/follow_service.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/circular_progress.dart';
import 'package:freeily/widgets/cover_photo.dart';
import 'package:freeily/widgets/elevated_button_style.dart';
import 'package:freeily/widgets/image_cached.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freeily/profile_store.dart/product_detail.dart';
import 'package:freeily/store_product_concept/store_product_bloc.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';
import 'package:freeily/widgets/sliver_card_animation/background_sliver.dart';
import 'package:freeily/widgets/sliver_card_animation/body_sliver.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global/extension.dart';

const _blueColor = Color(0xFF00649FE);

const _textColor = Color(0xFF5C5657);

class ProfileStoreAuth extends StatefulWidget {
  ProfileStoreAuth({this.isAuthUser = false});

  final bool isAuthUser;

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStoreAuth>
    with TickerProviderStateMixin {
  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    if (!productsBloc.initialOK) productsBloc.init(this, context);

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
    final _bloc = Provider.of<TabsViewScrollBLoC>(context);
    final authBloc = Provider.of<AuthenticationBLoC>(context);
    final size = MediaQuery.of(context).size;
    final followService = Provider.of<FollowService>(context);
    void messageToWhatsapp(String number) async {
      await launch("https://wa.me/56$number?text=Hola!");
    }

    final storeAuth = authBloc.storeAuth;
    final phoneStore = storeAuth.user.phone.toString();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          body: SafeArea(
              child: AnimatedBuilder(
            animation: _bloc,
            builder: (_, __) => CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _bloc.scrollController2,
                slivers: [
                  SliverAppBar(
                    leading: Container(),
                    actions: [
                      if (phoneStore != "")
                        Container(
                          child: IconButton(
                            icon: FaIcon(FontAwesomeIcons.whatsapp,
                                color: currentTheme.primaryColor),
                            iconSize: 30,
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              messageToWhatsapp(
                                  storeAuth.user.phone.toString());
                            },
                            color: Colors.blueAccent,
                          ),
                        ),
                    ],
                    leadingWidth: 0,
                    backgroundColor: Color(int.parse(storeAuth.colorVibrant)),
                    title: Container(
                        color: Color(int.parse(storeAuth.colorVibrant)),
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
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: currentTheme.cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
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
                                                autofocus: true,
                                                controller: textCtrl,
                                                //  keyboardType: TextInputType.emailAddress,

                                                maxLines: 1,

                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: currentTheme
                                                            .cardColor),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  labelStyle: TextStyle(
                                                      color: Colors.white54),
                                                  // icon: Icon(Icons.perm_identity),
                                                  //  fillColor: currentTheme.accentColor,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: currentTheme
                                                            .cardColor,
                                                        width: 0.0),
                                                  ),
                                                  hintText: '',
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
                                                duration:
                                                    Duration(milliseconds: 200),
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: ShapeDecoration(
                                                    shadows: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.50),
                                                        offset:
                                                            Offset(3.0, 3.0),
                                                        blurRadius: 2.0,
                                                        spreadRadius: 1.0,
                                                      )
                                                    ],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0)),
                                                    gradient: LinearGradient(
                                                        colors: gradients,
                                                        begin:
                                                            Alignment.topLeft,
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
                          ],
                        )),
                    stretch: true,
                    expandedHeight: size.height / 3.2,
                    collapsedHeight: 100,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: SABT(child: Text(storeAuth.name)),
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
                            child: Stack(
                              children: [
                                BackgroundSliver(
                                    colorVibrant: storeAuth.colorVibrant),

                                Positioned(
                                  bottom: size.height * 0.03,
                                  left: size.width / 20,
                                  child: Hero(
                                      tag:
                                          'user_auth_avatar_list_${storeAuth.imageAvatar}',
                                      child: CoverPhoto(
                                          imageAvatar: storeAuth.imageAvatar,
                                          size: size)),
                                ),

                                Positioned(
                                    bottom: size.height * 0.17,
                                    left: size.width / 2.8,
                                    child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      opacity: 1.0,
                                      child: Container(
                                        width: size.width / 1.5,
                                        child: Text(
                                          storeAuth.name.capitalize(),
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    )),

                                Positioned(
                                    bottom: size.height * 0.14,
                                    left: size.width / 2.8,
                                    child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      opacity: 1.0,
                                      child: Container(
                                        width: size.width / 1.5,
                                        child: Text(
                                          '@${storeAuth.user.username}',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    )),

                                Positioned(
                                    bottom: size.height * 0.11,
                                    left: size.width / 2.8,
                                    child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      opacity: 1.0,
                                      child: Container(
                                        width: size.width / 1.5,
                                        child: Text(
                                          '${storeAuth.about}',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    )),

                                Positioned(
                                    bottom: size.height * 0.06,
                                    left: size.width / 2.8,
                                    child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: 1.0,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${storeAuth.timeDelivery} ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text(
                                              '${storeAuth.timeSelect}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ))),

                                if (followService.followers > 0)
                                  Positioned(
                                      bottom: size.height * 0.03,
                                      left: size.width / 2.8,
                                      child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          opacity: 1.0,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${followService.followers} ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'Seguidores',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.grey),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          )))

                                //FavoriteCircle(size: size, percent: percent)
                              ],
                            ),
                          ),
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Body(
                      size: size,
                      store: storeAuth,
                      isAuth: true,
                    ),
                  ),
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
                                  bottom: (_bloc.items.length > 4) ? 0 : 200),
                              itemBuilder: (context, index) {
                                final item = _bloc.items[index];
                                if (item.isCategory) {
                                  return Container(
                                      child: ProfileStoreCategoryItem(
                                          item.category));
                                } else {
                                  return _ProfileStoreProductItem(
                                      item.product, item.product.category);
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

    var type = product.images[0].url.split(".").last;

    bool isPng = (type.toLowerCase() == 'png');
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: (isPng) ? 10 : 0),
                              width: size.width / 4,
                              height: size.height / 4,
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
