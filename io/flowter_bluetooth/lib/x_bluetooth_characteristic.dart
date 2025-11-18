part of 'flowter_bluetooth.dart';



class XBluetoothCharacteristic{

  late final XBluetoothService service;

  late final BluetoothCharacteristic characteristic;
  late final BleCharacteristic characteristic2;


  static XBluetoothCharacteristic fromFlutterBluePlusPackage(XBluetoothService service, BluetoothCharacteristic characteristic){
    return XBluetoothCharacteristic()
      ..service = service
      ..characteristic = characteristic;
  }

  static XBluetoothCharacteristic fromWinBlePackage(XBluetoothService service, BleCharacteristic characteristic){
    return XBluetoothCharacteristic()
      ..service = service
      ..characteristic2 = characteristic;
  }


  get getUuid{
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        return characteristic.uuid.str;
      case "windows":
        return characteristic2.uuid;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }






  bool get hasNotificationProperty{
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        return characteristic.properties.notify;
      case "windows":
        return characteristic2.properties.notify!;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }






  Future<void> applyNotification()async {
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        await characteristic.setNotifyValue(true);
        break;
      case "windows":
        try{
          await WinBle.unSubscribeFromCharacteristic(address: service.device.id, serviceId: service.id, characteristicId: characteristic2.uuid);
        }catch(_){}
        await WinBle.subscribeToCharacteristic(address: service.device.id, serviceId: service.id, characteristicId: characteristic2.uuid);
        break;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }






  void addNotificationListener(void Function(List<int> data) listener) {
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        characteristic.onValueReceived.listen(listener);
        break;
      case "windows":
        WinBle.characteristicValueStreamOf(address: service.device.id, serviceId: service.id, characteristicId: characteristic2.uuid).listen((data){
            listener((data as List).toType<int>());
        });
        break;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }


  Future<void> write(List<int> data, bool withResponse) async {
    switch(Platform.operatingSystem){
      case "android":
      case "ios":
      case "macos":
        await characteristic.write(data,withoutResponse: !withResponse);
        break;
      case "windows":
        await WinBle.write(
            address: service.device.id,
            service: service.id,
            characteristic: characteristic2.uuid,
            data: Uint8List.fromList(data),
            writeWithResponse: withResponse
        );
        break;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

}