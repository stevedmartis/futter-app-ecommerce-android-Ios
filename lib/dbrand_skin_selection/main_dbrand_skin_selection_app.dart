import 'package:flutter/material.dart';
import 'dbrand_skin_selection.dart';

class MainDbrandSkinSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: DbrandSkinSelection(),
    );
  }
}
