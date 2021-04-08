import 'package:australti_feriafy_app/authentication/auth_bloc.dart';
import 'package:australti_feriafy_app/pages/principal_home_page.dart';
import 'package:australti_feriafy_app/routes/routes.dart';
import 'package:australti_feriafy_app/sockets/socket_connection.dart';
import 'package:australti_feriafy_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:australti_feriafy_app/android_messages_animation/main_android_messages_animation_app.dart';
import 'package:australti_feriafy_app/batman_sign_up/main_batman_sign_up_app.dart';
import 'package:australti_feriafy_app/data_backup_animation/main_data_backup_animation.dart';
import 'package:australti_feriafy_app/dbrand_skin_selection/main_dbrand_skin_selection_app.dart';
import 'package:australti_feriafy_app/grocery_store/main_grocery_store.dart';
import 'package:australti_feriafy_app/multiple_card_flow/main_multiple_card_flow.dart';
import 'package:australti_feriafy_app/nike_shoes_store/main_nike_shoes_store.dart';
import 'package:australti_feriafy_app/pizza_order/main_pizza_order.dart';
import 'package:australti_feriafy_app/profile_store.dart/main_profile_store.dart';
import 'package:australti_feriafy_app/store_product_concept/main_store_product_concept_app.dart';
import 'package:australti_feriafy_app/travel_photos/main_travel_photos.dart';
import 'package:australti_feriafy_app/vinyl_disc/main_vinyl_disc_app.dart';
import 'package:provider/provider.dart';

import 'bloc_globals/notitification.dart';
import 'grocery_store/myhome.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MenuModel()),
      ChangeNotifierProvider(create: (_) => AuthenticationBLoC()),
      ChangeNotifierProvider(create: (_) => SocketService()),
      ChangeNotifierProvider(create: (_) => ThemeChanger(3)),
      ChangeNotifierProvider(create: (_) => NotificationModel()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final currentTheme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      theme: currentTheme.currentTheme,
      debugShowCheckedModeBanner: false,
      color: currentTheme.currentTheme.scaffoldBackgroundColor,
      initialRoute: 'loading',
      routes: appRoutes,
    );
  }
}
