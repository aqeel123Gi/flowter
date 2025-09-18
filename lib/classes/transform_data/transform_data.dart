import 'package:flutter/animation.dart';

class TransformData{

  TransformData({
    this.ignorance = false,
    this.rotation = 0,
    this.forwardedX = 0,
    this.x =0,
    this.height,
    this.width,
    this.y = 0,
    this.scale = 1,
    this.opacity = 1,
    this.changeAfter = Duration.zero,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
  });

  bool ignorance;
  double rotation;
  double? height;
  double? width;
  double x;
  double forwardedX;
  double y;
  double scale;
  double opacity;
  Duration changeAfter;
  Curve curve;
  Duration duration;

  TransformData copyWith({
    bool? ignorance,
    double? height,
    double? width,
    double? forwardedX,
    double? x,
    double? y,
    double? scale,
    double? opacity,
    Curve? curve,
    Duration? duration,
    Duration? changeAfter
  }){
    TransformData modified = TransformData();
    modified.ignorance = ignorance??this.ignorance;
    modified.height = height??this.height;
    modified.width = width??this.width;
    modified.x = x??this.x;
    modified.forwardedX = forwardedX??this.forwardedX;
    modified.y = y??this.y;
    modified.scale = scale??this.scale;
    modified.opacity = opacity??this.opacity;
    modified.curve = curve??this.curve;
    modified.duration = duration??this.duration;
    modified.changeAfter = changeAfter??this.changeAfter;
    return modified;
  }


  bool appliedWith(TransformData other){
    return
      ignorance == other.ignorance
          && height == other.height
          && width == other.width
          && x == other.x
          && forwardedX == other.forwardedX
          && y == other.y
          && scale == other.scale
          && opacity == other.opacity
          && changeAfter == other.changeAfter
          && curve == other.curve
          && duration == other.duration;
  }


}