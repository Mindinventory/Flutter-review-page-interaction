import 'package:flutter/material.dart';
import 'package:review/common/app_color.dart';

class SubmitButton extends StatefulWidget {
  final Color startColor;
  final Color endColor;

  SubmitButton({this.startColor, this.endColor});

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  TextStyle textStyleForButton =
      TextStyle(color: AppColors.white, fontSize: 24.00, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
        elevation: 8.0,
        child: InkWell(
          child: Container(
            width: 150.0,
            height: 50.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [widget.startColor, widget.endColor]),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Submit',
              style: textStyleForButton,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
