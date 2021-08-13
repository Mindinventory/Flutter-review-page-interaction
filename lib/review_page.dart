import 'package:arc_menu/arc_chooser.dart';
import 'package:arc_menu/arc_item_model.dart';
import 'package:expression_emoji/app_color.dart';
import 'package:expression_emoji/expression_emoji.dart';
import 'package:expression_emoji/smile_painter.dart';
import 'package:flutter/material.dart';

import 'button_module/button_widget.dart';

class MyReviewPage extends StatefulWidget {
  MyReviewPage({Key key}) : super(key: key);

  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage>
    with TickerProviderStateMixin {
  TextStyle textStyleForText = TextStyle(
      color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w500);

  Color startColor;
  Color endColor;

  List<ArcItem> arcItems = [
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
        startColor: AppColors.c3ee98a,
        endColor: AppColors.c41f7c7),
    ArcItem(
        title: 'BAD',
        startColor: AppColors.fe0944,
        endColor: AppColors.feae96),
  ];

  GlobalKey<ExpressionEmojiState> expressionKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    startColor = AppColors.c21e1fa;
    endColor = AppColors.c3bb8fd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
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
            ExpressionEmoji(
              key: expressionKey,
              size: Size(MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.width / 2) + 60),),
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                ArcChooser(
                  arcItems: arcItems,
                  onArcItemSelected: (int pos, ArcItem arcItem) {

                    setState(() {
                      startColor = arcItem.startColor;
                      endColor = arcItem.endColor;
                    });
                    expressionKey.currentState.animateTo(pos);

                  },
                ),
                GradientButton(
                  startColor: startColor,
                  endColor: endColor,
                  onTap: (){
                    final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
