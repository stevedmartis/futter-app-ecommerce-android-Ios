import 'package:flutter/material.dart';
import 'multiple_card_flow.dart';

class MainMultipleCardFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: MultipleCardFlow(),
    );
  }
}
