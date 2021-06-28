import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/preferences/user_preferences.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

class PrincipalMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new AuthUserPreferences();

    final size = MediaQuery.of(context).size;

    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthenticationBLoC>(context);
    final currentTheme = Provider.of<ThemeChanger>(context);
    final profile = authService.storeAuth;

    return SafeArea(
      child: Container(
        width: size.width / 1.5,
        child: Drawer(
          child: Container(
            color: currentTheme.currentTheme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    profile.user.username,
                    style: TextStyle(
                      fontSize: 20,
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    socketService.disconnect();

                    prefs.setToken = '';
                    (UniversalPlatform.isWeb)
                        ? authService.logoutWeb()
                        : authService.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "login", (Route<dynamic> route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app,
                        color: currentTheme.currentTheme.accentColor),
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        color: (currentTheme.customTheme)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
