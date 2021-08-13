import 'smile_painter.dart';
import 'package:flutter/material.dart';

class ExpressionEmoji extends StatefulWidget{
  final Size size;

  const ExpressionEmoji({Key key, this.size}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExpressionEmojiState();
  }
}

class ExpressionEmojiState extends State<ExpressionEmoji> with SingleTickerProviderStateMixin{

  AnimationController animation;
  int slideValue = 200;
  int lastAnimPosition = 2;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 400.0,
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..addListener(() {
      setState(() {
        slideValue = animation.value.toInt();
      });
    });

    animation.animateTo(slideValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size??Size(MediaQuery.of(context).size.width,
          (MediaQuery.of(context).size.width / 2) + 60),
      painter: SmilePainter(slideValue),
    );
  }

  @override
  void didUpdateWidget(covariant ExpressionEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  void animateTo(int pos){
    pos = pos+1;
    if(pos>3)pos=0;
    if (lastAnimPosition == 3 && pos == 0) {
      animation.animateTo(4 * 100.0);

    } else if (lastAnimPosition == 0 && pos == 3) {
      animation.forward(from: 4 * 100.0);
      animation.animateTo(pos * 100.0);

    } else if (lastAnimPosition == 0 && pos == 1) {
      animation.forward(from: 0.0);
      animation.animateTo(pos * 100.0);

    } else {
      animation.animateTo(pos * 100.0);
    }
    lastAnimPosition = pos;
  }

}