import 'package:australti_feriafy_app/android_messages_animation/main_android_messages_animation_app.dart';
import 'package:australti_feriafy_app/data_backup_animation/main_data_backup_animation.dart';
import 'package:australti_feriafy_app/multiple_card_flow/multiple_card_flow.dart';
import 'package:australti_feriafy_app/nike_shoes_store/main_nike_shoes_store.dart';
import 'package:australti_feriafy_app/pages/loading_page.dart';
import 'package:australti_feriafy_app/profile_store.dart/profile_store_home.dart';
import 'package:australti_feriafy_app/travel_photos/main_travel_photos.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (_) => LoadingPage(),
  'profile': (_) => ProfileStore(),
};

final pageRouter = <_Route>[
  _Route(Icons.play_arrow, 'flow', MainTravelPhotosApp()),
  _Route(Icons.play_arrow, 'nike', MainNikeShoesStoreApp()),
  _Route(Icons.play_arrow, 'data', MainDataBackupAnimationApp()),
  _Route(Icons.play_arrow, 'message', MainAndroidMessagesAnimationApp()),
  _Route(Icons.play_arrow, 'notifications', MultipleCardFlow()),
  _Route(Icons.play_arrow, 'profile', MultipleCardFlow()),
  _Route(Icons.play_arrow, 'loading', LoadingPage()),
];

class _Route {
  final IconData icon;
  final String title;
  final Widget page;

  _Route(this.icon, this.title, this.page);
}

Route profileAuthRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfileStore(
      isAuthUser: true,
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
