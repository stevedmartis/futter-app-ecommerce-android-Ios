import 'package:flutter/material.dart';
import 'profile_store_home.dart';

class MainProfileStoreApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: ProfileStore(),
    );
  }
}
