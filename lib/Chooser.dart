import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Chooser extends StatefulWidget {

  ArcSelectedCallback arcSelectedCallback;

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback);
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
  double animationEnd = 0.0;

  int currentPosition = 0;

  Offset startingPoint;
  Offset endingPoint;

  ArcSelectedCallback arcSelectedCallback;

  ChooserState(ArcSelectedCallback arcSelectedCallback){
    this.arcSelectedCallback = arcSelectedCallback;
  }

  static double degreeToRadians(double degree) {
    return degree * (PI / 180);
  }

  static double radianToDegrees(double radian) {
    return radian * (180 / PI );
  }

  @override
  void initState() {
    arcItems = List<ArcItem>();


    arcItems.add(ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)],
        angleInRadiansByTwo + userAngle));
    arcItems.add(ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)],
        angleInRadiansByTwo + userAngle + (angleInRadians)));
    arcItems.add(ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)],
        angleInRadiansByTwo + userAngle + (2 * angleInRadians)));
    arcItems.add(ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)],
        angleInRadiansByTwo + userAngle + (3 * angleInRadians)));
    arcItems.add(ArcItem("UGH", [Color(0xFFF9D976), Color(0xfff39f86)],
        angleInRadiansByTwo + userAngle + (4 * angleInRadians)));
    arcItems.add(ArcItem("OK", [Color(0xFF21e1fa), Color(0xff3bb8fd)],
        angleInRadiansByTwo + userAngle + (5 * angleInRadians)));
    arcItems.add(ArcItem("GOOD", [Color(0xFF3ee98a), Color(0xFF41f7c7)],
        angleInRadiansByTwo + userAngle + (6 * angleInRadians)));
    arcItems.add(ArcItem("BAD", [Color(0xFFfe0944), Color(0xFFfeae96)],
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

//        Animate it from this values
          animationStart = userAngle;
          if(rightToLeft) {
            animationEnd +=angleInRadians;
            currentPosition--;
            if(currentPosition<0){
              currentPosition = arcItems.length-1;
            }
          }else{
            animationEnd -=angleInRadians;
            currentPosition++;
            if(currentPosition>=arcItems.length){
              currentPosition = 0;
            }
          }

          if(arcSelectedCallback!=null){
            arcSelectedCallback(currentPosition, arcItems[(currentPosition>=(arcItems.length-1))?0:currentPosition+1]);
          }

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

// draw the arc and other stuff
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

//      TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white), text: arcItems[i].text);
//      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
//      tp.layout();
//      tp.paint(canvas, new Offset(radius2/2*cos(radius2/2*(arcItems[i].startAngle)), radius2/2*cos(radius2/2*(arcItems[i].startAngle))));

//    canvas.drawLine(
//        new Offset(radius2*cos(radius2*(arcItems[i].startAngle)), radius2*cos(radius2*(arcItems[i].startAngle))),
//        new Offset(radius3*cos(radius3*(arcItems[i].startAngle)), radius3*cos(radius3*(arcItems[i].startAngle))),
//        debugPaint);

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

typedef void ArcSelectedCallback(int position, ArcItem arcitem);

class ArcItem {
  String text;
  List<Color> colors;
  double startAngle;

  ArcItem(this.text, this.colors, this.startAngle);
}
