import 'package:australti_ecommerce_app/android_messages_animation/main_android_messages_animation_app.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_home.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/multiple_card_flow/multiple_card_flow.dart';
import 'package:australti_ecommerce_app/pages/categories_store.dart';
import 'package:australti_ecommerce_app/pages/confirm_location.dart';
import 'package:australti_ecommerce_app/pages/discovery_demo.dart';
import 'package:australti_ecommerce_app/pages/loading_page.dart';
import 'package:australti_ecommerce_app/pages/login/login.dart';
import 'package:australti_ecommerce_app/pages/onboarding/onboarding.dart';
import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
import 'package:australti_ecommerce_app/pages/profile_edit.dart';
import 'package:australti_ecommerce_app/pages/orden_detail_page.dart';
import 'package:australti_ecommerce_app/pages/products_list.dart';
import 'package:australti_ecommerce_app/pages/search_principal_page.dart';
import 'package:australti_ecommerce_app/pages/single_image_upload.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile_store_auth.dart';
import 'package:australti_ecommerce_app/store_principal/main_store_principal.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (_) => LoadingPage(),
  'login': (_) => Login(
        screenHeight: 300,
      ),
  'vender': (_) => CatalogosListPage(),
};

final pageRouter = <_Route>[
  _Route(Icons.play_arrow, 'flow', MainStoreServicesApp()),
  _Route(Icons.play_arrow, 'loading', LoadingPage()),
  _Route(Icons.play_arrow, 'store', CatalogosListPage()),
  _Route(Icons.play_arrow, 'message', MainAndroidMessagesAnimationApp()),
  _Route(Icons.play_arrow, 'notifications', MultipleCardFlow()),
  _Route(Icons.play_arrow, 'loading', LoadingPage()),
];

class _Route {
  final IconData icon;
  final String title;
  final Widget page;

  _Route(this.icon, this.title, this.page);
}

Route loginRoute(double screenHeight) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Login(
      screenHeight: screenHeight,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route profileEditRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EditProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.1, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route profileAuthRoute(isAuthUser) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfileStoreAuth(
      isAuthUser: isAuthUser,
    ),
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
}

Route profileCartRoute(Store store) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        GroceryStoreHome(store),
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
}

Route groceryListRoute(ProfileStoreCategory category, bloc) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ProductsByCategoryStorePage(
      category: category,
      bloc: bloc,
    ),
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
}

Route singleUploadImageRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SingleImageUpload(),
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
}

Route ordenDetailImageRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => OrdenDetailPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 0.1);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route confirmLocationImageRoute(PlaceSearch place) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ConfirmLocationPage(place),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.2, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route principalHomeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PrincipalPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.2, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route categoriesRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CatalogosListPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.2, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route discoveryRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        FeatureDiscoveryDemoApp(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.2, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route onBoardCreateStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Onboarding(
        screenHeight: screenHeight,
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route createRouteSearch() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SearchPrincipalPage(),
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
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
