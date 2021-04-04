import 'package:flutter/material.dart';
import 'package:youtube_diegoveloper_challenges/grocery_store/grocery_store_home.dart';

class MainGroceryStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: GroceryStoreHome(),
    );
  }
}
