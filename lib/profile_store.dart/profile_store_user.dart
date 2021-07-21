import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile_store_auth.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';

import 'package:australti_ecommerce_app/services/catalogo.dart';
import 'package:australti_ecommerce_app/services/follow_service.dart';

import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:australti_ecommerce_app/widgets/elevated_button_style.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:australti_ecommerce_app/profile_store.dart/product_detail.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../global/extension.dart';

import 'package:url_launcher/url_launcher.dart';

const _textHighColor = Color(0xFF241E1E);
const _textColor = Color(0xFF5C5657);

class ProfileStoreSelect extends StatefulWidget {
  ProfileStoreSelect({this.isAuthUser = false, this.store});

  final bool isAuthUser;

  final Store store;

  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStoreSelect>
    with TickerProviderStateMixin {
  final _bloc = TabsViewScrollBLoC();

  AnimationController _animationController;

  bool loading = false;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    final followService = Provider.of<FollowService>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      followService.followers = widget.store.followers;
    });

    categoriesStoreProducts();

    super.initState();
  }

  void categoriesStoreProducts() async {
    setState(() {
      loading = true;
    });

    final storeService =
        Provider.of<StoreCategoiesService>(context, listen: false);

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    final resp = await storeService.getAllCategoriesProducts(
        widget.store.user.uid, authService.storeAuth.user.uid);

    if (resp.ok) {
      _bloc.storeCategoriesProducts = resp.storeCategoriesProducts;

      _bloc.initStoreSelect(this, context, widget.store);

      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 1300),
      );

      setState(() {
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
    // _animationController.dispose();

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
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
                        store: widget.store),
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
                ];
              },

              // tab bar view
              body: (!loading)
                  ? Container(
                      child: ListView.builder(
                        controller: _bloc.scrollController,
                        itemCount: _bloc.items.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final item = _bloc.items[index];
                          if (item.isCategory) {
                            return Container(
                                child: ProfileStoreCategoryItem(item.category));
                          } else {
                            return _ProfileStoreProductItem(
                                item.product, item.product.category, _bloc);
                          }
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 200.0),
                      child: buildLoadingWidget(context),
                    ),
            ),
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
    final currentTheme = Provider.of<ThemeChanger>(context);

    final groceryBloc = Provider.of<GroceryStoreBLoC>(context);
    final size = MediaQuery.of(context).size;
    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price);

    /*  final itemInCart = groceryBloc.cart.firstWhere(
        (item) => item.product.id == widget.product.id,
        orElse: () => null); */

    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        HapticFeedback.lightImpact();
        groceryBloc.changeToDetails();

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
            color: currentTheme.currentTheme.cardColor,
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
                              width: 100,
                              height: size.height / 5,
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
                              color: (currentTheme.customTheme)
                                  ? Colors.white
                                  : _textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )

                          /*
                          Spacer(),
                          (itemInCart == null)
                              ? SizedBox(
                                  height: 30,
                                  child: Container(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          
                                          
                                          

                                          groceryBloc.addProduct(
                                              widget.product,
                                              (itemInCart != null)
                                                  ? itemInCart.quantity
                                                  : 1);
                                          HapticFeedback.lightImpact();
                                          _listenNotification(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5.0,
                                          fixedSize:
                                              Size.fromWidth(size.width / 4),
                                          primary: currentTheme
                                              .currentTheme.primaryColor,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: Text('Agregar',
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey[200],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      (itemInCart.quantity == 1)
                                          ? Container(
                                              padding:
                                                  EdgeInsets.only(right: 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  groceryBloc.deleteProduct(
                                                      itemInCart);
                                                },
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  EdgeInsets.only(right: 0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  if (itemInCart.quantity > 0) {
                                                    groceryBloc.addProduct(
                                                        widget.product, -1);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          itemInCart.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();

                                          groceryBloc.addProduct(
                                              widget.product, 1);
                                        },
                                        child: Container(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),

                                */
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

