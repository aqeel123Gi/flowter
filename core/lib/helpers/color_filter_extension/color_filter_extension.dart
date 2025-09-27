import 'dart:ui';

export 'package:color_filter_extension/color_filter_extension.dart';

// ColorFilter colorReplacement(Color color, [double strength=1]) {
//   // Clamp strength between 0 and 1
//   strength = strength.clamp(0.0, 1.0);
//
//   double r = color.r;
//   double g = color.g;
//   double b = color.b;
//
//   return ColorFilter.matrix([
//     (1 - strength) + strength * r, strength * g, strength * b, 0, 0, // Red
//     strength * r, (1 - strength) + strength * g, strength * b, 0, 0, // Green
//     strength * r, strength * g, (1 - strength) + strength * b, 0, 0, // Blue
//     0, 0, 0, 1, 0, // Alpha
//   ]);
// }

ColorFilter colorReplacement(Color color, double strength) {
  return ColorFilter.mode(color.withOpacity(strength), BlendMode.srcATop);
}