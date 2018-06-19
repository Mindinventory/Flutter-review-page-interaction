import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ChooserPainter extends CustomPainter {
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
    tileMode: TileMode.clamp,
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

  final whitePaint = new Paint()
    ..color = Colors.white //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  ChooserPainter(double touchAngle) {
    this.touchAngle = touchAngle;
  }

  static var center = 270.0;
  static var angle = 45.0;

  var angleInRadians = degreeToRadians(angle);

  double touchAngle;

  itemOnTop;

  @override
  void paint(Canvas canvas, Size size) {
    //common calc
    double centerX = size.width / 2;
    double centerY = size.height * 1.5;
    double radius = sqrt((size.width * size.width) / 2);


    var centerItemAngle = degreeToRadians(center - (angle / 2)) + touchAngle;

    var mainRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
//    canvas.drawRect(mainRect, debugPaint);

    //for white arc at bottom
    double leftX = centerX - radius;
    double topY = centerY - radius;
    double rightX = centerX + radius;
    double bottomY = centerY + radius;

    //for items
    double radius2 = radius * 1.5;
    double leftX2 = centerX - radius2;
    double topY2 = centerY - radius2;
    double rightX2 = centerX + radius2;
    double bottomY2 = centerY + radius2;

    //for shadow
    double radius3 = radius * 1.06;
    double leftX3 = centerX - radius3;
    double topY3 = centerY - radius3;
    double rightX3 = centerX + radius3;
    double bottomY3 = centerY + radius3;

    var arcRect = Rect.fromLTRB(leftX2, topY2, rightX2, bottomY2);

    var dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    List<Paint> paints = [
      new Paint()
        ..style = PaintingStyle.fill
        ..shader = okGradient.createShader(dummyRect),
      new Paint()
        ..style = PaintingStyle.fill
        ..shader = goodGradient.createShader(dummyRect),
      new Paint()
        ..style = PaintingStyle.fill
        ..shader = badGradient.createShader(dummyRect),
      new Paint()
        ..style = PaintingStyle.fill
        ..shader = ughGradient.createShader(dummyRect),
    ];

    for (int i = 0; i < 8; i++) {

      var startAngle = centerItemAngle + (i * angleInRadians);
      canvas.drawArc(arcRect, startAngle,
          angleInRadians, true, paints[i < 4 ? i : i - 4]);
    }

    Path shadowPath = new Path();
    shadowPath.addArc(Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
        degreeToRadians(180.0), degreeToRadians(180.0));
    canvas.drawShadow(shadowPath, Colors.black.withAlpha(220), 8.0, false);

    //bottom white arc
    canvas.drawArc(Rect.fromLTRB(leftX, topY, rightX, bottomY),
        degreeToRadians(180.0), degreeToRadians(180.0), true, whitePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  static double degreeToRadians(double degree) {
    return degree * (PI / 180);
  }
}
