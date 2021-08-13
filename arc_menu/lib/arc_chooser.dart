import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'arc_item_model.dart';
import 'choose_painter.dart';
import 'extensions.dart';

class ArcChooser extends StatefulWidget {
  final ArcSelectedCallback onArcItemSelected;
  final List<ArcItem> arcItems;
  final bool showGuageLines;
  final bool shouldTransparent;
  final int initialItem;
  ArcChooser(
      {this.arcItems, this.showGuageLines = false, this.shouldTransparent = false, this.onArcItemSelected, this.initialItem = 1});

  @override
  State<StatefulWidget> createState() {
    return ChooserState();
  }
}

class ChooserState extends State<ArcChooser>
    with SingleTickerProviderStateMixin {

  Offset centerPoint;

  double userAngle = 0.0;

  double startAngle;

  static double center = 270.0;
  static double centerInRadians = center.degreeToRadians();
  static double angle = 45.0;

  static double angleInRadians = angle.degreeToRadians();
  static double angleInRadiansByTwo = angleInRadians / 2;
  static double centerItemAngle = (center - (angle / 2)).degreeToRadians();
  List<DrawingArc> renderedArcItems;

  AnimationController animation;
  double animationStart;
  double animationEnd = 0.0;

  //Current position of rendered Arc
  int currentPosition;

  Offset startingPoint;
  Offset endingPoint;

  ChooserState() {}

  @override
  void initState() {
    super.initState();
    currentPosition = widget.initialItem;
    renderedArcItems = <DrawingArc>[];

    for (var i = 0; i < 8;i++) {
      int index = getItemPosition(i);
      renderedArcItems.add(DrawingArc(
          widget.arcItems[index],
          angleInRadiansByTwo + userAngle + (i * angleInRadians)));
    }

    animation = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value);
      setState(() {
        for (int i = 0; i < renderedArcItems.length; i++) {
          renderedArcItems[i].startAngle =
              angleInRadiansByTwo + userAngle + (i * angleInRadians);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height * 1.5;
    centerPoint = Offset(centerX, centerY);

    return _gestureDetectorForSlider();
  }

  Widget _gestureDetectorForSlider() {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        startingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        startAngle = atan2(deltaY, deltaX);
      },
      onPanUpdate: (DragUpdateDetails details) {
        endingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        var freshAngle = atan2(deltaY, deltaX);
        userAngle += freshAngle - startAngle;
        setState(() {
          for (int i = 0; i < renderedArcItems.length; i++) {
            renderedArcItems[i].startAngle =
                angleInRadiansByTwo + userAngle + (i * angleInRadians);
          }
        });
        startAngle = freshAngle;
      },
      onPanEnd: (DragEndDetails details) {
        //find top arc item with Magic!!
        bool kLeftToRight = startingPoint.dx < endingPoint.dx;

        //Animate it from this values
        animationStart = userAngle;
        if (kLeftToRight) {
           animationEnd += angleInRadians;
          currentPosition--;
          if (currentPosition < 0) {
            currentPosition = 7;
          }
        } else {
          animationEnd -= angleInRadians;
          currentPosition++;
          if (currentPosition >= 8) {
            currentPosition = 0;
          }
        }

        //as we are starting the rendering from left>top>right>bottom

        if (widget.onArcItemSelected != null) {

          widget.onArcItemSelected(getItemPosition(currentPosition), renderedArcItems[currentPosition].arcItem);
        }

        animation.forward(from: 0.0);
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.width / 1.5),
        painter: ChooserPainter(
            arcItems: renderedArcItems,
            angleInRadians: angleInRadians,
            shouldTransparent: widget.shouldTransparent,
            drawGuageLines: widget.showGuageLines),
      ),
    );
  }

  int getItemPosition(int currentPosition) {
    currentPosition = currentPosition + 1;
    num itemPosition =
    (currentPosition<widget.arcItems.length)
        ?currentPosition
        :currentPosition % widget.arcItems.length;

    return itemPosition;
  }

}

typedef void ArcSelectedCallback(int position, ArcItem arcItem);
