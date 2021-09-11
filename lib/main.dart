import 'package:freeily/authentication/auth_bloc.dart';
import 'package:freeily/authentication/auth_firebase.dart';
import 'package:freeily/bloc_globals/bloc/favorites_bloc.dart';
import 'package:freeily/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:freeily/pages/get_phone/providers/countries.dart';
import 'package:freeily/pages/get_phone/providers/phone_auth.dart';
import 'package:freeily/pages/principal_home_page.dart';
import 'package:freeily/preferences/user_preferences.dart';
import 'package:freeily/routes/routes.dart';
import 'package:freeily/services/bank_Service.dart';
import 'package:freeily/services/catalogo.dart';
import 'package:freeily/services/follow_service.dart';
import 'package:freeily/services/order_service.dart';
import 'package:freeily/services/product.dart';
import 'package:freeily/services/stores_Services.dart';

import 'package:freeily/sockets/socket_connection.dart';
import 'package:freeily/store_principal/store_principal_bloc.dart';
import 'package:freeily/store_product_concept/store_product_bloc.dart';
import 'package:freeily/theme/theme.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'bloc_globals/bloc/cards_services_bloc.dart';
import 'bloc_globals/bloc/notifications_bloc.dart';
import 'bloc_globals/notitification.dart';
import 'grocery_store/grocery_store_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = new AuthUserPreferences();
  await prefs.initPrefs();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MenuModel()),
    ChangeNotifierProvider(create: (_) => AuthenticationBLoC()),
    ChangeNotifierProvider(create: (_) => SocketService()),
    ChangeNotifierProvider(create: (_) => ThemeChanger(1)),
    ChangeNotifierProvider(create: (_) => NotificationModel()),
    ChangeNotifierProvider(create: (_) => StoreBLoC()),
    ChangeNotifierProvider(create: (_) => MyLocationBloc()),
    ChangeNotifierProvider(create: (_) => StoreCategoiesService()),
    ChangeNotifierProvider(create: (_) => StoreProductService()),
    ChangeNotifierProvider(create: (_) => GroceryStoreBLoC()),
    ChangeNotifierProvider(create: (_) => TabsViewScrollBLoC()),
    ChangeNotifierProvider(create: (_) => StoreService()),
    ChangeNotifierProvider(create: (_) => FireBaseAuthBLoC()),
    ChangeNotifierProvider(create: (_) => FollowService()),
    ChangeNotifierProvider(create: (_) => NotificationsBLoC()),
    ChangeNotifierProvider(
      create: (context) => CountryProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => PhoneAuthDataProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CreditCardServices(),
    ),
    ChangeNotifierProvider(create: (_) => FavoritesBLoC()),
    ChangeNotifierProvider(create: (_) => OrderService()),
    ChangeNotifierProvider(create: (_) => BankService()),
  ], child: FreeilyApp()));
}

class FreeilyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final currentTheme = Provider.of<ThemeChanger>(context);

    return FeatureDiscovery(
      recordStepsInSharedPreferences: false,
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
