part of 'flowter_bluetooth.dart';


class XBluetoothService{


  late final XBluetoothDevice device;


  late final BluetoothService service;
  late final String service2;


  static XBluetoothService fromFlutterBluePlusPackage(XBluetoothDevice device, BluetoothService service){
    return XBluetoothService()
      ..device = device
      ..service = service;
  }

  static XBluetoothService fromWinBlePackage(XBluetoothDevice device, String service){
    return XBluetoothService()
      ..device = device
      ..service2 = service;
  }


  String get id{
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        return service.remoteId.str;
      case "windows":
        return service2;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }





  Future<List<XBluetoothCharacteristic>> get characteristics async{
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        return service.characteristics.map((c) => XBluetoothCharacteristic.fromFlutterBluePlusPackage(this,c)).toList();
      case "windows":
        List<BleCharacteristic> list = await WinBle.discoverCharacteristics(address: device.id, serviceId: service2);
        return list.map((c) => XBluetoothCharacteristic.fromWinBlePackage(this,c)).toList();
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }





}