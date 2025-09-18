import 'dart:math';

double angleFromCoordinates(double lat1, double long1, double lat2, double long2) {
  double y = sin(long2-long1) * cos(lat2);
  double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(long2-long1);
  double t = atan2(y, x);
  return (t*180/pi + 360) % 360;
}