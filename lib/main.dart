import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_diegoveloper_challenges/android_messages_animation/main_android_messages_animation_app.dart';
import 'package:youtube_diegoveloper_challenges/batman_sign_up/main_batman_sign_up_app.dart';
import 'package:youtube_diegoveloper_challenges/data_backup_animation/main_data_backup_animation.dart';
import 'package:youtube_diegoveloper_challenges/dbrand_skin_selection/main_dbrand_skin_selection_app.dart';
import 'package:youtube_diegoveloper_challenges/grocery_store/main_grocery_store.dart';
import 'package:youtube_diegoveloper_challenges/multiple_card_flow/main_multiple_card_flow.dart';
import 'package:youtube_diegoveloper_challenges/nike_shoes_store/main_nike_shoes_store.dart';
import 'package:youtube_diegoveloper_challenges/pizza_order/main_pizza_order.dart';
import 'package:youtube_diegoveloper_challenges/profile_store.dart/main_profile_store.dart';
import 'package:youtube_diegoveloper_challenges/store_product_concept/main_store_product_concept_app.dart';
import 'package:youtube_diegoveloper_challenges/travel_photos/main_travel_photos.dart';
import 'package:youtube_diegoveloper_challenges/vinyl_disc/main_vinyl_disc_app.dart';

import 'grocery_store/myhome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _onPressed(BuildContext context, Widget child) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => child),
    );
  }

  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(height: 20);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Diegoveloper Challenges'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(40.0),
        children: <Widget>[
          separator,
          ElevatedButton(
            child: Text('Flight App Concept'),
            onPressed: () => _onPressed(
              context,
              MyHomePage1(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Nike Shoes Store Concept'),
            onPressed: () => _onPressed(
              context,
              MainNikeShoesStoreApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Profile store'),
            onPressed: () => _onPressed(
              context,
              MainProfileStoreApp(),
            ),
          ),
          ElevatedButton(
            child: Text('Vinyl Disc Concept'),
            onPressed: () => _onPressed(
              context,
              MainVinylDiscApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Dbrand Color selection'),
            onPressed: () => _onPressed(
              context,
              MainDbrandSkinSelectionApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Multiple Card Flow'),
            onPressed: () => _onPressed(
              context,
              MainMultipleCardFlowApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Travel Photos'),
            onPressed: () => _onPressed(
              context,
              MainTravelPhotosApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Grocery Products'),
            onPressed: () => _onPressed(
              context,
              MainGroceryStoreApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Data Backup Animation'),
            onPressed: () => _onPressed(
              context,
              MainDataBackupAnimationApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Batman SignUp'),
            onPressed: () => _onPressed(
              context,
              MainBatmanSignUpApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Rappi Concept'),
            onPressed: () => _onPressed(
              context,
              MainRappiConceptApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Android Messages Animation'),
            onPressed: () => _onPressed(
              context,
              MainAndroidMessagesAnimationApp(),
            ),
          ),
          separator,
          ElevatedButton(
            child: Text('Pizza Order'),
            onPressed: () => _onPressed(
              context,
              MainPizzaOrderApp(),
            ),
          ),
        ],
      ),
    );
  }
}
