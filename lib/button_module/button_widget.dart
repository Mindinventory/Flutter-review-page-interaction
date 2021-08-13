import 'package:flutter/material.dart';
import 'file:///Users/dhruv/Projects/Flutter-review-page-interaction/expression_emoji/lib/app_color.dart';

///A button that can show gradient as it's background,
///you can pass different colors and it will animate between those colors.
class GradientButton extends StatefulWidget {

  static const TextStyle defaultTextStyle = TextStyle(
      color: AppColors.white,
      fontSize: 24.00,
      fontWeight: FontWeight.w500
  );

  final Color startColor;
  final Color endColor;
  final TextStyle textStyle;
  final String label;
  final double radius;
  final Function onTap;


  GradientButton({
    this.startColor,
    this.endColor,
    this.textStyle = defaultTextStyle,
    this.label = 'Submit',
    this.radius = 100,
    this.onTap
  });

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {

  Color _startColor;
  Color _endColor;
  ColorTween startColorTween;
  ColorTween endColorTween;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    startColorTween = ColorTween(begin: _startColor, end: widget.startColor);
    endColorTween = ColorTween(begin: _endColor, end: widget.endColor);

    _animationController = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 300),
      vsync: this,

    )
    ..addListener(() {
      setState(() {
        _startColor = startColorTween.lerp(_animationController.value);
        _endColor = endColorTween.lerp(_animationController.value);
      });
    });
    // _animationController.forward(from:0.0);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant GradientButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.startColor!=widget.startColor){
      startColorTween = ColorTween(begin: oldWidget.startColor, end: widget.startColor);
      endColorTween = ColorTween(begin: oldWidget.endColor, end: widget.endColor);
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: ElevatedButton(

        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
            shadowColor: _startColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius))
        ),
        child: Ink(
          width: 150.0,
          height: 50.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_startColor??widget.startColor, _endColor??widget.endColor]),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.radius),
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: widget.textStyle,
            ),
          ),
        ),
      ),
    );
  }
}


