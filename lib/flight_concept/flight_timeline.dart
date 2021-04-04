import 'package:flutter/material.dart';
import 'flight_routes.dart';

const _airplaneSize = 30.0;
const _dotSize = 18.0;
const _cardAnimationDuration = 100;

class FlightTimeline extends StatefulWidget {
  @override
  _FlightTimelineState createState() => _FlightTimelineState();
}

class _FlightTimelineState extends State<FlightTimeline> {
  bool animated = false;
  bool animateCards = false;
  bool animateButton = false;

  void initAnimation() async {
    setState(() {
      animated = !animated;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      animateCards = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animateButton = true;
    });
  }

  void _onRoutesPressed() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation1, ___) {
          return FadeTransition(
            opacity: animation1,
            child: FlightRoutes(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAnimation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final centerDot = constraints.maxWidth / 2 - _dotSize / 2;
      return Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            left: constraints.maxWidth / 2 - _airplaneSize / 2,
            top: animated ? 20 : constraints.maxHeight - _airplaneSize - 10,
            bottom: 0.0,
            child: AircraftAndLine(),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            left: centerDot,
            top: animated ? 80 : constraints.maxHeight,
            child: TimelineDot(
              selected: true,
              displayCard: animateCards,
              delay: const Duration(milliseconds: _cardAnimationDuration),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            right: centerDot,
            top: animated ? 140 : constraints.maxHeight,
            child: TimelineDot(
              left: true,
              displayCard: animateCards,
              delay: const Duration(milliseconds: _cardAnimationDuration * 2),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            left: centerDot,
            top: animated ? 200 : constraints.maxHeight,
            child: TimelineDot(
              displayCard: animateCards,
              delay: const Duration(milliseconds: _cardAnimationDuration * 3),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            right: centerDot,
            top: animated ? 260 : constraints.maxHeight,
            child: TimelineDot(
              selected: true,
              left: true,
              displayCard: animateCards,
              delay: const Duration(milliseconds: _cardAnimationDuration * 4),
            ),
          ),
          if (animateButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.check),
                  onPressed: _onRoutesPressed,
                ),
              ),
            ),
        ],
      );
    });
  }
}

class AircraftAndLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _airplaneSize,
      child: Column(
        children: <Widget>[
          Icon(
            Icons.flight,
            color: Colors.red,
            size: _airplaneSize,
          ),
          Expanded(
            child: Container(
              width: 5,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineDot extends StatefulWidget {
  final bool selected;
  final bool displayCard;
  final bool left;
  final Duration delay;

  const TimelineDot({
    Key key,
    this.selected = false,
    this.displayCard = false,
    this.left = false,
    this.delay,
  }) : super(key: key);

  @override
  _TimelineDotState createState() => _TimelineDotState();
}

class _TimelineDotState extends State<TimelineDot> {
  bool animated = false;

  void _animateWithDelay() async {
    if (widget.displayCard) {
      await Future.delayed(widget.delay);
      setState(() {
        animated = true;
      });
    }
  }

  @override
  void didUpdateWidget(TimelineDot oldWidget) {
    _animateWithDelay();
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildCard() => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: _cardAnimationDuration),
        child: Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('JFK + ORY'),
          ),
        ),
        builder: (context, value, child) {
          return Transform.scale(
            alignment: widget.left ? Alignment.centerRight : Alignment.centerLeft,
            scale: value,
            child: child,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (animated && widget.left) ...[
          _buildCard(),
          Container(
            width: 10,
            height: 1,
            color: Colors.grey[400],
          ),
        ],
        Container(
          height: _dotSize,
          width: _dotSize,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300],
            ),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircleAvatar(
              backgroundColor: widget.selected ? Colors.red : Colors.green,
            ),
          ),
        ),
        if (animated && !widget.left) ...[
          Container(
            width: 10,
            height: 1,
            color: Colors.grey[400],
          ),
          _buildCard(),
        ],
      ],
    );
  }
}
