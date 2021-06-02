import 'package:flutter/material.dart';

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

    return Center(
      child: Container(
          margin: EdgeInsets.only(top: _size.height / 20, left: 0),
          width: _size.width,
          height: _size.height,
          child: Image.network(image)),
    );
  }
}
