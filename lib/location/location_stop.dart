// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import '../screen_debugger.dart';
// import '../complex.dart';
// import 'latlong_distance.dart';
//
//
//
//
//
// void startCountLocationStops({
//   required Position? Function() getPosition,
//   required bool Function() stopWhen,
//   required void Function(Position position,DateTime start,DateTime end) newLocationStop,
//   // Within Meters : Accuracy for non-moving device about 15 meters (At least).
//   double withinMeters = 15,
//   int countStopAfterSeconds = 30,
// })async{
//
//   // List<KeyValue<DateTime,Position>> positions = [];
//   // KeyValue<DateTime,Position>? startStopping;
//
//   // customDebugPrint("Start Location Stops Count");
//
//   while(!stopWhen()){
//
//     await Future.delayed(const Duration(seconds: 1));
//
//     Position? position = getPosition();
//     if(position!=null ){
//
//       positions.add_mod_del(Complex(DateTime.now(), position));
//
//       if(positions.length>countStopAfterSeconds){
//
//         if(startStopping==null){
//           Position p1 = positions.first.value;
//           Position p2 = positions.last.value;
//           // customDebugPrint("DEF: ${getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)}");
//           if(positions.last.key.difference(positions.first.key).inSeconds>=countStopAfterSeconds &&
//           getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)<=withinMeters){
//             customDebugPrint("START STOP Point.",color: Colors.red);
//             startStopping = positions.first;
//           }
//         }else{
//           Position p1 = startStopping.value;
//           Position p2 = positions.last.value;
//           // customDebugPrint("DEF: ${getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)}");
//           if(getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)>withinMeters){
//             customDebugPrint("END STOP Point: ${positions.last.key.difference(startStopping.key).inSeconds} seconds",color: Colors.red);
//             newLocationStop(startStopping.value,startStopping.key,positions.last.key);
//             positions = [];
//             startStopping=null;
//           }
//         }
//
//         if(positions.isNotEmpty){
//           positions.removeAt(0);
//         }
//
//       }
//     }
//   }
//
//   customDebugPrint("END Location Stops Count");
// }