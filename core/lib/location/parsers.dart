import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng? parseLatLngFromString(String? text) {
  if (text == null) {
    return null;
  }
  List<String> x = text.split(",");
  return LatLng(double.parse(x[0]), double.parse(x[1]));
}

String? parseStringFromLatLng(LatLng? latLng) {
  if (latLng == null) {
    return null;
  }
  return "${latLng.latitude},${latLng.longitude}";
}