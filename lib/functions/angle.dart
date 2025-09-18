import 'dart:math';
import 'dart:ui';
import 'package:flowter/flowter.dart';

double angleFromTwoOffsets(Offset origin, Offset distance,
    [bool inDegrees = true]) {
  double t = atan2(distance.dy - origin.dy, distance.dx - origin.dx);
  return inDegrees ? (t * 180 / pi + 360) % 360 : t;
}

bool isInAngleArea(Side side, Offset origin, Offset distance) {
  double angle = angleFromTwoOffsets(origin, distance);
  switch (side) {
    case Side.right:
      return isBetween(angle, 315, 360) || isBetween(angle, 0, 45);
    case Side.left:
      return isBetween(angle, 135, 225);
    case Side.top:
      return isBetween(angle, 225, 315);
    case Side.bottom:
      return isBetween(angle, 45, 135);
  }
}

bool isInSideArea(Side side, Offset origin, Offset distance) {
  switch (side) {
    case Side.right:
      return origin.dx < distance.dx;
    case Side.left:
      return origin.dx > distance.dx;
    case Side.top:
      return origin.dy > distance.dy;
    case Side.bottom:
      return origin.dy < distance.dy;
  }
}
