import 'package:flutter/material.dart';
import 'nike_shoes_home.dart';

class MainNikeShoesStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: NikeShoesHome(),
    );
  }
}
