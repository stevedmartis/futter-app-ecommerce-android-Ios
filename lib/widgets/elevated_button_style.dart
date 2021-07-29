import 'dart:ui';

import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'circular_progress.dart';

elevatedButtonCustom(
    {BuildContext context,
    String title,
    VoidCallback onPress,
    bool isEdit = false,
    bool isDelete = false,
    bool isAccent = false,
    bool isCancel = false}) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  return OutlinedButton(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.red))),
      side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.pressed)
            ? currentTheme.accentColor
            : (isAccent)
                ? currentTheme.accentColor
                : (isEdit)
                    ? Colors.grey
                    : isDelete || isCancel
                        ? currentTheme.scaffoldBackgroundColor
                        : Colors.black;
        return BorderSide(color: color, width: 2);
      }),
    ),
    onPressed: onPress,
    child: Text(title,
        style: TextStyle(
            color: (isEdit)
                ? Colors.white
                : isDelete
                    ? Colors.red
                    : isCancel
                        ? Colors.grey
                        : Colors.white)),
  );
}

bool loading = false;
Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible, bool isDisable) {
  return Builder(builder: (BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment(1.0, 0.0),
      children: <Widget>[
        (loading)
            ? buildLoadingWidget(context)
            : (isDisable)
                ? Container(
                    alignment: Alignment.bottomCenter,
                    width: _size.width / 1.15,
                    height: _size.height / 15,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Text(title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  )
                : Container(
                    alignment: Alignment.bottomCenter,
                    width: _size.width / 1.15,
                    height: _size.height / 15,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      gradient: LinearGradient(
                          colors: [Colors.grey[800], Colors.grey[800]],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Text(title,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  ),
      ],
    );
  });
}

Widget confirmButton(
    String title, List<Color> gradient, bool isEndIconVisible, bool isDisable) {
  return Builder(builder: (BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment(1.0, 0.0),
      children: <Widget>[
        (loading)
            ? buildLoadingWidget(context)
            : (isDisable)
                ? Container(
                    alignment: Alignment.bottomCenter,
                    width: _size.width / 1.15,
                    height: _size.height / 13,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  )
                : Container(
                    alignment: Alignment.bottomCenter,
                    width: _size.width / 1.15,
                    height: _size.height / 13,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      gradient: LinearGradient(
                          colors: [Colors.grey[800], Colors.grey[800]],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(title,
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  ),
      ],
    );
  });
}

Widget goPayCartBtnSubtotal(
  String title,
  List<Color> gradient,
  bool isEndIconVisible,
  bool isDisable,
) {
  return Builder(builder: (BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final bloc = Provider.of<GroceryStoreBLoC>(context);

    final totalFormat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(bloc.totalPriceElements());

    return (loading)
        ? buildLoadingWidget(context)
        : (isDisable)
            ? Container(
                alignment: Alignment.bottomCenter,
                width: _size.width / 1.15,
                height: _size.height / 12,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: ShapeDecoration(
                          color: Colors.green[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: Center(
                          child: Text(
                            bloc.totalCartElements().toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        child: Text(title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)),
                      ),
                      Spacer(),
                      Text('\$$totalFormat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ))
                    ],
                  ),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
              )
            : Container(
                alignment: Alignment.bottomCenter,
                width: _size.width / 1.15,
                height: _size.height / 12,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  gradient: LinearGradient(
                      colors: [Colors.grey[800], Colors.grey[800]],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: ShapeDecoration(
                          color: Colors.black54,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: Center(
                          child: Text(
                            bloc.totalCartElements().toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      Spacer(),
                      Text('\$${bloc.totalPriceElements().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ))
                    ],
                  ),
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
              );
  });
}
