import 'package:flutter/material.dart';

import '../../../constants.dart';

class NextPageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int currentPage;

  const NextPageButton({@required this.onPressed, this.currentPage});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: const EdgeInsets.all(kPaddingM),
      elevation: 3.0,
      shape: const CircleBorder(),
      fillColor: Color(0xFF131313),
      onPressed: onPressed,
      child: Icon(
        Icons.chevron_right,
        color: Colors.orange,
        size: 32.0,
      ),
    );
  }
}
