import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
import 'package:australti_ecommerce_app/provider/custom_provider.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_bloc.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'bloc_globals/notitification.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MenuModel()),
      ChangeNotifierProvider(create: (_) => AuthenticationBLoC()),
      ChangeNotifierProvider(create: (_) => SocketService()),
      ChangeNotifierProvider(create: (_) => ThemeChanger(3)),
      ChangeNotifierProvider(create: (_) => NotificationModel()),
      ChangeNotifierProvider(create: (_) => StoreBLoC()),
      //ChangeNotifierProvider(create: (_) => GroceryStoreBLoC()),
      //ChangeNotifierProvider(create: (_) => TabsViewScrollBLoC()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final currentTheme = Provider.of<ThemeChanger>(context);

    return CustomProvider(
      child: MaterialApp(
        theme: currentTheme.currentTheme,
        debugShowCheckedModeBanner: false,
        color: currentTheme.currentTheme.scaffoldBackgroundColor,
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
