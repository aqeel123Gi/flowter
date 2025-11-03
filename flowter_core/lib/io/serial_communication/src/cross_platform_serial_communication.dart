import 'dart:async';
import 'dart:typed_data';
import 'package:libserialport_plus/libserialport_plus.dart';
import 'base_serial_communication.dart';

class CrossPlatformSerialCommunication implements BaseSerialCommunication {
  Map<String, SerialPortReader> _readers = {};
  Map<String, void Function(Uint8List data)> _functions = {};

  @override
  Map<String, dynamic> get readers => _readers;

  @override
  Map<String, void Function(Uint8List data)> get functions => _functions;

  @override
  Future<void> initialize() async {}

  @override
  List<String> getAvailablePorts() {
    return SerialPort.getAvailablePorts();
  }

  @override
  void stop(String portPath) async {
    _functions.remove(portPath);
  }

  @override
  Future<void> openPort(String portPath, void Function(Uint8List data) onRead,
      {int? baudRate}) async {
    if (!_readers.containsKey(portPath)) {
      SerialPortReader reader = SerialPortReader(SerialPort(portPath));
      // reader.port.config.baudRate = 57600;
      // reader.port.config.bits = 8;
      // reader.port.config.stopBits = 1;
      // reader.port.config.parity = SerialPortParity.none;

      SerialPort port = SerialPort(portPath);
      port.open();

      _readers[portPath] = reader;
      _readers[portPath]!.stream.listen((data) {
        if (_functions.containsKey(portPath)) {
          _functions[portPath]!(data);
        }
      });
    }

    _functions[portPath] = onRead;
  }

  @override
  void startListening(String portPath, void Function(Uint8List data) process) {
    // For cross-platform, listening is handled automatically in openPort
    _functions[portPath] = process;
  }

  @override
  void stopListening(String portPath) {
    // For cross-platform, listening is handled automatically
    _functions.remove(portPath);
  }
}
