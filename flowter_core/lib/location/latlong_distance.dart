import 'dart:math';

double getDistanceBetweenTwoLocationsInMeters(double lat1,double long1,double lat2,double long2){
  double pi = 3.14159265359;
  double R = 6371e3; // metres
  double g1 = lat1 * pi/180; // φ, λ in radians
  double g2 = lat2 * pi/180;
  double dg = (lat2-lat1) * pi/180;
  double dl = (long2-long1) * pi/180;

  double a = sin(dg/2) * sin(dg/2) + cos(g1) * cos(g2) * sin(dl/2) * sin(dl/2);
  double c = 2 * atan2(sqrt(a), sqrt(1-a));

  return R * c;
}


