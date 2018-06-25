import 'dart:math';

import 'package:flutter/material.dart';
import 'package:review/SmilePainter.dart';
import 'package:review/Chooser.dart';

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

  AnimationController animation;

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
          Chooser()
        ],
      ),
    );
  }
}
