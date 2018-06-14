import 'dart:ui';

import 'package:flutter/material.dart';

class ChooserPainter extends CustomPainter {

  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.grey.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0.0, 0.0, size.width, size.height), debugPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}