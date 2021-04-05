import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:australti_feriafy_app/grocery_store/grocery_provider.dart';
import 'package:australti_feriafy_app/profile_store.dart/product_detail.dart';
import 'package:australti_feriafy_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_feriafy_app/store_product_concept/store_product_data.dart';
import 'package:australti_feriafy_app/vinyl_disc/album.dart';
import 'dart:math' as math;

const _colorHeader = Color(0xFFECECEA);
const _blueColor = Color(0xFF0D1863);
const _greenColor = Color(0xFF2BBEBA);

class ProfileStore extends StatefulWidget {
  @override
  _ProfileStoreState createState() => _ProfileStoreState();
}

class _ProfileStoreState extends State<ProfileStore>
    with TickerProviderStateMixin {
  final _bloc = TabsViewScrollBLoC();

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  @override
  void initState() {
    _bloc.init(this);

    super.initState();
  }

  TabController controller;

  int itemCount;
  IndexedWidgetBuilder tabBuilder;
  IndexedWidgetBuilder pageBuilder;
  Widget stub;
  ValueChanged<int> onPositionChange;
  ValueChanged<double> onScroll;
  int initPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*  floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: () {},
        ), */
        backgroundColor: _colorHeader,
        body: SafeArea(
            child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => NestedScrollView(
            controller: _bloc.scrollController2,
            headerSliverBuilder: (context, value) {
              return [
                SliverPersistentHeader(
                  delegate: _ProfileStoreHeader(
                      bloc: _bloc, maxHeight: maxHeight, minHeight: minHeight),
                  pinned: true,
                ),
                /* SliverToBoxAdapter(
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '15 - 30 min',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ), */
                /*   SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                          minHeight: 70,
                          maxHeight: 70,
                          child: Container(
                            color: _colorHeader,
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              onTap: _bloc.onCategorySelected,
                              controller: _bloc.tabController,
                              indicatorWeight: 0.1,
                              isScrollable: true,
                              tabs:
                                  _bloc.tabs.map((e) => _TabWidget(e)).toList(),
                            ),
                          )),
                    ), */
                SliverAppBar(
                    collapsedHeight: categoryHeight,
                    backgroundColor: _colorHeader,
                    toolbarHeight: categoryHeight,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    actions: [Container()],
                    title: Container(
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
                      ), /* TabBar(

                              controller: controller,
                              indicatorWeight: 5,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 4,
                                  ),
                                ),
                              ),
                              tabs: List.generate(
                                  1, (index) => tabBuilder(context, index))) */
                    ))
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
                    return _ProfileStoreProductItem(item.product);
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
    final selected = tabCategory.selected;

    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        color: Colors.white,
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
            style: TextStyle(
              color: _blueColor,
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
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category.name,
        style: TextStyle(
          color: _blueColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileStoreProductItem extends StatelessWidget {
  const _ProfileStoreProductItem(this.product);
  final ProfileStoreProduct product;
  @override
  Widget build(BuildContext context) {
    final bloc = GroceryProvider.of(context).bloc;

    return GestureDetector(
      onTap: () async {
        bloc.changeToDetails();
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    product: product,
                    onProductAdded: (int quantity) {
                      //bloc.addProduct(product, quantity);
                    }),
              );
            },
          ),
        );
        bloc.changeToNormal();
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
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Hero(
                      tag: '${product.name}',
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
                          color: _blueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.description,
                        maxLines: 2,
                        style: TextStyle(
                          color: _blueColor,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: _greenColor,
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
  _ProfileStoreHeader({this.bloc, this.maxHeight, this.minHeight});
  final double maxHeight;
  final double minHeight;
  final TabsViewScrollBLoC bloc;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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

    final username = currentProfile.username;

    return GestureDetector(
      onTap: () => bloc.snapAppbar(),
      child: Container(
        color: _colorHeader,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 18.0,
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.chevronLeft, color: _blueColor),
                iconSize: 25,
                onPressed: () =>
                    //  Navigator.pushReplacement(context, createRouteProfile()),
                    Navigator.pop(context),
                color: Colors.blueAccent,
              ),
            ),
            Positioned(
              top: 20,
              left: 50,
              child: GestureDetector(
                  onTap: () => {},
                  child: Container(

                      // color: Colors.black,
                      //  margin: EdgeInsets.only(left: 10, right: 10),
                      width: size.width / 1.6,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.black26, Colors.black26]),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        /*  boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              spreadRadius: -5,
                              blurRadius: 10,
                              offset: Offset(0, 5))
                        ], */
                      ),
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

                              Icon(Icons.search, color: Colors.white),
                              SizedBox(width: 10),
                              Container(
                                  // margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text('Search in this Store',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))),
                            ],
                          )))),
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
                    currentProfile.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                        letterSpacing: -0.5,
                        color: _blueColor),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: subTitleSize,
                        letterSpacing: -0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      '300 seguidores',
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
            (percent <= 0.9)
                ? Positioned(
                    top: 350,
                    right: 100,
                    child: Container(
                      width: 180,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _blueColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Text(
                            'Fallow',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () => null,
                      ),
                    ))
                : Positioned(
                    top: 90,
                    right: 20,
                    child: Container(
                      width: 100,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _blueColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Text(
                            'Fallow',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () => null,
                      ),
                    )),

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
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: Image.asset(
                    currentProfile.imageAvatar,
                  ),
                )),
            Positioned(
              right: 40,
              top: 18.0,
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.share, color: _blueColor),
                iconSize: 25,
                onPressed: () =>
                    //  Navigator.pushReplacement(context, createRouteProfile()),
                    Navigator.pop(context),
                color: Colors.blueAccent,
              ),
            ),
            Positioned(
              right: 0,
              top: 18.0,
              child: IconButton(
                icon: Icon(Icons.menu, color: _blueColor),
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
