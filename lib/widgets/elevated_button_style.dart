import 'dart:ui';

import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'circular_progress.dart';

elevatedButtonCustom(
    {BuildContext context,
    String title,
    VoidCallback onPress,
    bool isEdit = false,
    bool isDelete = false}) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  return OutlinedButton(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.pressed)
            ? Colors.blue
            : (isEdit)
                ? Colors.grey
                : isDelete
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

    return Stack(
      alignment: Alignment(1.0, 0.0),
      children: <Widget>[
        (loading)
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
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green[800],
                            child: Text(
                              bloc.totalCartElements().toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                          Spacer(),
                          Text(
                            'SubTotal: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                              '\$${bloc.totalPriceElements().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ))
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
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
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Text(
                              bloc.totalCartElements().toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                          Spacer(),
                          Text(
                            'SubTotal: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                              '\$${bloc.totalPriceElements().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ))
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  ),
      ],
    );
  });
}
