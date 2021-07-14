import 'dart:ui';

import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
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

Color backgroundColor = Colors.white;
Color activeColor = Colors.black;
Color inactiveColor = Colors.blueGrey;

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
                    tileMode: TileMode.repeated),
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: (show) ? 0.7 : 0,
                    child: Builder(builder: (BuildContext context) {
                      return GLMenuBackGround(child: _MenuItems(items));
                    })),
              ),
            )
          : AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: (show) ? 1.0 : 0,
              child: Builder(builder: (BuildContext context) {
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
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
      child: child,
      width: 350,
      height: 70,
      decoration: BoxDecoration(
          color: currentTheme.cardColor,
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
    final intemSelected = Provider.of<MenuModel>(context).currentPage;
    final authBloc = Provider.of<AuthenticationBLoC>(context);

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return GestureDetector(
      onTap: () {
        if (authBloc.storeAuth.user.uid != "0")
          Provider.of<MenuModel>(context, listen: false).currentPage = index;
        item.onPressed();
      },
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 900),
        child: Icon(
          item.icon,
          size: (intemSelected == index) ? 35 : 30,
          color:
              (intemSelected == index) ? currentTheme.accentColor : Colors.grey,
        ),
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  int _itemSelected = 0;

  int get itemSelected => this._itemSelected;

  set itemSelected(int index) {
    this._itemSelected = index;
    notifyListeners();
  }
}
