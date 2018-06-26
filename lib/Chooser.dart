import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Chooser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooserState();
  }
}

class ChooserState extends State<Chooser> with SingleTickerProviderStateMixin {
  var slideValue = 200;
  Offset centerPoint;

  double userAngle = 0.0;

  double startAngle;

  static double center = 270.0;
  static double centerInRadians = degreeToRadians(center);
  static double angle = 45.0;

  static double angleInRadians = degreeToRadians(angle);
  static double angleInRadiansByTwo = angleInRadians/2;
  static double centerItemAngle = degreeToRadians(center - (angle / 2));
  List<ArcItem> arcItems;

  AnimationController animation;
  double animationStart;
  double animationEnd;

  Offset startingPoint;
  Offset endingPoint;
  static double degreeToRadians(double degree) {
    return degree * (PI / 180);
  }

  static double radianToDegrees(double radian) {
    return radian * (180 / PI );
  }

  @override
  void initState() {
    arcItems = List<ArcItem>();

    arcItems.add(ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)],
        angleInRadiansByTwo + userAngle));
    arcItems.add(ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)],
        angleInRadiansByTwo + userAngle + (angleInRadians)));
    arcItems.add(ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)],
        angleInRadiansByTwo + userAngle + (2 * angleInRadians)));
    arcItems.add(ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)],
        angleInRadiansByTwo + userAngle + (3 * angleInRadians)));
    arcItems.add(ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)],
        angleInRadiansByTwo + userAngle + (4 * angleInRadians)));
    arcItems.add(ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)],
        angleInRadiansByTwo + userAngle + (5 * angleInRadians)));
    arcItems.add(ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)],
        angleInRadiansByTwo + userAngle + (6 * angleInRadians)));
    arcItems.add(ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)],
        angleInRadiansByTwo + userAngle + (7 * angleInRadians)));

    animation = new AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value);
      setState(() {
        for (int i = 0; i < arcItems.length; i++) {
          arcItems[i].startAngle = angleInRadiansByTwo + userAngle +
              (i * angleInRadians);
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

    return new SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 3 / 4,
      child: new GestureDetector(
//        onTap: () {
//          print('ChooserState.build ONTAP');
//          animationStart = touchAngle;
//          animationEnd = touchAngle + angleInRadians;
//          animation.forward(from: 0.0);
//        },
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
              arcItems[i].startAngle =
                  angleInRadiansByTwo + userAngle + (i * angleInRadians);
            }
          });
          startAngle = freshAngle;
        },
        onPanEnd: (DragEndDetails details){

          //find top arc item with Magic!!
          bool rightToLeft = startingPoint.dx<endingPoint.dx;
            List<double> diffs = new List(arcItems.length);
            for(int i = 0; i<arcItems.length;i++){
              //find total of differences between starting and ending angles of each item, the top item will have smallest total.
              diffs[i] =(
                  (arcItems[i].startAngle - centerInRadians)//diff from starting angle
                      + (arcItems[i].startAngle + angleInRadians - centerInRadians)//diff from ending angle
              ).abs();
            }

            int centerItemPosition = diffs.indexOf(diffs.reduce(min));


            int nextIndex = 0;
            if(rightToLeft){
              nextIndex = centerItemPosition-1;
              if(nextIndex<0){
                nextIndex = arcItems.length-1;
              }
            }else{
              nextIndex = centerItemPosition+1;
              if(nextIndex>=arcItems.length){
                nextIndex = 0;
              }
            }


          ArcItem centerItem =  arcItems[centerItemPosition];
          ArcItem item = arcItems[nextIndex];


//        Animate it from this values
          animationStart = userAngle;
          if(rightToLeft) {
            if(centerItemPosition==0){
              animationEnd = userAngle + centerInRadians -
                  (angleInRadiansByTwo + item.startAngle);
            }else
              {
              animationEnd = userAngle + centerInRadians -
                  (angleInRadiansByTwo + centerItem.startAngle - angleInRadians);
            }
          }else{
            if(centerItemPosition==(arcItems.length-1)){
              animationEnd = userAngle + centerInRadians -
                  (angleInRadiansByTwo + item.startAngle);
            }else
              {
              animationEnd = userAngle + centerInRadians -
                  (angleInRadiansByTwo + centerItem.startAngle +
                      angleInRadians);
            }
          }

          String direction = (rightToLeft)?'RTL':'LTR';
          print('onPanEnd $nextIndex $centerItemPosition ' + direction + ' | ' + radianToDegrees(animationStart).toString()  + " | " + radianToDegrees(animationEnd).toString());
          animation.forward(from: 0.0);
        },
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.width / 2),
          painter: ChooserPainter(arcItems, angleInRadians),
        ),
      ),
    );
  }

}

class ChooserPainter extends CustomPainter {
  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.red.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final whitePaint = new Paint()
    ..color = Colors.white //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  List<ArcItem> arcItems;
  double angleInRadians;

  ChooserPainter(List<ArcItem> arcItems, double angleInRadians) {
    this.arcItems = arcItems;
    this.angleInRadians = angleInRadians;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //common calc
    double centerX = size.width / 2;
    double centerY = size.height * 1.5;
    Offset center = Offset(centerX, centerY);
    double radius = sqrt((size.width * size.width) / 2);

//    var mainRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
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

    for (int i = 0; i < arcItems.length; i++) {
      canvas.drawArc(
          arcRect,
          arcItems[i].startAngle,
          angleInRadians,
          true,
          new Paint()
            ..style = PaintingStyle.fill
            ..shader = new LinearGradient(
              colors: arcItems[i].colors,
            ).createShader(dummyRect));
    }

    Path shadowPath = new Path();
    shadowPath.addArc(
        Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
        ChooserState.degreeToRadians(180.0),
        ChooserState.degreeToRadians(180.0));
    canvas.drawShadow(shadowPath, Colors.black.withAlpha(220), 8.0, false);

    //bottom white arc
    canvas.drawArc(
        Rect.fromLTRB(leftX, topY, rightX, bottomY),
        ChooserState.degreeToRadians(180.0),
        ChooserState.degreeToRadians(180.0),
        true,
        whitePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ArcItem {
  String text;
  List<Color> colors;
  double startAngle;

  ArcItem(this.text, this.colors, this.startAngle);
}
