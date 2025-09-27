library io_bluetooth;

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:win_ble/win_ble.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flowter_core/flowter_core.dart';
import 'package:win_ble/win_file.dart';

part '_android_ios_macos.dart';
part '_windows.dart';

part 'saved_device.dart';

part '_x_bluetooth_adapter_state.dart';
part 'x_bluetooth_characteristic.dart';
part 'x_bluetooth_device.dart';
part 'x_bluetooth_service.dart';

class FlowterBluetooth {
  static bool _initialized = false;
  static bool get initialized => _initialized;

  static late XBluetoothAdapterState _adapter;
  static XBluetoothAdapterState get adapterState => _adapter;

  static late bool _auth;
  static bool get authorizedScanningAndConnection => _auth;

  static bool _isScanning = false;
  static bool get isScanning => _isScanning;

  static Map<XBluetoothDevice, List<void Function(List<int> notifiedData)>>
      notifiersListeners = {};

  static List<void Function(List<int> notifiedData)> globalNotifiersListeners =
      [];

  static final List<void Function(XBluetoothAdapterState state)>
      _bluetoothStateListeners = [];

  static void addBluetoothStateListener(
      void Function(XBluetoothAdapterState state) function) {
    _bluetoothStateListeners.add(function);
  }

  static void removeBluetoothStateListener(
      void Function(XBluetoothAdapterState state) function) {
    _bluetoothStateListeners.remove(function);
  }

  static bool _globalListenFromAllNotifiers = false;

  static Future<void> _setCurrentAuth() async {
    if (Platform.isIOS) {
      _auth = _adapter != XBluetoothAdapterState.unauthorized;
    } else {
      _auth = await Permission.bluetoothScan.isGranted &&
          await Permission.bluetoothConnect.isGranted &&
          await Permission.location.isGranted;
    }
  }

