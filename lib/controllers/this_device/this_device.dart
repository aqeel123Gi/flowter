import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../functions/contains_substring_for_map.dart';


class ThisDevice{


  static Map<String, dynamic>? info;
  static bool? handleHighGraphicalUI;

  static Future<void> initialize(
      {double leastMaxCPUFrequencyForHighGraphicalUI = 12.0})async{
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    info = deviceInfo.data;
    handleHighGraphicalUI = (await cpuTotalFrequencyInGHz()??12.0)>=leastMaxCPUFrequencyForHighGraphicalUI;
  }

  static String get getModel => info!['model'] ?? '';
  static String get manufacturer => info!['manufacturer'] ?? ' ';
  static bool get isTV => doesMapHaveSubstringForAllValues(info!,"tv",caseSensitive:false);
  static bool get isGate => info!['manufacturer'] == "rockchip";
  static bool get canHandleHighGraphicalUIOrNone => handleHighGraphicalUI==true || handleHighGraphicalUI==null;

  static bool get isHuawei => doesMapHaveSubstringForAllValues(info!,"huawei",caseSensitive:false);

  static Future<double?> cpuTotalFrequencyInGHz () async {

    // For Android Only.
    if(!Platform.isAndroid){
      return null;
    }

    double value = 0;
    // CpuInfo cpuInfo = await CpuReader.cpuInfo;
    // for(var f in cpuInfo.minMaxFrequencies!.values){
    //   value+=f.max/1000;
    // }

    return value;
  }

}

