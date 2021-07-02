import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:review/common/app_color.dart';
import 'model/arc_item_model.dart';
import 'common/choose_painter.dart';

class ArcChooser extends StatefulWidget {
  ArcSelectedCallback arcSelectedCallback;

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback);
  }
}

class ChooserState extends State<ArcChooser> with SingleTickerProviderStateMixin {
  var slideValue = 200;
  Offset centerPoint;

  double userAngle = 0.0;

  double startAngle;

  static double center = 270.0;
  static double centerInRadians = degreeToRadians(center);
  static double angle = 45.0;

  static double angleInRadians = degreeToRadians(angle);
  static double angleInRadiansByTwo = angleInRadians / 2;
  static double centerItemAngle = degreeToRadians(center - (angle / 2));
  List<ArcItemModel> arcItems;

  AnimationController animation;
  double animationStart;
  double animationEnd = 0.0;

  int currentPosition = 0;

  Offset startingPoint;
  Offset endingPoint;

  ArcSelectedCallback arcSelectedCallback;

  ChooserState(ArcSelectedCallback arcSelectedCallback) {
    this.arcSelectedCallback = arcSelectedCallback;
  }

  static double degreeToRadians(double degree) {
    return degree * (pi / 180);
  }

  /*static double radianToDegrees(double radian) {
    return radian * (180 / pi);
  }*/

  @override
  void initState() {
    arcItems = <ArcItemModel>[];

    arcItems
      ..add(ArcItemModel("UGH", [AppColors.F9D976, AppColors.f39f86], angleInRadiansByTwo + userAngle))
      ..add(ArcItemModel(
          "OK", [AppColors.c21e1fa, AppColors.c3bb8fd], angleInRadiansByTwo + userAngle + (angleInRadians)))
      ..add(ArcItemModel("GOOD", [AppColors.c3ee98a, AppColors.c41f7c7],
          angleInRadiansByTwo + userAngle + (2 * angleInRadians)))
      ..add(ArcItemModel("BAD", [AppColors.fe0944, AppColors.feae96],
          angleInRadiansByTwo + userAngle + (3 * angleInRadians)))
      ..add(ArcItemModel("UGH", [AppColors.F9D976, AppColors.f39f86],
          angleInRadiansByTwo + userAngle + (4 * angleInRadians)))
      ..add(ArcItemModel("OK", [AppColors.c21e1fa, AppColors.c3bb8fd],
          angleInRadiansByTwo + userAngle + (5 * angleInRadians)))
      ..add(ArcItemModel("GOOD", [AppColors.c3ee98a, AppColors.c41f7c7],
          angleInRadiansByTwo + userAngle + (6 * angleInRadians)))
      ..add(ArcItemModel("BAD", [AppColors.fe0944, AppColors.feae96],
          angleInRadiansByTwo + userAngle + (7 * angleInRadians)));

    animation = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value);
      setState(() {
        for (int i = 0; i < arcItems.length; i++) {
          arcItems[i].startAngle = angleInRadiansByTwo + userAngle + (i * angleInRadians);
        }
      });
    });
    super.initState();
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
      /*onTap: () {
         print('ChooserState.build onTap');
         animationStart = touchAngle;
         animationEnd = touchAngle + angleInRadians;
         animation.forward(from: 0.0);
       },*/
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
          for (int i = 0; i < arcItems.length; i++) {
            arcItems[i].startAngle = angleInRadiansByTwo + userAngle + (i * angleInRadians);
          }
        });
        startAngle = freshAngle;
      },
      onPanEnd: (DragEndDetails details) {
        //find top arc item with Magic!!
        bool rightToLeft = startingPoint.dx < endingPoint.dx;

        //Animate it from this values
        animationStart = userAngle;
        if (rightToLeft) {
          animationEnd += angleInRadians;
          currentPosition--;
          if (currentPosition < 0) {
            currentPosition = arcItems.length - 1;
          }
        } else {
          animationEnd -= angleInRadians;
          currentPosition++;
          if (currentPosition >= arcItems.length) {
            currentPosition = 0;
          }
        }

        if (arcSelectedCallback != null) {
          arcSelectedCallback(currentPosition,
              arcItems[(currentPosition >= (arcItems.length - 1)) ? 0 : currentPosition + 1]);
        }

        animation.forward(from: 0.0);
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width * 1 / 1.5),
        painter: ChooserPainter(arcItems: arcItems, angleInRadians: angleInRadians,isLine: true),
      ),
    );
  }
}

typedef void ArcSelectedCallback(int position, ArcItemModel arcitem);
