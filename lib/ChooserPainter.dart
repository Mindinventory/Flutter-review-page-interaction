import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ChooserPainter extends CustomPainter {

  int slideValue = 200;

  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.red.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  static final Gradient badGradient = new LinearGradient(
    colors: <Color>[
      Color(0xFFfe0944),
      Color(0xFFfeae96),
    ],
  );

  static final Gradient ughGradient = new LinearGradient(
    colors: <Color>[
      Color(0xFFF9D976),
      Color(0xfff39f86),
    ],
  );

  static final Gradient okGradient = new LinearGradient(
    colors: <Color>[
      Color(0xFF21e1fa),
      Color(0xff3bb8fd),
    ],
  );

  static final Gradient goodGradient = new LinearGradient(
    colors: <Color>[
      Color(0xFF3ee98a),
      Color(0xFF41f7c7),
    ],
  );

  Paint badPaint;
  Paint ughPaint;
  Paint okPaint;
  Paint goodPaint;

  final whitePaint = new Paint()
    ..color = Colors.white //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  ChooserPainter(int slideValue) : slideValue = slideValue;

  @override
  void paint(Canvas canvas, Size size) {
    var mainRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    canvas.drawRect(mainRect, debugPaint);

    var center = 270.0;
    var angle = 50.0;

    var minSize = size.width*1.8;

    var xoffSet = (size.width-minSize)/2;
    var yOffSet = 0.0;//(size.height-minSize)/2;

    var angleInRadians = degreeToRadians(angle);

    var centerItemAngle = degreeToRadians(center-(angle/2));
    var leftItemAngle = centerItemAngle - degreeToRadians(angle);
    var rightItemAngle = centerItemAngle + degreeToRadians(angle);



    ughPaint = new Paint()
      ..style = PaintingStyle.fill
      ..shader = ughGradient.createShader(mainRect);
    canvas.drawArc(Rect.fromLTRB(xoffSet, yOffSet, xoffSet+minSize, yOffSet+minSize), leftItemAngle, angleInRadians, true, ughPaint);

    okPaint = new Paint()
      ..style = PaintingStyle.fill
      ..shader = okGradient.createShader(mainRect);
    canvas.drawArc(Rect.fromLTRB(xoffSet, yOffSet, xoffSet+minSize, yOffSet+minSize), centerItemAngle, angleInRadians, true, okPaint);

    goodPaint = new Paint()
      ..style = PaintingStyle.fill
      ..shader = goodGradient.createShader(mainRect);

    canvas.drawArc(Rect.fromLTRB(xoffSet, yOffSet, xoffSet+minSize, yOffSet+minSize), rightItemAngle, angleInRadians, true, goodPaint);


    //draw bottom white   part
    canvas.drawArc(Rect.fromLTRB(xoffSet+(minSize/4), yOffSet+(minSize/4), xoffSet+(minSize*3/4), yOffSet+(minSize*3/4)), leftItemAngle, angleInRadians*3, true, whitePaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static double degreeToRadians(double degree){
      return degree * (PI / 180);
  }
}