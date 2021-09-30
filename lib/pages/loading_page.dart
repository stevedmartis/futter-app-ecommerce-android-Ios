import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/pages/principal_home_page.dart';

import 'package:freeily/profile_store.dart/profile_store_user.dart';
import 'package:freeily/sockets/socket_connection.dart';
import 'package:freeily/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({this.store});
  final String store;
  @override
  Widget build(BuildContext context) {
    print(store);
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context, store),
        builder: (context, snapshot) {
          return Center(
            child: buildLoadingWidget(context),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context, String store) async {
    final authService = Provider.of<AuthenticationBLoC>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();

      Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 1000),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return (store == '0')
              ? PrincipalPage()
              : ProfileStoreSelect(
                  isAuthUser: false,
                  storeUsername: store,
                );
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return Align(
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ));
    } else {
      Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return (store == '0')
              ? PrincipalPage()
              : ProfileStoreSelect(
                  isAuthUser: false,
                  storeUsername: store,
                );
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return Align(
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ));
    }
  }
}