const _maxHeaderExtent = 410.0;
const _minHeaderExtent = 200.0;

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

    final followService = Provider.of<FollowService>(context);

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

    final username = store.user.username;

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
                    color: currentTheme.currentTheme.primaryColor),
                iconSize: 25,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                color: Colors.blueAccent,
              ),
            ),
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
                            padding: EdgeInsets.only(top: 20, left: 10),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(20),
                              ],
                              focusNode: _focusNode,

                              controller: textCtrl,
                              //  keyboardType: TextInputType.emailAddress,

                              maxLines: 1,

                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          currentTheme.currentTheme.cardColor),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelStyle: TextStyle(color: Colors.white54),
                                // icon: Icon(Icons.perm_identity),
                                //  fillColor: currentTheme.accentColor,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: currentTheme.currentTheme.cardColor,
                                  ),
                                ),
                                hintText: 'Buscar productos ...',
                              ),
                              onChanged: (value) =>
                                  bloc.sharedProductOnStoreCurrent(value),
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
              left: (percent >= 0.9) ? leftTextMargin : leftTextMargin + 30,
              height: _maxImageSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    store.name.capitalize(),
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
                    width: size.width / 3,
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
                  if (followService.followers > 0)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      child: Text(
                        '${followService.followers}  Seguidores',
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
            Positioned(
              bottom: 0.0,
              left: 20,
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ButtonFollow(
                      percent: percent, store: store, left: leftTextMargin),
                ],
              ),
            ),
            Positioned(
                bottom: (_bottomMarginDisc * (1 - percent))
                    .clamp(70.0, _bottomMarginDisc),
                left: (_leftMarginDisc * (1 - percent))
                    .clamp(20.0, _leftMarginDisc),
                height: currentImageSize,
                child: Hero(
                  tag: 'user_auth_avatar_list_${store.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: (store.imageAvatar != "")
                        ? Container(
                            height: currentImageSize,
                            width: currentImageSize,
                            child: cachedNetworkImage(
                              store.imageAvatar,
                            ),
                          )
                        : Image.asset(currentProfile.imageAvatar),
                  ),
                )),
            /*  Positioned(
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
  const ButtonFollow({Key key, @required this.percent, this.left, this.store})
      : super(key: key);

  final num percent;

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

  void messageToWhatsapp(String number) async {
    await launch("https://wa.me/56$number?text=Hola!");
  }

  _launchMessageEmail(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=Hola&body=Mensage');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneStore = widget.store.user.phone.toString();

    final emailStore = widget.store.user.phone.toString();

    final authService = Provider.of<AuthenticationBLoC>(context);

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
                      Navigator.push(context, loginRoute(100));
                    } else
                      this.changeFollow();
                  },
                  isEdit: true,
                  isDelete: false,
                  isAccent: (!widget.store.isFollowing))),
        ),
        if (phoneStore != "")
          Container(
              padding: EdgeInsets.only(left: 10),
              width: 120,
              height: 35,
              child: elevatedButtonCustom(
                  context: context,
                  title: 'Whatsapp',
                  onPress: () {
                    HapticFeedback.lightImpact();
                    messageToWhatsapp(widget.store.user.phone.toString());
                  },
                  isEdit: true,
                  isDelete: false,
                  isAccent: false)),
        if (emailStore != "")
          Container(
              padding: EdgeInsets.only(left: 10),
              width: 120,
              height: 35,
              child: elevatedButtonCustom(
                  context: context,
                  title: 'Email',
                  onPress: () {
                    HapticFeedback.lightImpact();
                    _launchMessageEmail(widget.store.user.email);
                  },
                  isEdit: true,
                  isDelete: false,
                  isAccent: false)),
/*         Container(
            padding: EdgeInsets.only(left: 10),
            width: 100,
            height: 35,
            child: elevatedButtonCustom(
                context: context,
                title: (!widget.store.isFollowing) ? 'Seguir' : 'Siguiendo',
                onPress: () {
                  this.changeFollow();
                },
                isEdit: true,
                isDelete: false,
                isAccent: (!widget.store.isFollowing))), */
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
