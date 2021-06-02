import 'dart:math';

import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Logo extends StatelessWidget {
  final Color color;
  final double size;

  const Logo({
    @required this.color,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Transform.rotate(
      angle: -pi / 4,
      child: Icon(
        Icons.storefront,
        color: currentTheme.accentColor,
        size: size,
      ),
    );
  }
}
