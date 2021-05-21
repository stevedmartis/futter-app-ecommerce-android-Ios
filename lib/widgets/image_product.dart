import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingMessages extends StatelessWidget {
  final String title;
  final String message;
  final String image;
  final double left;
  final double width;
  final double height;
  const OnboardingMessages(
      {Key key,
      this.title,
      this.message,
      this.image,
      this.left,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Center(
      child: Container(
          margin: EdgeInsets.only(top: _size.height / 20, left: 0),
          width: _size.width,
          height: _size.height,
          child: Image.network(image)),
    );
  }
}
