import 'dart:ui';

import 'package:flutter/material.dart';

class SmilePainter extends CustomPainter {
  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.grey //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final whitePaint = new Paint()
    ..color = Colors.white //0xFFF9D976
    ..style = PaintingStyle.fill;

  int slideValue = 200;

  ReviewState badReview;
  ReviewState ughReview;
  ReviewState okReview;
  ReviewState goodReview;

  double centerCenter;
  double leftCenter;
  double rightCenter;

  double smileHeight;
  double halfWidth;
  double halfHeight;

  double radius;
  double diameter;
  double startingY;
  double startingX;

  double endingX;
  double endingY;

  double oneThirdOfDia;

  double oneThirdOfDiaByTwo;

  double eyeRadius;

  double eyeRadiusbythree;

  double eyeRadiusbytwo;

  SmilePainter(int slideValue) : slideValue = slideValue;

  Size lastSize;

  ReviewState currentState;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != lastSize) {
      lastSize = size;

      smileHeight = size.width / 2;
      halfWidth = size.width / 2;
      halfHeight = smileHeight / 2;

      radius = 0.0;
      eyeRadius = 10.0;
      if (smileHeight < size.width) {
        radius = halfHeight - 16.0;
      } else {
        radius = halfWidth - 16.0;
      }
      eyeRadius = radius / 6.5;
      eyeRadiusbythree = eyeRadius/3;
      eyeRadiusbytwo = eyeRadius/2;

      diameter = radius * 2;
      //left top corner
      startingX = halfWidth - radius;
      startingY = halfHeight - radius;

      oneThirdOfDia = (diameter / 3);
      oneThirdOfDiaByTwo = oneThirdOfDia / 2;

      //bottom right corner
      endingX = halfWidth + radius;
      endingY = halfHeight + radius;

      final leftSmileX = startingX + (radius / 2);

      badReview = ReviewState(
          Offset(leftSmileX, endingY - (oneThirdOfDiaByTwo * 1.5)),
          Offset(startingX + oneThirdOfDia,
              startingY + radius + (oneThirdOfDiaByTwo)),
          Offset(endingX - radius, startingY + radius + (oneThirdOfDiaByTwo)),
          Offset(endingX - oneThirdOfDia,
              startingY + radius + (oneThirdOfDiaByTwo)),
          Offset(endingX - (radius / 2), endingY - (oneThirdOfDiaByTwo * 1.5)),
          Color(0xFFfe0944),
          Color(0xFFfeae96),
          Color(0xFFfe5c6e),
          'BAD');

      ughReview = ReviewState(
          Offset(leftSmileX, endingY - (radius / 2)),
          Offset(diameter, endingY - oneThirdOfDia),
          Offset(endingX - radius, endingY - oneThirdOfDia),
          Offset(endingX - (radius / 2), endingY - oneThirdOfDia),
          Offset(endingX - (radius / 2), endingY - oneThirdOfDia),
          Color(0xFFF9D976),
          Color(0xfff39f86),
          Color(0xFFf6bc7e),
          'UGH');

      okReview = ReviewState(
          Offset(leftSmileX, endingY - (oneThirdOfDiaByTwo * 1.5)),
          Offset(diameter, endingY - (oneThirdOfDiaByTwo * 1.5)),
          Offset(endingX - radius, endingY - (oneThirdOfDiaByTwo * 1.5)),
          Offset(startingX + radius, endingY - (oneThirdOfDiaByTwo * 1.5)),
          Offset(endingX - (radius / 2), endingY - (oneThirdOfDiaByTwo * 1.5)),
          Color(0xFF21e1fa),
          Color(0xff3bb8fd),
          Color(0xFF28cdfc),
          'OK');

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
          Color(0xFF41f7c6),
          'GOOD');

      //get max width of text, that is width of GOOD text
      TextSpan spanGood = new TextSpan(
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 52.0,
              color: okReview.titleColor),
          text: "GOOD");
      TextPainter tpGood =
          new TextPainter(text: spanGood, textDirection: TextDirection.ltr);
      tpGood.layout();
      double goodWidth = tpGood.width;
      double halfGoodWidth = goodWidth / 2;

      //center points of BIG labels
      centerCenter = halfWidth;
      leftCenter = centerCenter - goodWidth;
      rightCenter = centerCenter + goodWidth;
    }

    if (slideValue <= 100) {
      tweenText(badReview, ughReview, slideValue / 100, canvas);
    } else if (slideValue <= 200) {
      tweenText(ughReview, okReview, (slideValue - 100) / 100, canvas);
    } else if (slideValue <= 300) {
      tweenText(okReview, goodReview, (slideValue - 200) / 100, canvas);
    } else if (slideValue <= 400) {
      tweenText(goodReview, badReview, (slideValue - 300) / 100, canvas);
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

    //draw smile curve with path ------------------------------------------
    canvas.drawPath(getSmilePath(currentState), circlePaint);

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

    canvas.drawCircle(leftEyePoint, eyeRadius, leftEyePaintFill);
    canvas.drawCircle(rightEyePoint, eyeRadius, rightEyePaintFill);

    //draw the edges of BAD Review
    if (slideValue <= 100 || slideValue > 300) {

      double diff = -1.0;
      double tween = -1.0;

      if (slideValue <= 100) {
        diff = slideValue / 100;
        tween = lerpDouble(eyeY-(eyeRadiusbythree*0.6), eyeY-eyeRadius, diff);
      } else if (slideValue > 300) {
        diff = (slideValue - 300) / 100;
        tween = lerpDouble(eyeY-eyeRadius, eyeY-(eyeRadiusbythree*0.6), diff);

      }

      List<Offset> polygonPath = List<Offset>();
      polygonPath.add(Offset(leftEyeX-eyeRadiusbytwo, eyeY-eyeRadius));
      polygonPath.add(Offset(leftEyeX+eyeRadius, tween));
      polygonPath.add(Offset(leftEyeX+eyeRadius, eyeY-eyeRadius));

      Path clipPath = new Path();
      clipPath.addPolygon(polygonPath, true);

      canvas.drawPath(clipPath, whitePaint);

      List<Offset> polygonPath2 = List<Offset>();
      polygonPath2.add(Offset(rightEyeX+eyeRadiusbytwo, eyeY-eyeRadius));
      polygonPath2.add(Offset(rightEyeX-eyeRadius, tween));
      polygonPath2.add(Offset(rightEyeX-eyeRadius, eyeY-eyeRadius));

      Path clipPath2 = new Path();
      clipPath2.addPolygon(polygonPath2, true);

      canvas.drawPath(clipPath2, whitePaint);
    }

    //draw the balls of UGH Review
    if (slideValue > 0 && slideValue < 200) {

      double diff = -1.0;
      double leftTweenX = -1.0;
      double leftTweenY = -1.0;

      double rightTweenX = -1.0;
      double rightTweenY = -1.0;

      if (slideValue <= 100) {
//      bad to ugh
        diff = slideValue / 100;
        leftTweenX = lerpDouble(leftEyeX-eyeRadius, leftEyeX, diff);
        leftTweenY = lerpDouble(eyeY-eyeRadius, eyeY, diff);

        rightTweenX = lerpDouble(rightEyeX+eyeRadius, rightEyeX, diff);
        rightTweenY = lerpDouble(eyeY, eyeY-(eyeRadius+eyeRadiusbythree), diff);

      } else {
//      ugh to ok
        diff = (slideValue - 100) / 100;

        leftTweenX = lerpDouble(leftEyeX, leftEyeX-eyeRadius, diff);
        leftTweenY = lerpDouble(eyeY, eyeY-eyeRadius, diff);

        rightTweenX = lerpDouble(rightEyeX, rightEyeX+eyeRadius, diff);
        rightTweenY = lerpDouble(eyeY-(eyeRadius+eyeRadiusbythree), eyeY, diff);


      }

      canvas.drawOval(Rect.fromLTRB(leftEyeX-(eyeRadius+eyeRadiusbythree), eyeY-(eyeRadius+eyeRadiusbythree), leftTweenX, leftTweenY), whitePaint);

      canvas.drawOval(Rect.fromLTRB(rightTweenX, eyeY, rightEyeX+(eyeRadius+eyeRadiusbythree), eyeY-(eyeRadius+eyeRadiusbythree)), whitePaint);
    }


    //---------------------------------------------------------------

    //drawing stuff for debugging-----------------------------------

//    canvas.drawRect(
//        Rect.fromLTRB(0.0, 0.0, size.width, smileHeight), debugPaint);
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
    //--------------------------------------------------------------

  }

  tweenText(ReviewState centerReview, ReviewState rightReview, double diff,
      Canvas canvas) {
    currentState = ReviewState.lerp(centerReview, rightReview, diff);

    TextSpan spanCenter = new TextSpan(
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 52.0,
            color:
                centerReview.titleColor.withAlpha(255 - (255 * diff).round())),
        text: centerReview.title);
    TextPainter tpCenter =
        new TextPainter(text: spanCenter, textDirection: TextDirection.ltr);

    TextSpan spanRight = new TextSpan(
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 52.0,
            color: rightReview.titleColor.withAlpha((255 * diff).round())),
        text: rightReview.title);
    TextPainter tpRight =
        new TextPainter(text: spanRight, textDirection: TextDirection.ltr);

    tpCenter.layout();
    tpRight.layout();

    Offset centerOffset =
        new Offset(centerCenter - (tpCenter.width / 2), smileHeight);
    Offset centerToLeftOffset =
        new Offset(leftCenter - (tpCenter.width / 2), smileHeight);

    Offset rightOffset =
        new Offset(rightCenter - (tpRight.width / 2), smileHeight);
    Offset rightToCenterOffset =
        new Offset(centerCenter - (tpRight.width / 2), smileHeight);

    tpCenter.paint(canvas, Offset.lerp(centerOffset, centerToLeftOffset, diff));
    tpRight.paint(canvas, Offset.lerp(rightOffset, rightToCenterOffset, diff));
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

  String title;
  Color titleColor;

  Color startColor;
  Color endColor;

  ReviewState(
      this.leftOffset,
      this.leftHandle,
      this.centerOffset,
      this.rightHandle,
      this.rightOffset,
      this.startColor,
      this.endColor,
      this.titleColor,
      this.title);

  //create new state between given two states.
  static ReviewState lerp(ReviewState start, ReviewState end, double ratio) {
    var startColor = Color.lerp(start.startColor, end.startColor, ratio);
    var endColor = Color.lerp(start.endColor, end.endColor, ratio);

    return ReviewState(
        Offset.lerp(start.leftOffset,end.leftOffset, ratio),
        Offset.lerp(start.leftHandle, end.leftHandle, ratio),
        Offset.lerp(start.centerOffset, end.centerOffset, ratio),
        Offset.lerp(start.rightHandle, end.rightHandle, ratio),
        Offset.lerp(start.rightOffset, end.rightOffset, ratio),
        startColor,
        endColor,
        start.titleColor,
        start.title);
  }
}
