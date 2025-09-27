import 'package:geolocator/geolocator.dart';

class Location{

  Location({
    required this.latitude,
    required this.longitude
  });


  double latitude;
  double longitude;



  List<double> get array{
    return [latitude,longitude];
  }


  @override
  toString() {
    return '($latitude,$longitude)';
  }



  static Location fromPositionOfGeolocatorPackage(Position position) {
    return Location(
      latitude: position.latitude,
      longitude: position.longitude
    );
  }

}