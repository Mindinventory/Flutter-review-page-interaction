import 'dart:ui';

import 'package:flutter/cupertino.dart';

class DrawingArc {
  ArcItem arcItem;
  double startAngle;
  DrawingArc(this.arcItem, this.startAngle);
}

class ArcItem {
  String title;
  Color startColor;
  Color endColor;

  ArcItem(
      {@required this.title,
      @required this.startColor,
      @required this.endColor});
}
