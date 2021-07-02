import 'dart:ui';

class ReviewState {
  //smile points
  Offset leftOffset;
  Offset centerOffset;
  Offset rightOffset;

  Offset leftHandle;
  Offset rightHandle;

  String title;
  Color titleColor;

  Color startColor;
  Color endColor;

  ReviewState(this.leftOffset, this.leftHandle, this.centerOffset, this.rightHandle, this.rightOffset,
      this.startColor, this.endColor, this.titleColor, this.title);

  //create new state between given two states.
  static ReviewState lerp(ReviewState start, ReviewState end, double ratio) {
    var startColor = Color.lerp(start.startColor, end.startColor, ratio);
    var endColor = Color.lerp(start.endColor, end.endColor, ratio);

    return ReviewState(
        Offset.lerp(start.leftOffset, end.leftOffset, ratio),
        Offset.lerp(start.leftHandle, end.leftHandle, ratio),
        Offset.lerp(start.centerOffset, end.centerOffset, ratio),
        Offset.lerp(start.rightHandle, end.rightHandle, ratio),
        Offset.lerp(start.rightOffset, end.rightOffset, ratio),
        startColor,
        endColor,
        start.titleColor,
        start.title);
  }
}
