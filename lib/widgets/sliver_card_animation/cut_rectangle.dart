import 'package:flutter/material.dart';

class CutRectangle extends CustomPainter {
  final Animation<Color> _color;

  CutRectangle(
      Animation<double> animation, this.scaffoldColor, this.colorPalette)
      : _color = ColorTween(begin: scaffoldColor, end: colorPalette)
            .animate(animation),
        super(repaint: animation);

  final Color colorPalette;
  final Color scaffoldColor;
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = _color.value;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 10;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.27, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
