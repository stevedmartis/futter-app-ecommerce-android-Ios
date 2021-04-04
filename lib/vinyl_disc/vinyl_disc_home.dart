import 'package:flutter/material.dart';
import 'package:youtube_diegoveloper_challenges/vinyl_disc/album.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

const _colorHeader = Color(0xFFECECEA);

class VinylDiscHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () {},
      ),
      backgroundColor: _colorHeader,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: _MyVinylDiscHeader(),
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
          ],
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

class _MyVinylDiscHeader extends SliverPersistentHeaderDelegate {
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

    final maxMargin = size.width / 4;
    final textMovement = 30.0;
    final leftTextMargin = maxMargin + (textMovement * percent);
    return Container(
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
            left:
                (_leftMarginDisc * (1 - percent)).clamp(33.0, _leftMarginDisc),
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
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
