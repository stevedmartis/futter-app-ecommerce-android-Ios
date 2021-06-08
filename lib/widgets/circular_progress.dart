import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildLoadingWidget(context) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  return Container(
      padding: EdgeInsets.all(10),
      child: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(currentTheme.accentColor),
      )));
}
