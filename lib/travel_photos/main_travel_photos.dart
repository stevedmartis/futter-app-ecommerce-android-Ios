import 'package:flutter/material.dart';
import 'package:youtube_diegoveloper_challenges/travel_photos/travel_photos_home.dart';

class MainTravelPhotosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: TravelPhotosHome(),
    );
  }
}
