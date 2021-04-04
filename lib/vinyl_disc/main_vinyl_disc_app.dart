import 'package:flutter/material.dart';
import 'vinyl_disc_home.dart';

class MainVinylDiscApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: VinylDiscHome(),
    );
  }
}
