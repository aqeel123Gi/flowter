import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BrightnessController{

  static ThemeMode? _mode;


  static final List<void Function()> _listeners = [];

  static void addListener(void Function() listener){
    _listeners.add(listener);
  }

  static void removeListener(void Function() listener){
    _listeners.remove(listener);
  }


  static bool isLight(BuildContext context) => brightness(context) == Brightness.light;
  static bool isDark(BuildContext context) => brightness(context) == Brightness.dark;

  static ThemeMode get mode => _mode!;
  static Brightness brightness(BuildContext context){

    switch(_mode){
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      default:
        throw Exception("Not Initialized");
    }
  }

  static String text(String onSystem, String onLight, String onDark){
    switch(_mode){
      case ThemeMode.system:
        return onSystem;
      case ThemeMode.light:
        return onLight;
      case ThemeMode.dark:
        return onDark;
      default:
        throw Exception("Not Initialized");
    }
  }


  static Brightness reversed(BuildContext context){
     return brightness(context) == Brightness.light? Brightness.dark : Brightness.light;
  }

  static switcher<T>(BuildContext context, T onLight, T onDark){
    return brightness(context) == Brightness.light?onLight:onDark;
  }

  static void _parseFromInt(int? number){
    switch (number){
      case null:
        _mode = ThemeMode.system;
        break;
      case 0:
        _mode = ThemeMode.light;
        break;
      case 1:
        _mode = ThemeMode.dark;
        break;
      default:
        throw Exception("Not Known");
    }
  }

  static Future<void> initialize()async{
    _parseFromInt((await Hive.openBox('default')).get("Brightness"));
  }

  static Future<void> set(ThemeMode mode)async{
    if(mode==ThemeMode.system){
      (await Hive.openBox('default')).delete("Brightness");
    }else{
      (await Hive.openBox('default')).put("Brightness",
          mode == ThemeMode.light?0:
          mode == ThemeMode.dark?1:
          throw Exception("Not Known")
      );
    }
    _mode = mode;

    for(var listener in _listeners){
      listener();
    }
  }


}

