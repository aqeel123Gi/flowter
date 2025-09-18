import 'dart:math';
import 'dart:ui';

double getDistanceBetweenTwoOffsets(Offset offset1, Offset offset2) => sqrt(pow(offset1.dx-offset2.dx,2)+pow(offset1.dy-offset2.dy,2));