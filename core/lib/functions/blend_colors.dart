part of 'functions.dart';

Color blendColors(Color color1, Color color2, double factor) {

  if (factor < 0) factor = 0;
  if (factor > 1) factor = 1;

  double red = color1.r * (1 - factor) + color2.r * factor;
  double green = color1.g * (1 - factor) + color2.g * factor;
  double blue = color1.b * (1 - factor) + color2.b * factor;
  double alpha = color1.a * (1 - factor) + color2.a * factor;

  return Color.from(alpha:alpha, red:red, green:green, blue:blue);
}