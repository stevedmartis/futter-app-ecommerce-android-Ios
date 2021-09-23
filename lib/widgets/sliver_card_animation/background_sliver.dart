import 'package:flutter/material.dart';
import 'package:freeily/theme/theme.dart';
import 'package:provider/provider.dart';

class BackgroundSliver extends StatelessWidget {
  const BackgroundSliver({Key key, this.colorVibrant}) : super(key: key);

  final String colorVibrant;

  @override
  Widget build(BuildContext context) {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  currentTheme.scaffoldBackgroundColor,
                  Color(int.parse(colorVibrant)).withOpacity(0.90),
                  Color(int.parse(colorVibrant)).withOpacity(0.90),
                  currentTheme.scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0, 0.3, 1],
                tileMode: TileMode.clamp),
          ),
        ));
  }
}