  static Future<void> initialize(
      {bool globalListenFromAllNotifiers = false}) async {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        await _IOBluetoothAndroidIosMacos.initialize(
            globalListenFromAllNotifiers: globalListenFromAllNotifiers);
        _initialized = true;
        break;
      case "windows":
        await _IOBluetoothWindows.initialize(
            globalListenFromAllNotifiers: globalListenFromAllNotifiers);
        _initialized = true;
        break;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static Future<void> turnOn() async {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        await _IOBluetoothAndroidIosMacos.turnOn();
        break;
      case "windows":
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static Future<void> requestPermissionsForScanningAndConnection() async {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        await _IOBluetoothAndroidIosMacos
            .requestPermissionsForScanningAndConnection();
        break;
      case "windows":
        await _IOBluetoothWindows.requestPermissionsForScanningAndConnection();
        break;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static Future<BluetoothScanningRequirements>
      getBluetoothScanningRequirements() async {
    return await BluetoothScanningRequirements._check();
  }

  static Future<List<XBluetoothDevice>> scan(
      {required int seconds, bool filterSavedDevices = false}) async {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        return await _IOBluetoothAndroidIosMacos.scan(
            seconds: seconds, filterSavedDevices: filterSavedDevices);
      case "windows":
        return await _IOBluetoothWindows.scan(
            seconds: seconds, filterSavedDevices: filterSavedDevices);
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static List<XBluetoothDevice> get paired {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        return _IOBluetoothAndroidIosMacos.paired;
      case "windows":
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static List<String> get pairedIds {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        return _IOBluetoothAndroidIosMacos.paired.map((e) => e.id).toList();
      case "windows":
        return _IOBluetoothWindows.pairedIds;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static Future<bool> connect(XBluetoothDevice device) async {
    if (FlowterBluetooth._adapter == XBluetoothAdapterState.off) {
      throw Exception("Bluetooth is off");
    }
    try {
      await device.connect();
      if (FlowterBluetooth._globalListenFromAllNotifiers) {
        setAllNotifiersOfDeviceAsTrueForGlobalListeners(device);
      }
      return true;
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      return false;
    }
  }

  static Future<bool> disconnect(String deviceId) async {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        try {
          await FlutterBluePlus.connectedDevices
              .firstWhere((e) => e.remoteId.str == deviceId)
              .disconnect();
          return true;
        } catch (e, s) {
          if (kDebugMode) {
            print(e);
            print(s);
          }
          return false;
        }
      case "windows":
        await WinBle.disconnect(deviceId);
        return true;
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static Future<void> setAllNotifiersOfDeviceAsTrueForGlobalListeners(
      XBluetoothDevice device) async {
    List<XBluetoothService> services = await device.services;
    for (XBluetoothService service in services) {
      for (XBluetoothCharacteristic characteristic
          in await service.characteristics) {
        if (par(characteristic.hasNotificationProperty, "PROPERTY")) {
          await characteristic.applyNotification();
          characteristic.addNotificationListener((data) {
            for (var listener in globalNotifiersListeners) {
              listener(data);
            }
          });
        }
      }
    }
  }

  static void addListenerOnNotifierServiceOfDevice(XBluetoothDevice device,
      void Function(List<int> notifiedData) listener) async {
    if (!notifiersListeners.containsKey(device)) {
      notifiersListeners[device] = [listener];
    } else {
      notifiersListeners[device]!.add(listener);
    }
  }

  // [Auto Connection Management]
  //
  //
  //

  static bool _pausedAutoConnection = false;
  static bool _stopAutoConnection = true;

  static late List<SavedDevice> _savedDevicesForAutoConnectionList;
  static List<SavedDevice> get savedDevicesForAutoConnectionList =>
      _savedDevicesForAutoConnectionList.copy;

  static Map<SavedDevice, bool> get getSavedDevicesStates {
    Map<SavedDevice, bool> map = {};
    for (SavedDevice savedDevice in _savedDevicesForAutoConnectionList) {
      map[savedDevice] = isSavedDeviceConnected(savedDevice);
    }
    return map;
  }

  static Future<void> renameSavedDevice(
      SavedDevice savedDevice, String newName) async {
    savedDevice.name = newName;
    await _saveDevices();
  }

  static Future<void> startAutoConnection(
      {void Function(SavedDevice savedDevice, XBluetoothDevice connectedDevice)?
          onConnected}) async {
    _stopAutoConnection = false;
    await _getDevices();
    loopExecution(
        function: () async => await _autoConnect(onConnected),
        stopOn: () => _stopAutoConnection,
        breakDuration: const Duration(seconds: 5));
  }

  static Future<void> _autoConnect(
      [void Function(SavedDevice savedDevice, XBluetoothDevice connectedDevice)?
          onConnected]) async {
    //print("AutoConnect: Saved Devices: ${_savedDevicesForAutoConnectionList.length}");
    if (_savedDevicesForAutoConnectionList.isNotEmpty &&
        !_pausedAutoConnection &&
        adapterState == XBluetoothAdapterState.on) {
      // Get not connected Devices :
      List<SavedDevice> notConnectedDevices =
          (await _savedDevicesForAutoConnectionList
                  .whereAsync((savedDevice) async {
        if (isSavedDeviceConnected(savedDevice)) {
          return false;
        }
        return true;
      }))
              .toList();
      // Try Connect devices :
      for (SavedDevice savedDevice in notConnectedDevices) {
        List<XBluetoothDevice> devices = await scan(seconds: 2);
        if (devices.isNotEmpty) {
          XBluetoothDevice? device =
              devices.tryFirstWhere((element) => element.id == savedDevice.id);
          if (device != null && await connect(device) && onConnected != null) {
            onConnected(notConnectedDevices.first, device);
          }
        }
      }
    }
  }

  static bool isSavedDeviceConnected(SavedDevice savedDevice) =>
      pairedIds.any((id) => id == savedDevice.id);

  static void resumeAutoConnection() {
    _pausedAutoConnection = false;
  }

  static void pauseAutoConnection() {
    _pausedAutoConnection = true;
  }

  static void stopAutoConnection() {
    _stopAutoConnection = true;
  }

  static Future<bool> connectAndAddToAutoConnectionList(
      XBluetoothDevice device, String name) async {
    if (await connect(device)) {
      _savedDevicesForAutoConnectionList
          .add(SavedDevice(id: device.id, name: name, type: DeviceType.uhf));
      await _saveDevices();
      return true;
    } else {
      return false;
    }
  }

  static Future<void> disconnectAllSavedDevicesAndRemoveFromAutoConnectionList()async{
    List<SavedDevice> devices = savedDevicesForAutoConnectionList;
    for (SavedDevice savedDevice in devices) {
      await disconnectAndRemoveFromAutoConnectionList(savedDevice);
    }
  }


  static Future<bool> disconnectAndRemoveFromAutoConnectionList(SavedDevice savedDevice)async{
    if(!isSavedDeviceConnected(savedDevice) || await disconnect(pairedIds.firstWhere((id) => id == savedDevice.id))){
      _savedDevicesForAutoConnectionList.remove(savedDevice);
      await _saveDevices();
      return true;
    }else{
      return false;
    }
  }

  // TODO: Check why exists:
  static Future<void> removeFromAutoConnectionList(
      String deviceID, BluetoothDevice device) async {
    _savedDevicesForAutoConnectionList
        .removeWhere((savedDevice) => savedDevice.id == (deviceID));
    await _saveDevices();
  }

  static Future<void> _saveDevices() async {
    Box box = await Hive.openBox("io_bluetooth");
    List data = [];
    for (var e in _savedDevicesForAutoConnectionList) {
      data.add(e.toMap());
    }
    await box.put("auto_connection_list", data);
  }

  static Future<void> _getDevices() async {
    Box box = await Hive.openBox("io_bluetooth");
    List data = par(box.get("auto_connection_list")) ?? [];
    _savedDevicesForAutoConnectionList = [];
    for (var e in data) {
      _savedDevicesForAutoConnectionList.add(SavedDevice.fromMap(e));
    }
  }
}

class BluetoothScanningRequirements {
  BluetoothScanningRequirements._({
    // required this.hasNearDevicesAccessPermission,
    required this.hasLocationAccessPermission,
    required this.isBluetoothAuthorized,
    required this.isBluetoothOn,
    required this.isLocationOn,
  });

  // late final bool hasNearDevicesAccessPermission;
  late final bool hasLocationAccessPermission;
  late final bool isBluetoothAuthorized;
  late final bool isBluetoothOn;
  late final bool isLocationOn;

  static Future<BluetoothScanningRequirements> _check() async {
    return BluetoothScanningRequirements._(
      hasLocationAccessPermission: (await Geolocator.checkPermission()).on(
        (permission) {
          return permission != LocationPermission.denied && permission != LocationPermission.deniedForever;
        }
      ),
      isBluetoothAuthorized: FlowterBluetooth.authorizedScanningAndConnection,
      isBluetoothOn: FlowterBluetooth.adapterState == XBluetoothAdapterState.on,
      isLocationOn: await Geolocator.isLocationServiceEnabled(),
    );
  }

  bool get completed =>
      hasLocationAccessPermission &&
      isBluetoothAuthorized &&
      isBluetoothOn &&
      isLocationOn;
}
