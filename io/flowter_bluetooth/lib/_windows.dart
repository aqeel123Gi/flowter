part of 'flowter_bluetooth.dart';

class _IOBluetoothWindows {
  static Future<void> initialize(
      {bool globalListenFromAllNotifiers = false}) async {
    await WinBle.initialize(serverPath: await WinServer.path());

    FlowterBluetooth._globalListenFromAllNotifiers =
        globalListenFromAllNotifiers;

    FlowterBluetooth._adapter =
        fromWinBlePackage(await WinBle.getBluetoothState());
    await FlowterBluetooth._setCurrentAuth();

    WinBle.bleState.listen((state) {
      FlowterBluetooth._adapter = fromWinBlePackage(state);
      for (var element in FlowterBluetooth._bluetoothStateListeners) {
        element(FlowterBluetooth._adapter);
      }
    });

    WinBle.connectionStream.listen((event) {
      if (event['connected'] == true) {
        _connectedDevicesIds.add(event['device']);
      } else {
        _connectedDevicesIds.remove(event['device']);
      }
    });
  }

  // static Future<void> turnOn() async {
  // }

  static Future<void> requestPermissionsForScanningAndConnection() async {
    if (!await Permission.bluetoothScan.isGranted) {
      PermissionStatus status = await Permission.bluetoothScan.request();
      if (!status.isGranted) {
        FlowterBluetooth._auth = false;
        return;
      }
    }
    if (!await Permission.bluetoothConnect.isGranted) {
      PermissionStatus status = await Permission.bluetoothConnect.request();
      if (!status.isGranted) {
        FlowterBluetooth._auth = false;
        return;
      }
    }
    if (!await Permission.location.isGranted) {
      PermissionStatus status = await Permission.location.request();
      if (!status.isGranted) {
        FlowterBluetooth._auth = false;
        return;
      }
    }
    FlowterBluetooth._auth = true;
  }

  static Future<List<XBluetoothDevice>> scan(
      {required int seconds, bool filterSavedDevices = false}) async {
    if (!FlowterBluetooth._auth) {
      throw Exception("No Auth");
    }

    WinBle.stopScanning();

    List<XBluetoothDevice> devices = [];

    FlowterBluetooth._isScanning = true;

    WinBle.scanStream.listen((scanResult) {
      devices.add(XBluetoothDevice.fromUniversalBlePackage(scanResult));
    });

    WinBle.startScanning();
    await Future.delayed(Duration(seconds: seconds));

    WinBle.stopScanning();

    devices = devices.where((e) => e.name != "").toList();
    devices = devices.filterElementsByRepeatedValueIn((e) => e.id);
    // if(filterSavedDevices){
    //   devices = devices.where((e1) => !FlowterBluetoothPairingController.savedDevicesForAutoConnectionList.whereHas((e2) => e1.id == e2.id)).toList();
    // }
    FlowterBluetooth._isScanning = false;

    return devices;
  }

  static final List<String> _connectedDevicesIds = [];
  static List<String> get connectedDevicesIds => _connectedDevicesIds.copy;
}
