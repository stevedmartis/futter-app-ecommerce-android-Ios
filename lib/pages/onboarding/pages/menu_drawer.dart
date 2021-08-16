import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';

import 'package:australti_ecommerce_app/routes/routes.dart';

import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../global/extension.dart';

class PrincipalMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // final socketService = Provider.of<SocketService>(context);
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
                    (profile.name != "")
                        ? 'Hola, ${profile.name.capitalize()}'
                        : 'Hola,  ${profile.name.capitalize()}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(context, ordersListRoute(false));
                  },
                  child: ListTile(
                    leading: Icon(Icons.history,
                        color: currentTheme.currentTheme.primaryColor),
                    title: Text(
                      'Mis pedidos',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                /* GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(context, myCardsRoute());
                  },
                  child: ListTile(
                    leading: Icon(Icons.payment,
                        color: currentTheme.currentTheme.accentColor),
                    title: Text(
                      'Mis tarjetas',
                      style: TextStyle(
                        color: (currentTheme.customTheme)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ), */
                SizedBox(
                  height: size.height / 1.7,
                ),
                Divider(),
                /* GestureDetector(
                  onTap: () {
                    HapticFeedback.heavyImpact();
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
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
