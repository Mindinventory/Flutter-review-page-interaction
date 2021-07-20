import 'dart:math';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'arc_chooser.dart';
import '../common/app_color.dart';
import 'package:review/model/arc_item_model.dart';

// draw the arc and other stuff
class ChooserPainter extends CustomPainter {
  //debugging Paint
  final debugPaint = Paint()
    ..color = Colors.red.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final linePaint = Paint()
    ..color = Colors.black.withAlpha(65) //0xFFF9D976
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square;

  final whitePaint = Paint()
    ..color = AppColors.white //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  bool isLineSelected = true;
  bool shouldTransparent = false;

  List<ArcItemModel> arcItems;
  double angleInRadians,
      angleInRadiansByTwo,
      angleInRadians1,
      angleInRadians2,
      angleInRadians3,
      angleInRadians4;

  ChooserPainter(
      {List<ArcItemModel> arcItems,
      double angleInRadians,
      bool isLine,
      @required bool shouldTransparent}) {
    this.arcItems = arcItems;
    this.angleInRadians = angleInRadians;
    this.angleInRadiansByTwo = angleInRadians / 2;
    this.isLineSelected = isLine;
    this.shouldTransparent = shouldTransparent;

    angleInRadians1 = angleInRadians / 6;
    angleInRadians2 = angleInRadians / 3;
    angleInRadians3 = angleInRadians * 4 / 6;
    angleInRadians4 = angleInRadians * 5 / 6;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //common calc
    double centerX = size.width / 2;
    double centerY = size.height * 1.6;
    Offset center = Offset(centerX, centerY);
    double radius = sqrt((size.width * size.width) / 2);

    //var mainRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    //canvas.drawRect(mainRect, debugPaint);

    //for white arc at bottom
    double leftX = centerX - radius;
    double topY = centerY - radius;
    double rightX = centerX + radius;
    double bottomY = centerY + radius;

    //for items
    double radiusItems = radius * 1.5;
    double leftX2 = centerX - radiusItems;
    double topY2 = centerY - radiusItems;
    double rightX2 = centerX + radiusItems;
    double bottomY2 = centerY + radiusItems;

    //for shadow
    double radiusShadow = radius * 1.13;
    double leftX3 = centerX - radiusShadow;
    double topY3 = centerY - radiusShadow;
    double rightX3 = centerX + radiusShadow;
    double bottomY3 = centerY + radiusShadow;

    double radiusText = radius * 1.30;
    double radius4 = radius * 1.12;
    double radius5 = radius * 1.06;
    var arcRect = Rect.fromLTRB(leftX2, topY2, rightX2, bottomY2);

    var dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    canvas.clipRect(dummyRect, clipOp: ClipOp.intersect);

    void _drawLines(int i) {
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

    for (int i = 0; i < arcItems.length; i++) {
      canvas.drawArc(
          arcRect,
          arcItems[i].startAngle,
          angleInRadians,
          true,
          Paint()
            ..style = PaintingStyle.fill
            ..shader = LinearGradient(
              colors: arcItems[i].colors,
            ).createShader(dummyRect));

      //Draw text
      TextSpan span = TextSpan(
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 32.0, color: AppColors.white),
          text: arcItems[i].text);
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

      isLineSelected ? _drawLines(i) : Container();
    }

    ///shadow
    // If reducing arc width then apply the same here to show the shadow accordingly
    if (!shouldTransparent) {
      Path shadowPath = Path();
      shadowPath.addArc(Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
          ChooserState.degreeToRadians(180.0),
          ChooserState.degreeToRadians(180.0));
      canvas.drawShadow(shadowPath, AppColors.black, 18.0, true);
    }

    ///bottom white arc
    // Reduce leftX(-50) and topY(-50), and increase rightX(+50) to decrease the width of arc
    if (!shouldTransparent) {
      canvas.drawArc(Rect.fromLTRB(leftX, topY, rightX, bottomY), ChooserState.degreeToRadians(180.0),
          ChooserState.degreeToRadians(180.0), true, whitePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
