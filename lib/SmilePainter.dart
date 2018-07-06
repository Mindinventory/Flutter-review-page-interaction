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
    final smileHeight = size.width / 2;
    final halfWidth = size.width / 2;
    final halfHeight = smileHeight / 2;

    var radius = 0.0;
    var eyeRadius = 10.0;
    if (smileHeight < size.width) {
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
          Color(0xFFfe5c6e),
        'BAD'
      );

      ughReview = ReviewState(
        Offset(leftSmileX, endingY - (radius / 2)),
        Offset(diameter, endingY - oneThirdOfDia),
        Offset(endingX - radius, endingY - oneThirdOfDia),
        Offset(endingX - (radius / 2), endingY - oneThirdOfDia),
        Offset(endingX - (radius / 2), endingY - oneThirdOfDia),
        Color(0xFFF9D976),
        Color(0xfff39f86),
          Color(0xFFf6bc7e),
        'UGH'
      );

      okReview = ReviewState(
        Offset(leftSmileX, endingY - (oneThirdOfDiaByTwo * 2)),
        Offset(diameter, endingY - oneThirdOfDia),
        Offset(endingX - radius, endingY - oneThirdOfDia),
        Offset(startingX + radius, endingY - (oneThirdOfDiaByTwo * 2)),
        Offset(endingX - (radius / 2), endingY - (oneThirdOfDiaByTwo * 2)),
        Color(0xFF21e1fa),
        Color(0xff3bb8fd),
        Color(0xFF28cdfc),
        'OK'
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
          Color(0xFF41f7c6),
        'GOOD'
      );
    }

//    currentState = ReviewState.tween(okReview, goodReview, slideValue / 100);
//    currentState = goodReview;
    if(slideValue<=100){
      currentState = ReviewState.lerp(badReview, ughReview, slideValue/100);
    }else if(slideValue<=200){
      currentState = ReviewState.lerp(ughReview, okReview, (slideValue-100)/100);
    }else if(slideValue<=300){

      double diff = (slideValue-200)/100;
      currentState = ReviewState.lerp(okReview, goodReview, diff);

//      tweening between ok 200 to good 300

      //Draw text

      TextSpan spanCenter = new TextSpan(style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 52.0, color: okReview.titleColor), text: okReview.title);
      TextPainter tpCenter = new TextPainter(text: spanCenter, textDirection: TextDirection.ltr);

      TextSpan spanLeft = new TextSpan(style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 52.0, color: ughReview.titleColor), text: ughReview.title);
      TextPainter tpLeft = new TextPainter(text: spanLeft, textDirection: TextDirection.ltr);

      TextSpan spanRight = new TextSpan(style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 52.0, color: goodReview.titleColor), text: goodReview.title);
      TextPainter tpRight = new TextPainter(text: spanRight, textDirection: TextDirection.ltr);

      tpCenter.layout();
      tpLeft.layout();
      tpRight.layout();


      double goodWidth = tpCenter.width;
      double halfGoodWidth = goodWidth/2;
      double centerCnter = halfWidth;
      double leftCnter = centerCnter-goodWidth;
      double rightCenter = centerCnter+goodWidth;

      Offset centerTextOffset = new Offset(centerCnter - halfGoodWidth, smileHeight);
      Offset leftTextOffset = new Offset(leftCnter-(tpLeft.width/2), smileHeight);
      Offset rightTextOffset = new Offset(rightCenter-(tpRight.width/2), smileHeight);

      tpCenter.paint(canvas, Offset.lerp(centerTextOffset, leftTextOffset, diff));
      tpLeft.paint(canvas, leftTextOffset);
      tpRight.paint(canvas, Offset.lerp(rightTextOffset, centerTextOffset, diff));

    }else if(slideValue<=400){
      currentState = ReviewState.lerp(goodReview, badReview, (slideValue-300)/100);
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

    //drawing stuff for debugging-----------------------------------

    canvas.drawRect(
        Rect.fromLTRB(0.0, 0.0, size.width, smileHeight), debugPaint);
    canvas.drawRect(
        Rect.fromLTRB(startingX, startingY, endingX, endingY), debugPaint);

    canvas.drawLine(
        Offset(startingX, startingY), Offset(endingX, endingY), debugPaint);
    canvas.drawLine(
        Offset(endingX, startingY), Offset(startingX, endingY), debugPaint);
    canvas.drawLine(Offset(startingX + radius, startingY),
        Offset(startingX + radius, endingY), debugPaint);
    canvas.drawLine(Offset(startingX, startingY + radius),
        Offset(endingX, startingY + radius), debugPaint);

    //horizontal lines
    canvas.drawLine(Offset(startingX, startingY + oneThirdOfDia),
        Offset(endingX, startingY + oneThirdOfDia), debugPaint);
    canvas.drawLine(Offset(startingX, endingY - oneThirdOfDia),
        Offset(endingX, endingY - oneThirdOfDia), debugPaint);
    canvas.drawLine(Offset(startingX, endingY - oneThirdOfDiaByTwo),
        Offset(endingX, endingY - oneThirdOfDiaByTwo), debugPaint);

    //vertical lines
    canvas.drawLine(Offset(startingX + oneThirdOfDiaByTwo, startingY),
        Offset(startingX + oneThirdOfDiaByTwo, endingY), debugPaint);
    canvas.drawLine(Offset(startingX + oneThirdOfDia, startingY),
        Offset(startingX + oneThirdOfDia, endingY), debugPaint);
    canvas.drawLine(Offset(endingX - oneThirdOfDia, startingY),
        Offset(endingX - oneThirdOfDia, endingY), debugPaint);
    canvas.drawLine(Offset(endingX - oneThirdOfDiaByTwo, startingY),
        Offset(endingX - oneThirdOfDiaByTwo, endingY), debugPaint);
    //--------------------------------------------------------------

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

  String title;
  Color titleColor;

  Color startColor;
  Color endColor;

  ReviewState(this.leftOffset, this.leftHandle, this.centerOffset,
      this.rightHandle, this.rightOffset, this.startColor, this.endColor, this.titleColor, this.title);

  //create new state between given two states.
  static ReviewState lerp(ReviewState start, ReviewState end, double ratio) {
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
      start.titleColor,
      start.title
    );
  }
}
