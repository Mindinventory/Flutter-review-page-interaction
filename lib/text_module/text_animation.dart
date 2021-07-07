import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:review/smile_painter_module/review_state.dart';

class TextAnimation {
  tweenText(
    ReviewState centerReview,
    ReviewState rightReview,
    double diff,
    Canvas canvas,
    double centerCenter,
    double rightCenter,
    double smileHeight,
    double leftCenter,
  ) {
    ReviewState currentState;

    currentState = ReviewState.lerp(centerReview, rightReview, diff);

    TextSpan spanCenter = TextSpan(
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 52.0,
            color: centerReview.titleColor.withAlpha(255 - (255 * diff).round())),
        text: centerReview.title);
    TextPainter tpCenter = TextPainter(text: spanCenter, textDirection: TextDirection.ltr);

    TextSpan spanRight = TextSpan(
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 52.0,
            color: rightReview.titleColor.withAlpha((255 * diff).round())),
        text: rightReview.title);
    TextPainter tpRight = TextPainter(text: spanRight, textDirection: TextDirection.ltr);

    tpCenter.layout();
    tpRight.layout();

    Offset centerOffset = Offset(centerCenter - (tpCenter.width / 2), smileHeight);
    Offset centerToLeftOffset = Offset(leftCenter - (tpCenter.width / 2), smileHeight);

    Offset rightOffset = Offset(rightCenter - (tpRight.width / 2), smileHeight);
    Offset rightToCenterOffset = Offset(centerCenter - (tpRight.width / 2), smileHeight);

    tpCenter.paint(canvas, Offset.lerp(centerOffset, centerToLeftOffset, diff));
    tpRight.paint(canvas, Offset.lerp(rightOffset, rightToCenterOffset, diff));

    return currentState;
  }
}
