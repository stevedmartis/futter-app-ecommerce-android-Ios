import 'package:flutter/material.dart';

class ShakeTransition extends StatelessWidget {
  const ShakeTransition({
    Key key,
    this.duration = const Duration(milliseconds: 900),
    this.offset = 140.0,
    this.axis = Axis.horizontal,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final double offset;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 1.0,
        end: 0.0,
      ),
      child: child,
      curve: Curves.elasticOut,
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: axis == Axis.horizontal ? Offset(value * offset, 0.0) : Offset(0.0, value * offset),
          child: child,
        );
      },
    );
  }
}
