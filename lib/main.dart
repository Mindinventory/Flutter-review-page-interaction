import 'dart:math';

import 'package:flutter/material.dart';
import 'package:review/SmilePainter.dart';
import 'package:review/ChooserPainter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        backgroundColor: Colors.white,
        body: new MyReviewPage(),
      ),
    );
  }
}

class MyReviewPage extends StatefulWidget {
  MyReviewPage({Key key}) : super(key: key);

  @override
  _MyReviewPageState createState() => new _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage>
    with TickerProviderStateMixin {
  final PageController pageControl = new PageController(
    initialPage: 2,
    keepPage: false,
    viewportFraction: 0.5,
  );

  var slideValue = 200;

  List<ReviewItem> reviewItems = [
    ReviewItem(
      "BAD",
      Color(0xFFfe0944),
      Color(0xFFfeae96),
    ),
    ReviewItem(
      "UGH",
      Color(0xFFF9D976),
      Color(0xfff39f86),
    ),
    ReviewItem(
      "OK",
      Color(0xFF21e1fa),
      Color(0xff3bb8fd),
    ),
    ReviewItem(
      "GOOD",
      Color(0xFF3ee98a),
      Color(0xFF41f7c7),
    )
  ];

  AnimationController animation;

  Offset centerPoint;

  double touchAngle = 0.0;

  double startAngle;

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 400.0,
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..addListener(() {
        setState(() {
          print("val :" + animation.value.round().toString());
          slideValue = animation.value.round();
        });
      });

    animation.animateTo(slideValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = new TextStyle(color: Colors.white, fontSize: 24.00);
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height* 1.5;
    centerPoint = Offset(centerX, centerY);

    var arcPainter = ChooserPainter(touchAngle);

    return Container(
      margin: MediaQuery.of(context).padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "How was your experience with us?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width / 2),
            painter: SmilePainter(slideValue),
          ),
          Slider(
            min: 0.0,
            max: 400.0,
            value: slideValue.toDouble(),
            onChanged: (double newValue) {
              setState(() {
                slideValue = newValue.round();
              });
            },
          ),
          new SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 3 / 4,
            child: new GestureDetector(
              onPanStart: (DragStartDetails details) {
                print('_MyReviewPageState.build onPanStart {$details}');
                var deltaX = centerPoint.dx - details.globalPosition.dx;
                var deltaY = centerPoint.dy - details.globalPosition.dy;
                startAngle = atan2(deltaY, deltaX);
              },
              onPanUpdate: (DragUpdateDetails details) {
                print('_MyReviewPageState.build onPanUpdate {$details}');
                var deltaX = centerPoint.dx - details.globalPosition.dx;
                var deltaY = centerPoint.dy - details.globalPosition.dy;
                var freshAngle = atan2(deltaY, deltaX);

                setState(() {
                  touchAngle += freshAngle - startAngle;
                });
                startAngle = freshAngle;
              },
              onPanEnd: (DragEndDetails details){
                print('_MyReviewPageState.build :' + details.primaryVelocity.toString());
                arcPainter.a
              },
              child: CustomPaint(
                painter: arcPainter,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ReviewItem {
  final String title;
  final Color startColor;
  final Color endColor;

  ReviewItem(this.title, this.startColor, this.endColor);
}
