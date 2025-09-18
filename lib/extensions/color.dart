part of 'extensions.dart';

extension ColorFunctions on Color {

  Color withOpacityMultiply(double opacityMultiplier){
    return Color.from(
        alpha: a * opacityMultiplier,
        red: r,
        green: g,
        blue: b,
    );
  }

  Color get zeroOpacity{
    return Color.from(alpha: 0, red: r, green: g, blue: b);
  }

}