import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ArcItemModel {
  String text;
  List<Color> colors;
  double startAngle;
  ArcItemModel(this.text, this.colors, this.startAngle);
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
