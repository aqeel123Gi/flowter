import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:framework/classes/classes.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/screen_debugger/screen_debugger.dart';
import 'latlong_distance.dart';



class LocationController{

  static bool _running = false;
  static Position? _currentPosition;
  static StreamSubscription<Position>? _stream;
  static bool Function()? _stopOn;



  //Custom these values:
  // Within Meters : Accuracy for non-moving device about 15 meters (At least).
  static const double _withinMeters = 15;
  static const int _countStopAfterSeconds = 30;
  //
  static List<MapEntry<DateTime,Position>>? _positions;
  static Function(Position position,DateTime start,DateTime end)? _onLocationStop;
  static MapEntry<DateTime,Position>? _startStopping;

  static Future<bool> readyToStart ({
    required void Function() onDisabledService,
    required void Function() onDeny,
  }) async {

    //Service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      onDisabledService();
      return false;
    }

    //Permission
    LocationPermission  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      onDeny();
      return false;
    }

    if (kDebugMode) {
      print("Ready to get Location");
    }

    return true;
  }

  static Future<bool> start ({
    required void Function() onDisabledService,
    required void Function() onDeny,
    required void Function(Position position) positionUpdate,
    void Function(Position position,DateTime start,DateTime end)? onLocationStop,
    void Function(double speed)? speedUpdate,
    required bool Function() stopOn,
    int updateWithinMeters = 10
  }) async {

    if(_running){
      if (kDebugMode) {
        print("The Location Update service is running for another code.");
      }
      return false;
    }

    //Service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      onDisabledService();
      return false;
    }

    //Permission
    LocationPermission  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      onDeny();
      return false;
    }

    //Start
    LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: updateWithinMeters
    );
    _stream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
              _currentPosition = position;
          if(position!=null){
            // customDebugPrint("POSITION: ${position.latitude} ${position.longitude}");
            positionUpdate(position);
            DebuggerConsole.addLine("SPEED: ${position.speed}",color: Colors.blueAccent);
            DebuggerConsole.addLine("ACCURACY: ${position.accuracy}",color: Colors.orangeAccent);
            if(speedUpdate!=null){

              speedUpdate(position.speed);
            }
          }

        });
    if (kDebugMode) {
      print("Start Location Update");
    }
    if(onLocationStop!=null){
      _onLocationStop = onLocationStop;
      _positions = [];
      if (kDebugMode) {
        print("Start Location Stops Count");
      }
    }

    _running = true;
    _stopOn = stopOn;
    _loop();



    return true;
  }


  static _loop()async{


    while(true){
      await Future.delayed(const Duration(seconds: 1));

      if(WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed){
        _currentPosition = null;
      }

      if(_onLocationStop !=null && _currentPosition!=null ){

        _positions!.add(MapEntry(DateTime.now(), _currentPosition!));

        if(_positions!.length>_countStopAfterSeconds){

          if(_startStopping==null){
            Position p1 = _positions!.first.value;
            Position p2 = _positions!.last.value;
            // customDebugPrint("DEF: ${getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)}");
            if(_positions!.last.key.difference(_positions!.first.key).inSeconds>=_countStopAfterSeconds &&
                getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)<=_withinMeters){
              DebuggerConsole.addLine("START STOP Point.",color: Colors.red);
              _startStopping = _positions!.first;
            }
          }else{
            Position p1 = _startStopping!.value;
            Position p2 = _positions!.last.value;
            // customDebugPrint("DEF: ${getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)}");
            if(getDistanceBetweenTwoLocationsInMeters(p1.latitude,p1.longitude,p2.latitude,p2.longitude)>_withinMeters){
              DebuggerConsole.addLine("END STOP Point: ${_positions!.last.key.difference(_startStopping!.key).inSeconds} seconds",color: Colors.red);
              _onLocationStop!(_startStopping!.value,_startStopping!.key,_positions!.last.key);
              _positions = [];
              _startStopping=null;
            }
          }

          if(_positions!.isNotEmpty){
            _positions!.removeAt(0);
          }

        }
      }


      if(_stopOn!()){
        if (kDebugMode) {
          print("Stop Location Update");
        }
        _stream!.cancel();
        _stream = null;
        _running = false;
        _currentPosition = null;
        _stopOn = null;
        _positions = null;
        _startStopping = null;
        return;
      }
    }

  }


  static Future<Location> get getCurrent async{
    return Location.fromPositionOfGeolocatorPackage(await Geolocator.getCurrentPosition());
  }


}











