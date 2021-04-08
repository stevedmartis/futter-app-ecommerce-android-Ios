import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:australti_feriafy_app/authentication/auth_bloc.dart';
import 'package:australti_feriafy_app/bloc_globals/notitification.dart';
import 'package:australti_feriafy_app/models/profile.dart';
import 'package:australti_feriafy_app/routes/routes.dart';
import 'package:australti_feriafy_app/sockets/socket_connection.dart';
import 'package:australti_feriafy_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  SocketService socketService;
  // final notificationService = new NotificationService();
  AuthenticationBLoC authService;

  Profile profile;

  @override
  initState() {
    this.socketService = Provider.of<SocketService>(context, listen: false);

    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);

    profile = authService.profile;

    // getNotificationsActive();

    //  this.socketService.socket?.on('principal-message', _listenMessage);
    /*  this
        .socketService
        .socket
        ?.on('principal-notification', _listenNotification); */

    super.initState();
  }

/* 
  void getNotificationsActive() async {
    var notifications =
        await notificationService.getNotificationByUser(profile.user.uid);

    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;
    number = notifications.subscriptionsNotifi.length;
    notifiModel.numberNotifiBell = number;

    if (number >= 2) {
      final controller = notifiModel.bounceControllerBell;
      controller.forward(from: 0.0);
    }

    int numberMessages = notifiModel.number;
    numberMessages = notifications.messagesNotifi.length;
    notifiModel.number = numberMessages;

  }
 */
  @override
  void dispose() {
    // this.socketService.socket.off('principal-message');
    super.dispose();
  }

/*   void _listenMessage(dynamic payload) {
    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int numberMessages = notifiModel.number;
    numberMessages++;
    notifiModel.number = numberMessages;

    if (numberMessages >= 2) {
      final controller = notifiModel.bounceController;
      controller.forward(from: 0.0);
    }
  } */

  /*  void _listenNotification(dynamic payload) {
    final currentPage =
        Provider.of<MenuModel>(context, listen: false).currentPage;
    if (currentPage != 4) {
      final notifiModel =
          Provider.of<NotificationModel>(context, listen: false);
      int number = notifiModel.numberNotifiBell;
      number++;
      notifiModel.numberNotifiBell = number;

      if (number >= 2) {
        final controller = notifiModel.bounceControllerBell;
        controller.forward(from: 0.0);
      }
    }
  } */

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<MenuModel>(context).currentPage;

    final currentTheme = Provider.of<ThemeChanger>(context);
    final appTheme = Provider.of<ThemeChanger>(context);
    final authService = Provider.of<AuthenticationBLoC>(context);

    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    appTheme.customTheme = darkModeOn;

    final _onFirstPage = (currentPage == 0) ? true : false;

    return SafeArea(
        child: Scaffold(
      // endDrawer: PrincipalMenu(),
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 500),
        reverse: _onFirstPage,
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SharedAxisTransition(
            fillColor: currentTheme.currentTheme.scaffoldBackgroundColor,
            transitionType: SharedAxisTransitionType.horizontal,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pageRouter[currentPage].page,
      ),

      //CollapsingList(_hideBottomNavController),
      bottomNavigationBar:
          BottomNavigation(isVisible: authService.bottomVisible),
      // floatingActionButton: ButtomFloating(),
    ));
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    Key key,
    @required isVisible,
  })  : _isVisible = isVisible,
        super(key: key);

  final bool _isVisible;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;

      Provider.of<MenuModel>(context, listen: false).currentPage = currentIndex;

      if (currentIndex == 4) {
        Provider.of<NotificationModel>(context, listen: false)
            .numberNotifiBell = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final currentPage = Provider.of<MenuModel>(context).currentPage;
    final int number = Provider.of<NotificationModel>(context).numberNotifiBell;
    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget._isVisible ? size.height / 12 : 0.0,
      child: Wrap(
        children: <Widget>[
          BottomNavigationBar(
            currentIndex: currentPage,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
            selectedItemColor: currentTheme.currentTheme.accentColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: (currentPage == 0)
                    ? Icon(Icons.home, size: 30)
                    : Icon(Icons.home_outlined,
                        size: 30,
                        color: (currentPage == 0)
                            ? currentTheme.currentTheme.accentColor
                            : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.campaign,
                    size: (currentPage == 1) ? 35 : 35,
                    color: (currentPage == 1)
                        ? currentTheme.currentTheme.accentColor
                        : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: (currentPage == 2)
                    ? FaIcon(
                        FontAwesomeIcons.storeAlt,
                        size: 25,
                      )
                    : FaIcon(FontAwesomeIcons.store,
                        size: 25,
                        color: (currentPage == 2)
                            ? currentTheme.currentTheme.accentColor
                            : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.heart,
                    size: (currentPage == 3) ? 25 : 25,
                    color: (currentPage == 3)
                        ? currentTheme.currentTheme.accentColor
                        : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5.0, left: 10),
                        child: FaIcon(
                          (currentPage == 4)
                              ? FontAwesomeIcons.solidBell
                              : FontAwesomeIcons.bell,
                          color: (currentPage == 4)
                              ? currentTheme.currentTheme.accentColor
                              : currentTheme.currentTheme.primaryColor,
                          size: (currentPage == 4) ? 28 : 28,
                        ),
                      ),
                      (number > 0)
                          ? Container(
                              margin: EdgeInsets.only(right: 35),
                              alignment: Alignment.centerRight,
                              child: BounceInDown(
                                from: 5,
                                animate: (number > 0) ? true : false,
                                child: Bounce(
                                  delay: Duration(seconds: 2),
                                  from: 5,
                                  controller: (controller) =>
                                      Provider.of<NotificationModel>(context)
                                          .bounceControllerBell = controller,
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
                                    width: 15,
                                    height: 15,
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
                  ),
                  label: ''),
            ],
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MenuModel with ChangeNotifier {
  int _currentPage = 0;
  int _lastPage = 0;

  int get currentPage => this._currentPage;

  set currentPage(int value) {
    this._currentPage = value;
    notifyListeners();
  }

  int get lastPage => this._lastPage;

  set lastPage(int value) {
    this._lastPage = value;
    notifyListeners();
  }
}
