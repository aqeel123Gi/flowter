import 'dart:math';
import 'dart:ui';

//Start from right
class CircularOffset{

  double rotation;
  double radius;

  CircularOffset(this.rotation,this.radius);

  Offset get xyOffset{
    return Offset(cos(rotation)*radius,sin(rotation)*radius);
  }

}


