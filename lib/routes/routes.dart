import 'package:freeily/data_backup_animation/data_backup_home.dart';
import 'package:freeily/grocery_store/grocery_store_home.dart';
import 'package:freeily/models/Address.dart';
import 'package:freeily/models/credit_Card.dart';

import 'package:freeily/models/place_Search.dart';
import 'package:freeily/models/store.dart';
import 'package:freeily/pages/account_store/bank_accoun_payment.dart';
import 'package:freeily/pages/account_store/bank_account_payments_store.dart';

import 'package:freeily/pages/account_store/category_store.dart';
import 'package:freeily/pages/account_store/contact_info_store.dart';
import 'package:freeily/pages/account_store/display_profile.dart';
import 'package:freeily/pages/account_store/edit_address_store.dart';
import 'package:freeily/pages/categories_store.dart';
import 'package:freeily/pages/confirm_location.dart';
import 'package:freeily/pages/credit_Card/card_page.dart';
import 'package:freeily/pages/credit_Card/cards_list.dart';
import 'package:freeily/pages/discovery_demo.dart';
import 'package:freeily/pages/favorite.dart';
import 'package:freeily/pages/form_current_location.dart';
import 'package:freeily/pages/get_phone/firebase/auth/phone_auth/get_phone.dart';
import 'package:freeily/pages/loading_page.dart';
import 'package:freeily/pages/login/login.dart';
import 'package:freeily/pages/notifications.dart';
import 'package:freeily/pages/onboarding/onboarding.dart';

import 'package:freeily/pages/order_progress.dart/order_page.dart';
import 'package:freeily/pages/order_progress.dart/orders_list_page.dart';
import 'package:freeily/pages/payment_method_options_page.dart';

import 'package:freeily/pages/principal_home_page.dart';
import 'package:freeily/pages/profile_edit.dart';
import 'package:freeily/pages/order_progress.dart/orden_detail_page.dart';
import 'package:freeily/pages/products_list.dart';
import 'package:freeily/pages/search_principal_page.dart';
import 'package:freeily/pages/single_image_upload.dart';
import 'package:freeily/profile_store.dart/profile_store_auth.dart';
import 'package:freeily/responses/orderStoresProduct.dart';
import 'package:freeily/responses/place_search_response.dart';
import 'package:freeily/store_principal/main_store_principal.dart';
import 'package:freeily/store_product_concept/store_product_data.dart';
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
  _Route(Icons.play_arrow, 'loading', MyFavorites()),
  _Route(Icons.play_arrow, 'store', CatalogosListPage()), //CatalogosListPage
  _Route(Icons.play_arrow, 'notifications', MyNotifications()),
];

class _Route {
  final IconData icon;
  final String title;
  final Widget page;

  _Route(this.icon, this.title, this.page);
}

Route loginRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Login(
        screenHeight: screenHeight,
      );
    },
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
      var begin = Offset(0.5, 0.0);
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

Route notificationsRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyNotifications(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(5.0, 0.0);
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

Route cardRouter(CreditCard card) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return CardDetailPage(
        creditCard: card,
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, -0.5);
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

Route dataRoute(List<Order> orders) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return DataBackupHome(orders: orders);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 0.5);
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
      var begin = Offset(0.0, 1.0);
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

Route myCardsRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CreditCardListPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.5, 0.0);
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

paymentMethodsOptionsRoute(bool orderPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        PaymentMethosOptionsPage(orderPage),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
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

Route orderDetailRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => OrdenDetailPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
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

Route ordersListRoute(bool fromOrderPage, bool isSale) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => OrderListPage(
      fromOrderPage: fromOrderPage,
      isSale: isSale,
    ),
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
  );
}

Route orderProggressRoute(Order order, bool goToPrincipal, bool isStore) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        OrderPage(order: order, goToPrincipal: goToPrincipal, isStore: isStore),
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
  );
}

Route formCurrentLocationRoute(Address address) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        FormCurrentLocationPage(address),
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

Route confirmLocationRoute(PlaceSearch place) {
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

Route locationStoreRoute(PlacesSearch place) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        LocationStorePage(place),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.5, 0.0);
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

Route selectCategoryStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return CategorySelectStore();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.5, 0.0);
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

Route bankAccountStorePayment(fromOrder) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return BankAccountStorePayment(
        fromOrder: fromOrder,
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 0.5);
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

Route selectCategoryObBoardStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return CategorySelectStore();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
/* 
Route selectCategoryObBoardStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return CategorySelectStore();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 0.5);
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

Route contactoInfoStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return ContactInfoStore();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.5, 0.0);
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

Route bankAccountStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return BankAccountStore();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.5, 0.0);
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

Route displayProfileStoreRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return DisplayProfileStore();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.5, 0.0);
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

Route createRoutePhone() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        PhoneAuthGetPhone(),
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
