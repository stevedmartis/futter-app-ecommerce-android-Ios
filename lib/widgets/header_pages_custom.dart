import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/models/user.dart';
import 'package:australti_ecommerce_app/pages/search_home_page.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBarHeaderPages extends StatefulWidget {
  final bool showContent;
  final String title;
  final bool isAdd;
  final bool leading;
  final bool showTitle;

  final Widget action;

  final VoidCallback onPress;

  @override
  CustomAppBarHeaderPages(
      {this.showContent = false,
      @required this.title,
      this.action,
      this.leading = false,
      this.isAdd = false,
      this.onPress,
      this.showTitle});

  @override
  _CustomAppBarHeaderState createState() => _CustomAppBarHeaderState();
}

class _CustomAppBarHeaderState extends State<CustomAppBarHeaderPages> {
  @override
  void initState() {
    super.initState();
  }

  Store storeAuth;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationBLoC>(context);

    final currentTheme = Provider.of<ThemeChanger>(context);

    final profile = authService.profile;

    // final size = MediaQuery.of(context).size;

    storeAuth = authService.storeAuth;

    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          (widget.leading)
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: currentTheme.currentTheme.cardColor),
                  child: Row(
                    children: [
                      Material(
                        color: currentTheme.currentTheme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          splashColor: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          radius: 30,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          highlightColor: Colors.grey,
                          child: Container(
                            width: 34,
                            height: 34,
                            child: Icon(
                              Icons.chevron_left,
                              color: currentTheme.currentTheme.accentColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    {
                      if (storeAuth.user.uid == '0') {
                        authService.redirect = 'profile';
                        Navigator.push(context, loginRoute(0));
                      } else {
                        Navigator.push(context, profileAuthRoute(true));
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 7, bottom: 10),
                    child: Hero(
                      tag: 'user_auth_avatar-header',
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(
                                      currentProfile.imageAvatar)))),
                    ),
                  ),
                ),
          Expanded(
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: (widget.showTitle) ? 1.0 : 0.0,
                child: Container(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: (currentTheme.customTheme)
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),
          (widget.showContent)
              ? GestureDetector(
                  onTap: () => showSearch(
                      context: context,
                      delegate: DataSearch(userAuth: profile)),
                  child: Center(child: MyTextField(true)),
                )
              : Container(),
          if (widget.isAdd)
            Container(
              padding: EdgeInsets.only(right: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: currentTheme.currentTheme.cardColor),
              child: Row(
                children: [
                  Material(
                    color: currentTheme.currentTheme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      splashColor: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                      radius: 30,
                      onTap: () => widget.onPress(),
                      highlightColor: Colors.grey,
                      child: Container(
                        width: 34,
                        height: 34,
                        child: Icon(
                          Icons.add,
                          color: currentTheme.currentTheme.accentColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: 10,
          )

          /*  (widget.isPlantOrigen)
              ? IconButton(
                  onPressed: () {
                    //   Navigator.push(context, _createRouteMessages());
                  },
                  icon: Stack(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.commentDots,
                        color: currentTheme.currentTheme.primaryColor,
                        size: 30,
                      ),
                      (number > 0)
                          ? Positioned(
                              top: 0.0,
                              right: 4.0,
                              child: BounceInDown(
                                from: 10,
                                animate: (number > 0) ? true : false,
                                child: Bounce(
                                  delay: Duration(seconds: 2),
                                  from: 15,
                                  controller: (controller) =>
                                      Provider.of<NotificationModel>(context)
                                          .bounceController = controller,
                                  child: Container(
                                    child: Text(
                                      '$number',
                                      style: TextStyle(
                                          color: (currentTheme.customTheme)
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: (currentTheme.customTheme)
                                            ? currentTheme
                                                .currentTheme.accentColor
                                            : Colors.black,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ))
              : Container(), */
        ],
      ),
    );
  }
}

/* Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-0.5, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
} */

/* Route _createRouteMessages() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MessagesPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
} */

class CustomSliverAppBarHeader extends StatelessWidget {
  CustomSliverAppBarHeader({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 30),
              width: size.height / 3,
              height: 40,
              decoration: BoxDecoration(
                color: currentTheme.scaffoldBackgroundColor.withOpacity(0.90),
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      spreadRadius: -5,
                      blurRadius: 10,
                      offset: Offset(0, 5))
                ],
              ),
              child: SearchContent()),
          Container(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.more_vert,
                size: 25,
                color: currentTheme.accentColor,
              )),
        ],
      ),
    );
  }
}

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final color = Colors.white.withOpacity(0.60);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search,
                color: (currentTheme.customTheme) ? color : Colors.black),
            SizedBox(width: 20),
            Container(
                // margin: EdgeInsets.only(top: 0, left: 0),
                child: Text('Buscar',
                    style: TextStyle(
                        color:
                            (currentTheme.customTheme) ? color : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class CustomAppBarIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                  //globalKey.currentState.openEndDrawer();
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                  //globalKey.currentState.openEndDrawer();
                },
              ),
            ],
          )),
    );
  }
}
