import 'dart:ui';

import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:provider/provider.dart';

class GLMenuButton {
  @required
  final Function onPressed;
  @required
  final IconData icon;

  GLMenuButton({this.onPressed, this.icon});
}

class GridLayoutMenu extends StatelessWidget {
  final bool show;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final List<GLMenuButton> items;

  GridLayoutMenu(
      {this.show = true,
      this.backgroundColor = Colors.white,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.blueGrey,
      @required this.items});

  // Builder Menu and Items
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _MenuModel(),
      child: (!UniversalPlatform.isWeb)
          ? ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: (show) ? 10.0 : 0,
                  sigmaY: (show) ? 10.0 : 0,
                ),
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: (show) ? 0.7 : 0,
                    child: Builder(builder: (BuildContext context) {
                      Provider.of<_MenuModel>(context).backgroundColor =
                          this.backgroundColor;
                      Provider.of<_MenuModel>(context).activeColor =
                          this.activeColor;
                      Provider.of<_MenuModel>(context).inactiveColor =
                          this.inactiveColor;

                      return GLMenuBackGround(child: _MenuItems(items));
                    })),
              ),
            )
          : AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: (show) ? 1.0 : 0,
              child: Builder(builder: (BuildContext context) {
                Provider.of<_MenuModel>(context).backgroundColor =
                    this.backgroundColor;
                Provider.of<_MenuModel>(context).activeColor = this.activeColor;
                Provider.of<_MenuModel>(context).inactiveColor =
                    this.inactiveColor;

                return GLMenuBackGround(child: _MenuItems(items));
              })),
    );
  }
}

class GLMenuBackGround extends StatelessWidget {
  final Widget child;

  const GLMenuBackGround({@required this.child});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      child: child,
      width: 350,
      height: 70,
      decoration: BoxDecoration(
          color: currentTheme.currentTheme.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: -5)
          ]),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final List<GLMenuButton> menuItems;

  _MenuItems(this.menuItems);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
            menuItems.length, (i) => _GridLayoutMenuButton(i, menuItems[i])));
  }
}

class _GridLayoutMenuButton extends StatelessWidget {
  final int index;
  final GLMenuButton item;

  _GridLayoutMenuButton(this.index, this.item);

  @override
  Widget build(BuildContext context) {
    final intemSelected = Provider.of<_MenuModel>(context).itemSelected;

    final menuProvider = Provider.of<_MenuModel>(context);

    return GestureDetector(
      onTap: () {
        Provider.of<_MenuModel>(context, listen: false).itemSelected = index;
        item.onPressed();
      },
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 900),
        child: Icon(
          item.icon,
          size: (intemSelected == index) ? 35 : 30,
          color: (intemSelected == index)
              ? menuProvider.activeColor
              : menuProvider.inactiveColor,
        ),
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  Color backgroundColor = Colors.white;
  Color activeColor = Colors.black;
  Color inactiveColor = Colors.blueGrey;

  int _itemSelected = 0;

  int get itemSelected => this._itemSelected;

  set itemSelected(int index) {
    this._itemSelected = index;
    notifyListeners();
  }
}
