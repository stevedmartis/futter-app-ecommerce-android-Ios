import 'package:australti_feriafy_app/authentication/auth_bloc.dart';
import 'package:australti_feriafy_app/routes/routes.dart';
import 'package:australti_feriafy_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:australti_feriafy_app/travel_photos/travel_photo.dart';

class TravelPhotosHome extends StatefulWidget {
  @override
  _TravelPhotosHomeState createState() => _TravelPhotosHomeState();
}

class _TravelPhotosHomeState extends State<TravelPhotosHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            makeHeaderPrincipal(context),
            makeHeaderTitle(context),
            makeListRecomendations(context)
          ],
        )));
  }
}

SliverPersistentHeader makeHeaderPrincipal(context) {
  return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 120,
          maxHeight: 440,
          child: Container(
              color: Colors.black,
              child: Container(color: Colors.black, child: HeaderCustom()))));
}

SliverPersistentHeader makeHeaderTitle(context) {
  return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
          minHeight: 60,
          maxHeight: 60,
          child: Container(
            color: Colors.black,
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Recomendation',
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

SliverList makeListRecomendations(context) {
  return SliverList(
    delegate: SliverChildListDelegate([
      Container(child: _buildWidgetItem()),
    ]),
  );
}

Widget _buildWidgetItem() {
  return Container(
    child: SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (BuildContext ctxt, int index) {
            return Stack(
              children: [
                FakeReview(),
                FakeReview(),
                FakeReview(),
                FakeReview(),
              ],
            );
          }),
    ),
  );
}

class HeaderCustom extends StatefulWidget {
  @override
  _HeaderCustomState createState() => _HeaderCustomState();
}

class _HeaderCustomState extends State<HeaderCustom> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final topCardHeight = size.height / 2.0;
    final horizontalListHeight = 160.0;
    TravelPhoto _selected = travelPhotos.last;

    return Stack(
      children: <Widget>[
        Positioned(
          height: topCardHeight,
          left: 0,
          right: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: TravelPhotoDetails(
              key: Key(_selected.name),
              travelPhoto: _selected,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: topCardHeight - horizontalListHeight / 3,
          height: horizontalListHeight,
          child: TravelPhotosList(
            onPhotoSelected: (item) {
              setState(() {
                _selected = item;
              });
            },
          ),
        ),
      ],
    );
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
                travelPhotos.first.backImage,
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

class TravelPhotoDetails extends StatefulWidget {
  final TravelPhoto travelPhoto;

  const TravelPhotoDetails({Key key, this.travelPhoto}) : super(key: key);

  @override
  _TravelPhotoDetailsState createState() => _TravelPhotoDetailsState();
}

class _TravelPhotoDetailsState extends State<TravelPhotoDetails>
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
                  widget.travelPhoto.backImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 70,
                left: 10,
                right: 10,
                height: 40,
                child: FittedBox(
                  child: Text(
                    widget.travelPhoto.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                left: _movement * _controller.value,
                right: _movement * (1 - _controller.value),
                child: Container(
                  child: Image.asset(
                    widget.travelPhoto.frontImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 15,
                right: 0,
                height: 45,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                      child: GestureDetector(
                    onTap: () {
                      {
                        Navigator.push(context, profileAuthRoute());
                      }
                    },
                    child: Hero(
                      tag: 'user_auth_avatar',
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      "https://lh3.googleusercontent.com/ogw/ADGmqu-N16bBzFHRsgF3UX1nSmunUCznIt8LmhSgqFCE=s192-c-mo")))),
                    ),
                  )),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 70,
                  right: 10,
                  height: 70,
                  child: Container(
                      alignment: Alignment.center,
                      child: _MyTextField(_controller))),
            ],
          );
        });
  }
}

class _MyTextField extends AnimatedWidget {
  _MyTextField(Animation<double> animation) : super(listenable: animation);

  Animation<double> get animation => listenable;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final value = 1 - animation.value;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          width: size.width / 1.6,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.40),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text('Search ...',
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ],
            ),
          )),
    );
  }
}

class TravelPhotosList extends StatefulWidget {
  const TravelPhotosList({Key key, this.onPhotoSelected}) : super(key: key);
  final ValueChanged<TravelPhoto> onPhotoSelected;

  @override
  _TravelPhotosListState createState() => _TravelPhotosListState();
}

class _TravelPhotosListState extends State<TravelPhotosList> {
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
        final travelPhoto = travelPhotos[index];
        final percent = page - page.floor();
        final factor = percent > 0.5 ? (1 - percent) : percent;
        return InkWell(
          onTap: () {
            travelPhotos.insert(travelPhotos.length, travelPhoto);
            _animatedListKey.currentState.insertItem(travelPhotos.length - 1);
            final itemToDelete = travelPhoto;
            widget.onPhotoSelected(travelPhoto);
            travelPhotos.removeAt(index);
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
              travelPhoto: travelPhoto,
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      initialItemCount: travelPhotos.length,
    );
  }
}

class TravelPhotoListItem extends StatelessWidget {
  final TravelPhoto travelPhoto;

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
                child: Image.asset(
                  travelPhoto.backImage,
                  fit: BoxFit.cover,
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
                        '${travelPhoto.photos} photos',
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
