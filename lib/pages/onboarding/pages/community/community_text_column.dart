import 'package:flutter/material.dart';

import '../../widgets/text_column.dart';

class CommunityTextColumn extends StatelessWidget {
  CommunityTextColumn({this.text, this.title});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: title,
      text: text,
    );
  }
}
