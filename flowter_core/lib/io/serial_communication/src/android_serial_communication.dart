import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';
import 'base_serial_communication.dart';

class AndroidSerialCommunication implements BaseSerialCommunication {
  Map<String, UsbPort> openPorts = {};
  Map<String, StreamSubscription<Uint8List>> subscriptions = {};
  Map<String, void Function(Uint8List data)> callbackFunctions = {};

  @override
  Map<String, dynamic> get readers => openPorts;

  @override
  Map<String, void Function(Uint8List data)> get functions => callbackFunctions;

  @override
  Future<void> initialize() async {
    // USB serial doesn't need explicit initialization
  }

  @override
  Future<List<String>> getAvailablePorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    // Return device identifiers (vendorId:productId or device name)
    return devices.map((device) => '${device.vid}:${device.pid}').toList();
  }

  @override
  void stop(String portPath) {
    stopListening(portPath);
    callbackFunctions.remove(portPath);
  }

  @override
  Future<void> openPort(String portPath, {int? baudRate}) async {
    if (!openPorts.containsKey(portPath)) {
      List<UsbDevice> devices = await UsbSerial.listDevices();

      // Parse portPath as vendorId:productId format
      List<String> parts = portPath.split(':');
      if (parts.length != 2) {
        throw Exception(
            'Invalid port path format. Expected "vendorId:productId"');
      }

      int vid = int.parse(parts[0]);
      int pid = int.parse(parts[1]);

      UsbDevice device;
      try {
        device = devices.firstWhere(
          (d) => d.vid == vid && d.pid == pid,
        );
      } catch (e) {
        throw Exception('Device not found: $portPath');
      }

      UsbPort? port = await device.create();
      if (port == null) {
        throw Exception('Failed to create port: $portPath');
      }

      bool openResult = await port.open();
      if (!openResult) {
        throw Exception('Failed to open port: $portPath');
      }

      // Configure the port
      await port.setDTR(true);
      await port.setRTS(true);

      // Set baud rate if provided, otherwise use default
      int baud = baudRate ?? 57600;
      await port.setPortParameters(
        baud,
        8, // dataBits
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      openPorts[portPath] = port;
    }
  }

  @override
  void startListening(String portPath, void Function(Uint8List data) process) {
    if (!openPorts.containsKey(portPath)) {
      throw Exception('Port not opened: $portPath');
    }

    callbackFunctions[portPath] = process;

    // Cancel existing subscription if any
    subscriptions[portPath]?.cancel();

    // Listen to incoming data
    UsbPort port = openPorts[portPath]!;
    StreamSubscription<Uint8List>? subscription = port.inputStream?.listen(
      (data) {
        if (callbackFunctions.containsKey(portPath)) {
          callbackFunctions[portPath]!(data);
        }
      },
      onError: (error) {
        // Handle error - might need to clean up
        stopListening(portPath);
      },
      cancelOnError: false,
    );

    if (subscription != null) {
      subscriptions[portPath] = subscription;
    }
  }

  @override
  void stopListening(String portPath) {
    subscriptions[portPath]?.cancel();
    subscriptions.remove(portPath);
    callbackFunctions.remove(portPath);

    if (openPorts.containsKey(portPath)) {
      openPorts[portPath]!.close();
      openPorts.remove(portPath);
    }
  }
}
