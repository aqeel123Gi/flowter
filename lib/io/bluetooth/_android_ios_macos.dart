part of 'bluetooth.dart';

class _IOBluetoothAndroidIosMacos {


  static Future<void> initialize({bool globalListenFromAllNotifiers = false}) async {
    IOBluetooth._globalListenFromAllNotifiers = globalListenFromAllNotifiers;

    IOBluetooth._adapter = fromFlutterBluePlusPackage(FlutterBluePlus.adapterStateNow);

    await IOBluetooth._setCurrentAuth();

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      IOBluetooth._adapter = fromFlutterBluePlusPackage(state);
      for (var element in IOBluetooth._bluetoothStateListeners){
        element(IOBluetooth._adapter);
      }
    });

  }






  static Future<void> turnOn() async {
    await FlutterBluePlus.turnOn();
  }






  static Future<void> requestPermissionsForScanningAndConnection() async {
    if (!await Permission.bluetoothScan.isGranted) {
      PermissionStatus status = await Permission.bluetoothScan.request();
      if (!status.isGranted) {
        IOBluetooth._auth = false;
        return;
      }
    }
    if (!await Permission.bluetoothConnect.isGranted) {
      PermissionStatus status = await Permission.bluetoothConnect.request();
      if (!status.isGranted) {
        IOBluetooth._auth = false;
        return;
      }
    }
    if (!await Permission.location.isGranted) {
      PermissionStatus status = await Permission.location.request();
      if (!status.isGranted) {
        IOBluetooth._auth = false;
        return;
      }
    }
    IOBluetooth._auth = true;
  }






  static Future<List<XBluetoothDevice>> scan({required int seconds, bool filterSavedDevices = false}) async {
    if (!IOBluetooth._auth) {
      throw Exception("No Auth");
    }

    await FlutterBluePlus.stopScan();

    List<XBluetoothDevice> devices = [];

    IOBluetooth._isScanning = true;

    StreamSubscription<List<ScanResult>> subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult r in results) {
        devices.add(XBluetoothDevice.fromFlutterBluePlusPackage(r.device));
      }
    });

    await FlutterBluePlus.startScan(timeout: Duration(seconds: seconds),androidUsesFineLocation: true);
    await Future.delayed(Duration(seconds: seconds));

    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    devices = devices.where((e) => e.name != "").toList();
    devices = devices.filterElementsByRepeatedValueIn((e) => e.id);
    if(filterSavedDevices){
      devices = devices.where((e1) => !IOBluetooth.savedDevicesForAutoConnectionList.whereHas((e2) => e1.id == e2.id)).toList();
    }
    IOBluetooth._isScanning = false;

    return devices;
  }






  static List<XBluetoothDevice> get paired {
    return FlutterBluePlus.connectedDevices.map((e) => XBluetoothDevice.fromFlutterBluePlusPackage(e)).toList();
  }


}