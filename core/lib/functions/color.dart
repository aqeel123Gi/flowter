import 'package:flutter/material.dart';



Color getMixedColor(List<Color> colorList) {
  if (colorList.isEmpty) {
    return Colors.transparent; // Return a default color (e.g., transparent) if the list is empty
  }

  double totalRed = 0;
  double totalGreen = 0;
  double totalBlue = 0;
  double totalAlpha = 0;

  for (var color in colorList) {
    totalRed += color.r;
    totalGreen += color.g;
    totalBlue += color.b;
    totalAlpha += color.a;
  }

  double averageRed = totalRed / colorList.length;
  double averageGreen = totalGreen / colorList.length;
  double averageBlue = totalBlue / colorList.length;
  double averageAlpha = totalAlpha / colorList.length;

  return Color.from(alpha: averageAlpha, red: averageRed, green: averageGreen, blue: averageBlue);

}