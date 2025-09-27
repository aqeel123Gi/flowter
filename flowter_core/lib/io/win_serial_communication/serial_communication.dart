import 'dart:async';
import 'dart:typed_data';
import 'package:serial_port_win32/serial_port_win32.dart';

class WinSerialCommunication{

  static Map<String,SerialPort> openPorts = {};
  static Map<String,Timer> timers = {};
  static Map<String,void Function(Uint8List data)> functions = {};

  static initialize() async {

  }

  static List<String> getAvailablePorts() {
    return SerialPort.getAvailablePorts();
  }


  static Future<void> openPort(String portPath, int baudRate) async {

    if(!openPorts.containsKey(portPath)){
      SerialPort port = SerialPort(portPath, BaudRate: baudRate);
      if(port.isOpened)port.close();
      port.open();
      openPorts[portPath] = port;
    }

  }

  static Future<void> closePort(String portPath) async {

    if(openPorts.containsKey(portPath)){
      openPorts[portPath]!.close();
      openPorts.remove(portPath);
    }

  }


  static startListening(String portPath, void Function(Uint8List data) process){
    timers[portPath] = Timer.periodic(const Duration(milliseconds: 100), (_)async{
      try{
        final data = await openPorts[portPath]!.readBytes(64, timeout: const Duration(milliseconds: 100));
        if (data.isNotEmpty) {
          process(data);
        }
      }catch(e){
        if(e.toString().contains('ClearCommError')){
          openPorts[portPath]!.close();
          openPorts.remove(portPath);
          stopListening(portPath);
        }
        else{
          rethrow;
        }
      }

    });
  }

  static stopListening(String portPath){
    timers[portPath]?.cancel();
    timers.remove(portPath);
  }

}



