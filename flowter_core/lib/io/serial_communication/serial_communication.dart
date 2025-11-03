import 'dart:io';
import 'dart:typed_data';
import 'src/base_serial_communication.dart';
import 'src/cross_platform_serial_communication.dart' as cross_platform;
import 'src/windows_serial_communication.dart' as windows;

class SerialCommunication {
  // Delegate to the appropriate implementation based on platform
  static final BaseSerialCommunication _impl = Platform.isWindows
      ? windows.WinSerialCommunication()
      : cross_platform.CrossPlatformSerialCommunication();

  static Map<String, dynamic> get readers => _impl.readers;
  static Map<String, void Function(Uint8List data)> get functions =>
      _impl.functions;

  static Future<void> initialize() async {
    return _impl.initialize();
  }

  static List<String> getAvailablePorts() {
    return _impl.getAvailablePorts();
  }

  static void stop(String portPath) {
    _impl.stop(portPath);
  }

  static Future<void> openPort(
      String portPath, void Function(Uint8List data) onRead,
      {int? baudRate}) async {
    return _impl.openPort(portPath, onRead, baudRate: baudRate);
  }

  static void startListening(
      String portPath, void Function(Uint8List data) process) {
    _impl.startListening(portPath, process);
  }

  static void stopListening(String portPath) {
    _impl.stopListening(portPath);
  }
}
