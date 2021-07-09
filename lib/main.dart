import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:review/arc_chooser_module/arc_chooser.dart';
import 'package:review/button_module/button_widget.dart';
import 'package:review/smile_painter_module/smile_painter.dart';
import 'package:review/common/app_color.dart';

import 'model/arc_item_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: AppColors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.white,
        body: MyReviewPage(),
      ),
    );
  }
}

class MyReviewPage extends StatefulWidget {
  MyReviewPage({Key key}) : super(key: key);

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> with TickerProviderStateMixin {
  // var textStyleForButton = TextStyle(color: AppColors.white, fontSize: 24.00, fontWeight: FontWeight.w500);
  var textStyleForText = TextStyle(color: AppColors.black, fontSize: 22.0, fontWeight: FontWeight.w500);

  int slideValue = 200;
  int lastAnimPosition = 2;

  AnimationController animation;

  List<ArcItemModel> arcItems = <ArcItemModel>[];

  ArcItemModel badArcItem;
  ArcItemModel ughArcItem;
  ArcItemModel okArcItem;
  ArcItemModel goodArcItem;

  Color startColor;
  Color endColor;

  @override
  void initState() {
    super.initState();

    badArcItem = ArcItemModel("BAD", [AppColors.fe0944, AppColors.feae96], 0.0);
    ughArcItem = ArcItemModel("UGH", [AppColors.F9D976, AppColors.f39f86], 0.0);
    okArcItem = ArcItemModel("OK", [AppColors.c21e1fa, AppColors.c3bb8fd], 0.0);
    goodArcItem = ArcItemModel("GOOD", [AppColors.c3ee98a, AppColors.c41f7c7], 0.0);

    arcItems..add(badArcItem)..add(ughArcItem)..add(okArcItem)..add(goodArcItem);

    startColor = AppColors.c21e1fa;
    endColor = AppColors.c3bb8fd;

    animation = AnimationController(
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 400.0,
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..addListener(() {
        setState(() {
          slideValue = animation.value.toInt();

          double ratio;

          if (slideValue <= 100) {
            ratio = animation.value / 100;
            startColor = Color.lerp(badArcItem.colors[0], ughArcItem.colors[0], ratio);
            endColor = Color.lerp(badArcItem.colors[1], ughArcItem.colors[1], ratio);
          } else if (slideValue <= 200) {
            ratio = (animation.value - 100) / 100;
            startColor = Color.lerp(ughArcItem.colors[0], okArcItem.colors[0], ratio);
            endColor = Color.lerp(ughArcItem.colors[1], okArcItem.colors[1], ratio);
          } else if (slideValue <= 300) {
            ratio = (animation.value - 200) / 100;
            startColor = Color.lerp(okArcItem.colors[0], goodArcItem.colors[0], ratio);
            endColor = Color.lerp(okArcItem.colors[1], goodArcItem.colors[1], ratio);
          } else if (slideValue <= 400) {
            ratio = (animation.value - 300) / 100;
            startColor = Color.lerp(goodArcItem.colors[0], badArcItem.colors[0], ratio);
            endColor = Color.lerp(goodArcItem.colors[1], badArcItem.colors[1], ratio);
          }
        });
      });

    animation.animateTo(slideValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
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
                style: textStyleForText,
              ),
            ),
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, (MediaQuery.of(context).size.width / 2) + 60),
            painter: SmilePainter(slideValue),
          ),
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              ArcChooser()
                ..arcSelectedCallback = (int pos, ArcItemModel item) {
                  int animPosition = pos - 2;
                  if (animPosition > 3) {
                    animPosition = animPosition - 4;
                  }

                  if (animPosition < 0) {
                    animPosition = 4 + animPosition;
                  }

                  if (lastAnimPosition == 3 && animPosition == 0) {
                    animation.animateTo(4 * 100.0);
                  } else if (lastAnimPosition == 0 && animPosition == 3) {
                    animation.forward(from: 4 * 100.0);
                    animation.animateTo(animPosition * 100.0);
                  } else if (lastAnimPosition == 0 && animPosition == 1) {
                    animation.forward(from: 0.0);
                    animation.animateTo(animPosition * 100.0);
                  } else {
                    animation.animateTo(animPosition * 100.0);
                  }

                  lastAnimPosition = animPosition;
                },
              SubmitButton(startColor: startColor,endColor: endColor,),
            ],
          ),
        ],
      ),
    );
  }
}
