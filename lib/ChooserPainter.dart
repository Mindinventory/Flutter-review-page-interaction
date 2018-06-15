import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ChooserPainter extends CustomPainter {

  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.red.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0.0, 0.0, size.width, size.height), debugPaint);

    var planeSize = size.width*2;

    canvas.drawArc(Rect.fromLTRB(-planeSize/2, 0.0, planeSize,planeSize), degreeToRadians(255.0-30), degreeToRadians(30.0), true, debugPaint);
    canvas.drawArc(Rect.fromLTRB(-planeSize/2, 0.0, planeSize,planeSize), degreeToRadians(255.0), degreeToRadians(30.0), true, debugPaint);
    canvas.drawArc(Rect.fromLTRB(-planeSize/2, 0.0, planeSize,planeSize), degreeToRadians(255.0+30), degreeToRadians(30.0), true, debugPaint);

//    canvas.drawArc(Rect.fromLTRB(planeSize/4, planeSize/4, planeSize*0.75,planeSize*0.75), degreeToRadians(255.0-30), degreeToRadians(90.0), true, debugPaint);
//    canvas.drawRect(Rect.fromLTRB(planeSize/4, planeSize/4, planeSize*0.75,planeSize*0.75), debugPaint);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static double degreeToRadians(double degree){
      return degree * (PI / 180);
  }
}