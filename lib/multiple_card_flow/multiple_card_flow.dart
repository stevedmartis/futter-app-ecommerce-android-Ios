import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:australti_ecommerce_app/multiple_card_flow/multiple_card_flow_details.dart';
import 'package:australti_ecommerce_app/multiple_card_flow/place.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

const backgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF4b6089),
    Color(0xFF9FB4D2),
  ],
);

class MultipleCardFlow extends StatefulWidget {
  @override
  _MultipleCardFlowState createState() => _MultipleCardFlowState();
}

class _MultipleCardFlowState extends State<MultipleCardFlow>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController(viewportFraction: 0.8);
  AnimationController _animationController;
  double page = 0.0;

  void _listenScroll() {
    setState(() {
      page = _pageController.page;
    });
  }

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 1300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onSwipe(City city) async {
    _animationController.forward();
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: MultipleCardFlowDetails(city: city),
          );
        },
      ),
    );
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _MyTextField(_animationController),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_applications),
                      onPressed: () => null,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final percent = (page - index).abs().clamp(0.0, 1.0);
                      final factor =
                          _pageController.position.userScrollDirection ==
                                  ScrollDirection.forward
                              ? 1.0
                              : -1.0;

                      final opacity = percent.clamp(0.0, 0.7);
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                            vector.radians(45 * factor * percent),
                          ),
                        child: Opacity(
                          opacity: (1 - opacity),
                          child: CityItemWidget(
                            city: city,
                            onSwipe: () {
                              _onSwipe(city);
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class CityItemWidget extends StatelessWidget {
  const CityItemWidget({
    Key key,
    this.city,
    this.onSwipe,
  }) : super(key: key);
  final City city;
  final VoidCallback onSwipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta < -7) {
          onSwipe();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: CityWidget(
                city: city,
              ),
            ),
            Spacer(),
            Expanded(
              flex: 5,
              child: ReviewWidget(
                review: city.reviews.first,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityWidget extends StatelessWidget {
  const CityWidget({
    Key key,
    @required this.city,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);
  final City city;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0);
    final subtitleStyle = TextStyle(
        color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15.0);

    return Hero(
      tag: 'city_${city.name}',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 10,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                city.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 0, top: 30),
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      city.name,
                      style: titleStyle,
                    ),
                    Text(
                      city.price,
                      style: titleStyle,
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        city.place,
                        style: subtitleStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        city.date,
                        style: subtitleStyle.copyWith(
                          fontSize: 15,
                          shadows: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 10.0,
                              spreadRadius: 10.0,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  ReviewWidget({Key key, @required this.review}) : super(key: key);
  final CityReview review;
  final DateFormat format = DateFormat.yMEd();

  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(height: 10);
    return Hero(
      tag: 'review_${review.title}',
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      review.avatar,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        separator,
                        Text(
                          review.title,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        Text(
                          format.format(
                            review.date,
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              separator,
              Text(
                review.subtitle,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
              separator,
              Text(
                review.description,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w200),
              ),
              separator,
              Expanded(
                child: Image.asset(
                  review.image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
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
        width: size.width * value,
        height: 40,
        decoration: BoxDecoration(
            color: Color(0xFF8E9BB5), borderRadius: BorderRadius.circular(20)),
        child: value > 0.4
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    Expanded(
                      child: Text('Search city...',
                          style: TextStyle(
                            color: Colors.grey[600],
                          )),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
