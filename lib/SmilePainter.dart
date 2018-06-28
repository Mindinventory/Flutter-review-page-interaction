import 'dart:ui';

import 'package:flutter/material.dart';

class SmilePainter extends CustomPainter {
  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.grey.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  int slideValue = 200;

  ReviewState badReview;
  ReviewState ughReview;
  ReviewState okReview;
  ReviewState goodReview;

  SmilePainter(int slideValue) : slideValue = slideValue;

  Size lastSize;

  ReviewState currentState;

  @override
  void paint(Canvas canvas, Size size) {
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;

    var radius = 0.0;
    var eyeRadius = 10.0;
    if (size.height < size.width) {
      radius = halfHeight - 16.0;
    } else {
      radius = halfWidth - 16.0;
    }
    eyeRadius = radius / 6.5;

    final diameter = radius * 2;
    //left top corner
    final startingX = halfWidth - radius;
    final startingY = halfHeight - radius;

    final oneThirdOfDia = (diameter / 3);
    final oneThirdOfDiaByTwo = oneThirdOfDia / 2;

    //bottom right corner
    final endingX = halfWidth + radius;
    final endingY = halfHeight + radius;

    if (size != lastSize) {
      lastSize = size;

      final leftSmileX = startingX + (radius / 2);

      badReview = ReviewState(
        Offset(leftSmileX, endingY - (oneThirdOfDiaByTwo * 1.5)),
        Offset(startingX + oneThirdOfDia,
            startingY + radius + (oneThirdOfDiaByTwo)),
        Offset(endingX - radius, startingY + radius + (oneThirdOfDiaByTwo)),
        Offset(
            endingX - oneThirdOfDia, startingY + radius + (oneThirdOfDiaByTwo)),
        Offset(endingX - (radius / 2), endingY - (oneThirdOfDiaByTwo * 1.5)),
        Color(0xFFfe0944),
        Color(0xFFfeae96),
      );

      ughReview = ReviewState(
        Offset(leftSmileX, endingY - (radius / 2)),
        Offset(diameter, endingY - oneThirdOfDia),
        Offset(endingX - radius, endingY - oneThirdOfDia),
        Offset(endingX - (radius / 2), endingY - oneThirdOfDia),
        Offset(endingX - (radius / 2), endingY - oneThirdOfDia),
        Color(0xFFF9D976),
        Color(0xfff39f86),
      );

      okReview = ReviewState(
        Offset(leftSmileX, endingY - (oneThirdOfDiaByTwo * 2)),
        Offset(diameter, endingY - oneThirdOfDia),
        Offset(endingX - radius, endingY - oneThirdOfDia),
        Offset(startingX + radius, endingY - (oneThirdOfDiaByTwo * 2)),
        Offset(endingX - (radius / 2), endingY - (oneThirdOfDiaByTwo * 2)),
        Color(0xFF21e1fa),
        Color(0xff3bb8fd),
      );

      goodReview = ReviewState(
        Offset(startingX + (radius / 2), endingY - (oneThirdOfDiaByTwo * 2)),
        Offset(startingX + oneThirdOfDia,
            startingY + (diameter - oneThirdOfDiaByTwo)),
        Offset(endingX - radius, startingY + (diameter - oneThirdOfDiaByTwo)),
        Offset(endingX - oneThirdOfDia,
            startingY + (diameter - oneThirdOfDiaByTwo)),
        Offset(endingX - (radius / 2), endingY - (oneThirdOfDiaByTwo * 2)),
        Color(0xFF3ee98a),
        Color(0xFF41f7c7),
      );
    }

//    currentState = ReviewState.tween(okReview, goodReview, slideValue / 100);
//    currentState = goodReview;
    if(slideValue<=100){
      currentState = ReviewState.tween(badReview, ughReview, slideValue/100);
    }else if(slideValue<=200){
      currentState = ReviewState.tween(ughReview, okReview, (slideValue-100)/100);
    }else if(slideValue<=300){
      currentState = ReviewState.tween(okReview, goodReview, (slideValue-200)/100);
    }else if(slideValue<=400){
      currentState = ReviewState.tween(goodReview, badReview, (slideValue-300)/100);
    }

    //draw the outer circle------------------------------------------

    final centerPoint = Offset(halfWidth, halfHeight);
    final circlePaint = genGradientPaint(
      new Rect.fromCircle(
        center: centerPoint,
        radius: radius,
      ),
      currentState.startColor,
      currentState.endColor,
      PaintingStyle.stroke,
    )..strokeCap = StrokeCap.round;

    canvas.drawCircle(centerPoint, radius, circlePaint);
    //---------------------------------------------------------------

    //draw curve with path ------------------------------------------
    canvas.drawPath(getSmilePath(currentState), circlePaint);

    //---------------------------------------------------------------

    //drawing stuff for debugging-----------------------------------

//    canvas.drawRect(
//        Rect.fromLTRB(0.0, 0.0, size.width, size.height), debugPaint);
//    canvas.drawRect(
//        Rect.fromLTRB(startingX, startingY, endingX, endingY), debugPaint);
//
//    canvas.drawLine(
//        Offset(startingX, startingY), Offset(endingX, endingY), debugPaint);
//    canvas.drawLine(
//        Offset(endingX, startingY), Offset(startingX, endingY), debugPaint);
//    canvas.drawLine(Offset(startingX + radius, startingY),
//        Offset(startingX + radius, endingY), debugPaint);
//    canvas.drawLine(Offset(startingX, startingY + radius),
//        Offset(endingX, startingY + radius), debugPaint);
//
//    //horizontal lines
//    canvas.drawLine(Offset(startingX, startingY + oneThirdOfDia),
//        Offset(endingX, startingY + oneThirdOfDia), debugPaint);
//    canvas.drawLine(Offset(startingX, endingY - oneThirdOfDia),
//        Offset(endingX, endingY - oneThirdOfDia), debugPaint);
//    canvas.drawLine(Offset(startingX, endingY - oneThirdOfDiaByTwo),
//        Offset(endingX, endingY - oneThirdOfDiaByTwo), debugPaint);
//
//    //vertical lines
//    canvas.drawLine(Offset(startingX + oneThirdOfDiaByTwo, startingY),
//        Offset(startingX + oneThirdOfDiaByTwo, endingY), debugPaint);
//    canvas.drawLine(Offset(startingX + oneThirdOfDia, startingY),
//        Offset(startingX + oneThirdOfDia, endingY), debugPaint);
//    canvas.drawLine(Offset(endingX - oneThirdOfDia, startingY),
//        Offset(endingX - oneThirdOfDia, endingY), debugPaint);
//    canvas.drawLine(Offset(endingX - oneThirdOfDiaByTwo, startingY),
//        Offset(endingX - oneThirdOfDiaByTwo, endingY), debugPaint);
//    canvas.drawRect(Rect.fromLTRB(leftSmileX, smileY, rightSmileX, smileBottomY), boxPaint ..color=Colors.red);
    //---------------------------------------------------------------

    //draw eyes---------------------------------------------------
    //ele calc
    final leftEyeX = startingX + oneThirdOfDia;
    final eyeY = startingY + (oneThirdOfDia + oneThirdOfDiaByTwo / 4);
    final rightEyeX = startingX + (oneThirdOfDia * 2);

    final leftEyePoint = Offset(leftEyeX, eyeY);
    final rightEyePoint = Offset(rightEyeX, eyeY);

    final Paint leftEyePaintFill = genGradientPaint(
      new Rect.fromCircle(center: leftEyePoint, radius: eyeRadius),
      currentState.startColor,
      currentState.endColor,
      PaintingStyle.fill,
    );

    final Paint rightEyePaintFill = genGradientPaint(
      new Rect.fromCircle(center: rightEyePoint, radius: eyeRadius),
      currentState.startColor,
      currentState.endColor,
      PaintingStyle.fill,
    );

//    var eyeRadiusbythree = eyeRadius/3;
//
//    Path clipPath = new Path();
//    clipPath.moveTo(leftEyeX-eyeRadiusbythree, eyeY-(eyeRadiusbythree*2));

//    canvas.save();
//    canvas.clipPath(path)
//    canvas.clipRect(Rect.fromLTRB(leftEyeX-eyeRadius, eyeY, leftEyeX+(eyeRadius*2), eyeY + eyeRadius));
    canvas.drawCircle(leftEyePoint, eyeRadius, leftEyePaintFill);
//    canvas.restore();
    canvas.drawCircle(rightEyePoint, eyeRadius, rightEyePaintFill);

    //---------------------------------------------------------------

  }

