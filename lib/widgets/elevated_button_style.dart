import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

elevatedButtonCustom(
    {BuildContext context, String title, VoidCallback onPress}) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  return Center(
    child: Container(
      width: 300,
      height: 60,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.bottomCenter,
          colors: [
            currentTheme.primaryColor.withOpacity(0.90),
            Color(0xff3AFF4D),
            currentTheme.primaryColor.withOpacity(0.90),
          ],
        ),
      ),
      child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: StadiumBorder(),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => onPress()),
    ),

    /*  ElevatedButton(
      onPressed: () {
        print('Hi there');
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [currentTheme.primaryColor, currentTheme.primaryColor]),
            borderRadius: BorderRadius.circular(40)),
        child: Container(
          width: 300,
          height: 70,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    ), */
  );
}
