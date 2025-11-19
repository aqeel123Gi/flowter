part of 'flowter_bluetooth.dart';

class _IOBluetoothAndroidIosMacos {
  static Future<void> initialize(
      {bool globalListenFromAllNotifiers = false}) async {
    FlowterBluetooth._globalListenFromAllNotifiers =
        globalListenFromAllNotifiers;

    FlowterBluetooth._adapter =
        fromFlutterBluePlusPackage(FlutterBluePlus.adapterStateNow);

    await FlowterBluetooth._setCurrentAuth();

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      FlowterBluetooth._adapter = fromFlutterBluePlusPackage(state);
      for (var element in FlowterBluetooth._bluetoothStateListeners) {
        element(FlowterBluetooth._adapter);
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

    await FlutterBluePlus.stopScan();

    List<XBluetoothDevice> devices = [];

    FlowterBluetooth._isScanning = true;

    StreamSubscription<List<ScanResult>> subscription =
        FlutterBluePlus.onScanResults.listen((results) {
      for (ScanResult r in results) {
        devices.add(XBluetoothDevice.fromFlutterBluePlusPackage(r.device));
      }
    });

    await FlutterBluePlus.startScan(
        timeout: Duration(seconds: seconds), androidUsesFineLocation: true);
    await Future.delayed(Duration(seconds: seconds));

    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    devices = devices.where((e) => e.name != "").toList();
    devices = devices.filterElementsByRepeatedValueIn((e) => e.id);
    if (filterSavedDevices) {
      devices = devices
          .where((e1) => !FlowterBluetoothPairingController.savedDevicesForAutoConnectionList
              .whereHas((e2) => e1.id == e2.id))
          .toList();
    }
    FlowterBluetooth._isScanning = false;

    return devices;
  }

  static List<XBluetoothDevice> get connectedDevices {
    return FlutterBluePlus.connectedDevices
        .map((e) => XBluetoothDevice.fromFlutterBluePlusPackage(e))
        .toList();
  }
}
