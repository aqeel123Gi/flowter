import 'dart:typed_data';

abstract class BaseSerialCommunication {
  Map<String, dynamic> get readers;
  Map<String, void Function(Uint8List data)> get functions;

  Future<void> initialize();
  List<String> getAvailablePorts();
  void stop(String portPath);
  Future<void> openPort(String portPath, void Function(Uint8List data) onRead,
      {int? baudRate});
}
