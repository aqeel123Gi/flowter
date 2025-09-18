part of 'bluetooth.dart';

class _IOBluetoothWindows {


  static Future<void> initialize({bool globalListenFromAllNotifiers = false}) async {

    await WinBle.initialize(serverPath: await WinServer.path());

    IOBluetooth._globalListenFromAllNotifiers = globalListenFromAllNotifiers;

    IOBluetooth._adapter = fromWinBlePackage(await WinBle.getBluetoothState());
    await IOBluetooth._setCurrentAuth();


    WinBle.bleState.listen((state) {
      IOBluetooth._adapter = fromWinBlePackage(state);
      for (var element in IOBluetooth._bluetoothStateListeners){
        element(IOBluetooth._adapter);
      }
    });


    WinBle.connectionStream.listen((event) {
      if(event['connected'] == true){
        _pairedIds.add(event['device']);
      }else{
        _pairedIds.remove(event['device']);
      }
    });

  }






  // static Future<void> turnOn() async {
  // }






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

    WinBle.stopScanning();

    List<XBluetoothDevice> devices = [];

    IOBluetooth._isScanning = true;

    WinBle.scanStream.listen((scanResult) {
      devices.add(XBluetoothDevice.fromUniversalBlePackage(scanResult));
    });

    WinBle.startScanning();
    await Future.delayed(Duration(seconds: seconds));

    WinBle.stopScanning();

    devices = devices.where((e) => e.name != "").toList();
    devices = devices.filterElementsByRepeatedValueIn((e) => e.id);
    if(filterSavedDevices){
      devices = devices.where((e1) => !IOBluetooth.savedDevicesForAutoConnectionList.whereHas((e2) => e1.id == e2.id)).toList();
    }
    IOBluetooth._isScanning = false;

    return devices;
  }




  static final List<String> _pairedIds = [];
  static List<String> get pairedIds => _pairedIds;


}