  Path getSmilePath(ReviewState state) {
    var smilePath = Path();
    smilePath.moveTo(state.leftOffset.dx, state.leftOffset.dy);
    smilePath.quadraticBezierTo(state.leftHandle.dx, state.leftHandle.dy,
        state.centerOffset.dx, state.centerOffset.dy);
    smilePath.quadraticBezierTo(state.rightHandle.dx, state.rightHandle.dy,
        state.rightOffset.dx, state.rightOffset.dy);
    return smilePath;
  }

  Paint genGradientPaint(
      Rect rect, Color startColor, Color endColor, PaintingStyle style) {
    final Gradient gradient = new LinearGradient(
      colors: <Color>[
        startColor,
        endColor,
      ],
    );

    return new Paint()
      ..strokeWidth = 10.0
      ..style = style
      ..shader = gradient.createShader(rect);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ReviewState {

  //smile points
  Offset leftOffset;
  Offset centerOffset;
  Offset rightOffset;

  Offset leftHandle;
  Offset rightHandle;


  Color startColor;
  Color endColor;

  ReviewState(this.leftOffset, this.leftHandle, this.centerOffset,
      this.rightHandle, this.rightOffset, this.startColor, this.endColor);

  static ReviewState tween(ReviewState start, ReviewState end, double ratio) {
    var startColor = Color.lerp(start.startColor, end.startColor, ratio);
    var endColor = Color.lerp(start.endColor, end.endColor, ratio);

    return ReviewState(
      Offset(
        lerpDouble(start.leftOffset.dx, end.leftOffset.dx, ratio),
        lerpDouble(start.leftOffset.dy, end.leftOffset.dy, ratio),
      ),
      Offset(
        lerpDouble(start.leftHandle.dx, end.leftHandle.dx, ratio),
        lerpDouble(start.leftHandle.dy, end.leftHandle.dy, ratio),
      ),
      Offset(
        lerpDouble(start.centerOffset.dx, end.centerOffset.dx, ratio),
        lerpDouble(start.centerOffset.dy, end.centerOffset.dy, ratio),
      ),
      Offset(
        lerpDouble(start.rightHandle.dx, end.rightHandle.dx, ratio),
        lerpDouble(start.rightHandle.dy, end.rightHandle.dy, ratio),
      ),
      Offset(
        lerpDouble(start.rightOffset.dx, end.rightOffset.dx, ratio),
        lerpDouble(start.rightOffset.dy, end.rightOffset.dy, ratio),
      ),
      startColor,
      endColor,
    );
  }
}
