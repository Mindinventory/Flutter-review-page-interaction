import 'package:flutter/material.dart';

import 'arc_chooser_module/arc_chooser.dart';
import 'button_module/button_widget.dart';
import 'common/app_color.dart';
import 'model/arc_item_model.dart';
import 'smile_painter_module/smile_painter.dart';

class MyReviewPage extends StatefulWidget {
  MyReviewPage({Key key}) : super(key: key);

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage>
    with TickerProviderStateMixin {
  TextStyle textStyleForText = TextStyle(
      color: AppColors.black, fontSize: 22.0, fontWeight: FontWeight.w500);

  int slideValue = 200;
  int lastAnimPosition = 2;

  AnimationController animation;

  Color startColor;
  Color endColor;

  List<ArcItem> arcInput;

  @override
  void initState() {
    super.initState();

    arcInput = [
      ArcItem(
          title: 'BAD',
          startColor: AppColors.c3ee98a,
          endColor: AppColors.c41f7c7),
      ArcItem(
          title: 'UGH',
          startColor: AppColors.F9D976,
          endColor: AppColors.f39f86),
      ArcItem(
          title: 'OK',
          startColor: AppColors.c21e1fa,
          endColor: AppColors.c3bb8fd),
      ArcItem(
          title: 'GOOD',
          startColor: AppColors.fe0944,
          endColor: AppColors.feae96),
    ];

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
            startColor = Color.lerp(
                arcInput[0].startColor, arcInput[1].startColor, ratio);
            endColor =
                Color.lerp(arcInput[0].endColor, arcInput[1].endColor, ratio);
          } else if (slideValue <= 200) {
            ratio = (animation.value - 100) / 100;
            startColor = Color.lerp(
                arcInput[1].startColor, arcInput[2].startColor, ratio);
            endColor =
                Color.lerp(arcInput[1].endColor, arcInput[2].endColor, ratio);
          } else if (slideValue <= 300) {
            ratio = (animation.value - 200) / 100;
            startColor = Color.lerp(
                arcInput[2].startColor, arcInput[3].startColor, ratio);
            endColor =
                Color.lerp(arcInput[2].endColor, arcInput[3].startColor, ratio);
          } else if (slideValue <= 400) {
            ratio = (animation.value - 300) / 100;
            startColor = Color.lerp(
                arcInput[3].startColor, arcInput[0].startColor, ratio);
            endColor =
                Color.lerp(arcInput[3].endColor, arcInput[0].endColor, ratio);
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
              ArcChooser(
                  arcInputs: arcInput,
                  showLines: false,
                  shouldTransparent: false)
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
