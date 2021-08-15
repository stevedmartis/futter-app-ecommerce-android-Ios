import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class LogoFreeily extends StatelessWidget {
  final Color color;
  final double size;

  const LogoFreeily({
    @required this.color,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      child: Container(
          width: 60,
          height: 60,
          child: Image.asset(
            'assets/icons/freeily-short.png',
            fit: BoxFit.cover,
          )),
    );
  }
}
