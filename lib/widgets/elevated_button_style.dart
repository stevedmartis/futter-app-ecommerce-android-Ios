import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

elevatedButtonCustom(
    {BuildContext context,
    String title,
    VoidCallback onPress,
    bool isEdit = false,
    bool isDelete = false}) {
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
            if (!isEdit) currentTheme.primaryColor.withOpacity(0.90),
            if (!isEdit) Color(0xff3AFF4D),
            if (!isEdit) currentTheme.primaryColor.withOpacity(0.90),
            if (isEdit) Colors.white,
            if (isEdit) Color(0xff3AFF4D),
            if (isEdit) Colors.white.withOpacity(0.90),
            if (isDelete)
              currentTheme.scaffoldBackgroundColor.withOpacity(0.90),
            if (isDelete) Color(0xff3AFF4D),
            if (isDelete)
              currentTheme.scaffoldBackgroundColor.withOpacity(0.90),
          ],
        ),
      ),
      child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: StadiumBorder(),
          child: Text(
            title,
            style: TextStyle(
                color: (isEdit)
                    ? Colors.black
                    : (isDelete)
                        ? Colors.red
                        : Colors.white,
                fontSize: 20),
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

bool loading = false;
Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible, bool isDisable) {
  return Builder(builder: (BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment(1.0, 0.0),
      children: <Widget>[
        (loading)
            ? _buildLoadingWidget()
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
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  )
                : Container(
                    alignment: Alignment.bottomCenter,
                    width: _size.width / 1.7,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  ),
      ],
    );
  });
}

Widget goPayCartBtnSubtotal(
    String title, List<Color> gradient, bool isEndIconVisible, bool isDisable) {
  return Builder(builder: (BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final bloc = Provider.of<GroceryStoreBLoC>(context);

    return Stack(
      alignment: Alignment(1.0, 0.0),
      children: <Widget>[
        (loading)
            ? _buildLoadingWidget()
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
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                          Spacer(),
                          Text(
                            'SubTotal:',
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
                    width: _size.width / 1.7,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                  ),
      ],
    );
  });
}

Widget _buildLoadingWidget() {
  return Container(
      height: 50.0, child: Center(child: CircularProgressIndicator()));
}
