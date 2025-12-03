import 'dart:io';

import 'package:flowter_python/src/flowter_python_os_interface.dart';
import 'package:flowter_python/src/flowter_python_windows.dart';

class FlowterPython {
  static late final FlowterPythonOsInterface _osInterface;

  static Future<void> initialize() async {
    if (Platform.isWindows) {
      _osInterface = FlowterPythonWindows();
      await _osInterface.initialize();
    }
  }

  static Future<List<String>> installedPackages() async {
    return await _osInterface.installedPackages();
  }

  static Future<void> installPackage(String packageName) async {
    await _osInterface.installPackage(packageName);
  }
}
