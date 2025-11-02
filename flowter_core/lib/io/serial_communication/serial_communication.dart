import 'dart:async';
import 'dart:typed_data';
import 'package:libserialport_plus/libserialport_plus.dart';

class SerialCommunication {
  static Map<String, SerialPortReader> readers = {};
  static Map<String, void Function(Uint8List data)> functions = {};

  static initialize() async {}

  static List<String> getAvailablePorts() {
    return SerialPort.getAvailablePorts();
  }

  static void stop(String portPath) async {
    functions.remove(portPath);
  }

  static Future<void> openPort(
      String portPath, void Function(Uint8List data) onRead) async {
    if (!readers.containsKey(portPath)) {
      SerialPortReader reader = SerialPortReader(SerialPort(portPath));
      // reader.port.config.baudRate = 57600;
      // reader.port.config.bits = 8;
      // reader.port.config.stopBits = 1;
      // reader.port.config.parity = SerialPortParity.none;

      SerialPort port = SerialPort(portPath);
      port.open();

      readers[portPath] = reader;
      readers[portPath]!.stream.listen((data) {
        if (functions.containsKey(portPath)) {
          functions[portPath]!(data);
        }
      });
    }

    functions[portPath] = onRead;
  }
}
