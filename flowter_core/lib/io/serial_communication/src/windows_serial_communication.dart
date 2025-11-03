import 'dart:async';
import 'dart:typed_data';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'base_serial_communication.dart';

class WinSerialCommunication implements BaseSerialCommunication {
  Map<String, SerialPort> openPorts = {};
  Map<String, Timer> timers = {};
  Map<String, void Function(Uint8List data)> callbackFunctions = {};

  // For compatibility with the main interface
  @override
  Map<String, dynamic> get readers => {};

  @override
  Map<String, void Function(Uint8List data)> get functions => callbackFunctions;

  @override
  Future<void> initialize() async {}

  @override
  List<String> getAvailablePorts() {
    return SerialPort.getAvailablePorts();
  }

  @override
  void stop(String portPath) async {
    stopListening(portPath);
    callbackFunctions.remove(portPath);
  }

  @override
  Future<void> openPort(String portPath, void Function(Uint8List data) onRead,
      {int? baudRate}) async {
    if (!openPorts.containsKey(portPath)) {
      SerialPort port = SerialPort(portPath, BaudRate: baudRate ?? 57600);
      if (port.isOpened) port.close();
      port.open();
      openPorts[portPath] = port;
    }

    callbackFunctions[portPath] = onRead;
    startListening(portPath, onRead);
  }

  startListening(String portPath, void Function(Uint8List data) process) {
    timers[portPath] =
        Timer.periodic(const Duration(milliseconds: 100), (_) async {
      try {
        final data = await openPorts[portPath]!
            .readBytes(64, timeout: const Duration(milliseconds: 100));
        if (data.isNotEmpty) {
          process(data);
        }
      } catch (e) {
        if (e.toString().contains('ClearCommError')) {
          openPorts[portPath]!.close();
          openPorts.remove(portPath);
          stopListening(portPath);
        } else {
          rethrow;
        }
      }
    });
  }

  stopListening(String portPath) {
    timers[portPath]?.cancel();
    timers.remove(portPath);
    if (openPorts.containsKey(portPath)) {
      openPorts[portPath]!.close();
      openPorts.remove(portPath);
    }
  }
}
