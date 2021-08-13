import 'dart:math';

extension AngleConversion on double {
  double degreeToRadians() {
    return this * (pi / 180);
  }
}