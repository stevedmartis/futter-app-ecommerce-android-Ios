import 'package:freeily/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class NextPageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int currentPage;

  const NextPageButton({@required this.onPressed, this.currentPage});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return RawMaterialButton(
      padding: const EdgeInsets.all(kPaddingM),
      elevation: 3.0,
      shape: const CircleBorder(),
      fillColor: Colors.black,
      onPressed: onPressed,
      child: Icon(
        Icons.chevron_right,
        color: currentTheme.primaryColor,
        size: 32.0,
      ),
    );
  }
}
