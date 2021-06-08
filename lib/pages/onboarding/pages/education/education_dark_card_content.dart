import 'package:flutter/material.dart';

class EducationDarkCardContent extends StatelessWidget {
  const EducationDarkCardContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Image.asset(
        'assets/on_board/e-Commerce.png',
        height: 1000.0,
        width: 1000.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
