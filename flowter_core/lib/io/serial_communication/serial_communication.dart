// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter_libserialport/flutter_libserialport.dart';
//
//
// class SerialCommunication{
//   //TODO: cant reopen port or listener, so It's just removing the function.
//
//   static Map<String,SerialPortReader> readers = {};
//   static Map<String,void Function(Uint8List data)> functions = {};
//
//   static initialize() async {
//   }
//
//   static List<String> getAvailablePorts() {
//     return SerialPort.availablePorts;
//   }
//
//
//   static void stop(String portPath)async{
//     functions.remove(portPath);
//   }
//
//   static Future<void> openPort(String portPath,void Function(Uint8List data) onRead) async {
//
//     if(!readers.containsKey(portPath)){
//
//       SerialPortReader reader = SerialPortReader(SerialPort(portPath));
//       // reader.port.config.baudRate = 57600;
//       // reader.port.config.bits = 8;
//       // reader.port.config.stopBits = 1;
//       // reader.port.config.parity = SerialPortParity.none;
//       reader.port.openRead();
//
//
//       readers[portPath] = reader;
//       readers[portPath]!.stream.listen((data){
//         if(functions.containsKey(portPath)){
//           functions[portPath]!(data);
//         }
//       });
//
//     }
//
//     functions[portPath] = onRead;
//
//   }
//
// }
//
//
//
