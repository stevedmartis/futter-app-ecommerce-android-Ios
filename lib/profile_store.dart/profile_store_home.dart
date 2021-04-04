import 'package:flutter/material.dart';
import 'package:youtube_diegoveloper_challenges/store_product_concept/store_product_bloc.dart';
import 'package:youtube_diegoveloper_challenges/store_product_concept/store_product_data.dart';
import 'package:youtube_diegoveloper_challenges/vinyl_disc/album.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
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

  double get maxHeight => 454 + MediaQuery.of(context).padding.top;
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: () {},
        ),
        backgroundColor: _colorHeader,
        body: NotificationListener<ScrollEndNotification>(
            onNotification: (_) {
              _bloc.snapAppbar();
              // if (_scrollController.offset >= 250) {}
              return false;
            },
            child: SafeArea(
                child: AnimatedBuilder(
              animation: _bloc,
              builder: (_, __) => NestedScrollView(
                controller: _bloc.scrollController2,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverPersistentHeader(
                      delegate: _ProfileStoreHeader(
                          scrollController: _bloc.scrollController2,
                          maxHeight: maxHeight,
                          minHeight: minHeight),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          currentAlbum.description,
                        ),
                      ),
                    ),
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
                        toolbarHeight: 50,
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
                            margin: EdgeInsets.only(top: 20),
                            child: _ProfileStoreCategoryItem(item.category));
                      } else {
                        return _ProfileStoreProductItem(item.product);
                      }
                    },
                  ),
                ),
              ),
            ))));
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
    return Container(
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
                child: Image.asset(product.image),
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
    );
  }
}

const _maxHeaderExtent = 310.0;
const _minHeaderExtent = 100.0;

const _maxImageSize = 160.0;
const _minImageSize = 60.0;

const _leftMarginDisc = 150.0;

const _maxTitleSize = 25.0;
const _maxSubTitleSize = 18.0;

const _minTitleSize = 16.0;
const _minSubTitleSize = 12.0;

class _ProfileStoreHeader extends SliverPersistentHeaderDelegate {
  _ProfileStoreHeader({this.scrollController, this.maxHeight, this.minHeight});
  final ScrollController scrollController;
  final double maxHeight;
  final double minHeight;

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
    final titleSize = (_maxTitleSize * (1 - percent)).clamp(
      _minTitleSize,
      _maxTitleSize,
    );

    final subTitleSize = (_maxSubTitleSize * (1 - percent)).clamp(
      _minSubTitleSize,
      _maxSubTitleSize,
    );

    void _snapAppbar() {
      final scrollDistance = maxHeight * minHeight;

      if (scrollController.offset > 400 &&
          scrollController.offset < scrollDistance) {
        final double snapOffset =
            scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

        Future.microtask(() => scrollController.animateTo(snapOffset,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn));
      }
    }

    final maxMargin = size.width / 4;
    final textMovement = 30.0;
    final leftTextMargin = maxMargin + (textMovement * percent);
    return GestureDetector(
      onTap: () => _snapAppbar(),
      child: Container(
        color: _colorHeader,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 50.0,
              left: leftTextMargin,
              height: _maxImageSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentAlbum.artist,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    currentAlbum.album,
                    style: TextStyle(
                      fontSize: subTitleSize,
                      letterSpacing: -0.5,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
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
            ),
            Positioned(
              bottom: 20.0,
              left: 35.0,
              height: currentImageSize,
              child: Image.asset(
                currentAlbum.imageAlbum,
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
