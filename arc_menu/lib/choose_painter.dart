import 'dart:math';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'arc_item_model.dart';
import 'extensions.dart';

/// Draws the arc chooser
class ChooserPainter extends CustomPainter {
  //debugging Paint
  static final debugPaint = Paint()
    ..color = Colors.red.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  static final linePaint = Paint()
    ..color = Colors.white//Colors.black.withAlpha(65) //0xFFF9D976
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke
    ..blendMode = BlendMode.clear
    ..strokeCap = StrokeCap.square;

  static final whitePaint = Paint()
    ..color = Colors.white //0xFFF9D976
    ..strokeWidth = 1.0
    ..blendMode = BlendMode.clear
    ..style = PaintingStyle.fill;

  static final double halfCircleRadian = 180.0.degreeToRadians();

  bool drawGuageLines = true;
  bool shouldTransparent;

  List<DrawingArc> arcItems;
  double angleInRadians,
      angleInRadiansByTwo,
      angleInRadians1,
      angleInRadians2,
      angleInRadians3,
      angleInRadians4;

  ChooserPainter(
      {@required this.arcItems,
      @required this.angleInRadians,
      bool drawGuageLines = true,
      this.shouldTransparent = false}) {

    this.angleInRadians = angleInRadians;
    this.angleInRadiansByTwo = angleInRadians / 2;

    angleInRadians1 = angleInRadians / 6;
    angleInRadians2 = angleInRadians / 3;
    angleInRadians3 = angleInRadians * 4 / 6;
    angleInRadians4 = angleInRadians * 5 / 6;
  }

  Size lastSize;

  //common calc
  double centerX;
  double centerY;
  Offset center ;
  double radius;

  var mainRect;

  //for white arc at bottom
  double leftX;
  double topY;
  double rightX;
  double bottomY;

  //for items
  double radiusItems;
  double leftX2;
  double topY2;
  double rightX2;
  double bottomY2;

  //for shadow
  double radiusShadow;
  double leftX3;
  double topY3;
  double rightX3;
  double bottomY3;

  double radiusText;
  double radius4;
  double radius5;
  var arcRect;

  var dummyRect;

  void calculations(Size size){

    if(size == lastSize)return;
    else lastSize = size;

    //common calc
    centerX = size.width / 2;
    centerY = size.height * 1.6;
    center = Offset(centerX, centerY);
    radius = sqrt((size.width * size.height) / 2);

    mainRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    //for white arc at bottom
    leftX = centerX - radius;
    topY = centerY - radius;
    rightX = centerX + radius;
    bottomY = centerY + radius;

    //for items
    radiusItems = radius * 1.5;
    leftX2 = centerX - radiusItems;
    topY2 = centerY - radiusItems;
    rightX2 = centerX + radiusItems;
    bottomY2 = centerY + radiusItems;

    //for shadow
    radiusShadow = radius * 1.13;
    leftX3 = centerX - radiusShadow;
    topY3 = centerY - radiusShadow;
    rightX3 = centerX + radiusShadow;
    bottomY3 = centerY + radiusShadow;

    radiusText = radius * 1.30;
    radius4 = radius * 1.12;
    radius5 = radius * 1.06;
    arcRect = Rect.fromLTRB(leftX2, topY2, rightX2, bottomY2);
    dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
  }

  @override
  void paint(Canvas canvas, Size size) {

    calculations(size);

    canvas.drawRect(mainRect, debugPaint);
    canvas.clipRect(dummyRect, clipOp: ClipOp.intersect);

    canvas.saveLayer(Rect.largest, Paint());

    for (int i = 0; i < arcItems.length; i++) {
      canvas.drawArc(
          arcRect,
          arcItems[i].startAngle,
          angleInRadians,
          true,
          Paint()
            ..style = PaintingStyle.fill
            ..shader = LinearGradient(
              colors: [arcItems[i].arcItem.startColor,arcItems[i].arcItem.endColor],
            ).createShader(dummyRect));

      //Draw text
      TextSpan span = TextSpan(
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 32.0, color: Colors.white),
          text: arcItems[i].arcItem.title);
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      //find additional angle to make text in center
      double f = tp.width / 2;
      double t = sqrt((radiusText * radiusText) + (f * f));

      double additionalAngle = acos(((t * t) + (radiusText * radiusText) - (f * f)) / (2 * t * radiusText));

      double tX = center.dx +
          radiusText * cos(arcItems[i].startAngle + angleInRadiansByTwo - additionalAngle); // - (tp.width/2);
      double tY = center.dy +
          radiusText *
              sin(arcItems[i].startAngle + angleInRadiansByTwo - additionalAngle); // - (tp.height/2);

      canvas.save();
      //if reducing the arc width then reduce tY by it's half to show the text accordingly
      canvas.translate(tX, tY);
      //canvas.rotate(arcItems[i].startAngle + angleInRadiansByTwo);
      canvas.rotate(arcItems[i].startAngle + angleInRadians + angleInRadians + angleInRadiansByTwo);
      tp.paint(canvas, Offset(0.0, 0.0));
      canvas.restore();

    }

    ///shadow
    // If reducing arc width then apply the same here to show the shadow accordingly
    if (!shouldTransparent) {
      Path shadowPath = Path();
      shadowPath.addArc(Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
          halfCircleRadian,
          halfCircleRadian);
      canvas.drawShadow(shadowPath, Colors.black, 18.0, true);
    }

    // Draw guege lines
    if(drawGuageLines)
      for (int i = 0; i < arcItems.length; i++) {
        _drawLines(i,canvas, center);
      }

    ///bottom white arc
    // Reduce leftX(-50) and topY(-50), and increase rightX(+50) to decrease the width of arc
    if (!shouldTransparent) {
      canvas.drawArc(Rect.fromLTRB(leftX, topY, rightX, bottomY), halfCircleRadian,
          halfCircleRadian, true, whitePaint);
    }
    canvas.restore();
  }

  void _drawLines(int i, Canvas canvas, Offset center) {
    //big lines
    canvas.drawLine(
        Offset(center.dx + radius4 * cos(arcItems[i].startAngle),
            center.dy + radius4 * sin(arcItems[i].startAngle)),
        center,
        linePaint);

    canvas.drawLine(
        Offset(center.dx + radius4 * cos(arcItems[i].startAngle + angleInRadiansByTwo),
            center.dy + radius4 * sin(arcItems[i].startAngle + angleInRadiansByTwo)),
        center,
        linePaint);

    //small lines
    canvas.drawLine(
        Offset(center.dx + radius5 * cos(arcItems[i].startAngle + angleInRadians1),
            center.dy + radius5 * sin(arcItems[i].startAngle + angleInRadians1)),
        center,
        linePaint);

    canvas.drawLine(
        Offset(center.dx + radius5 * cos(arcItems[i].startAngle + angleInRadians2),
            center.dy + radius5 * sin(arcItems[i].startAngle + angleInRadians2)),
        center,
        linePaint);

    canvas.drawLine(
        Offset(center.dx + radius5 * cos(arcItems[i].startAngle + angleInRadians3),
            center.dy + radius5 * sin(arcItems[i].startAngle + angleInRadians3)),
        center,
        linePaint);

    canvas.drawLine(
        Offset(center.dx + radius5 * cos(arcItems[i].startAngle + angleInRadians4),
            center.dy + radius5 * sin(arcItems[i].startAngle + angleInRadians4)),
        center,
        linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
