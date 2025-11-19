library io_bluetooth;

import 'dart:async';
import 'dart:io';
import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/functions/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:win_ble/win_ble.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:win_ble/win_file.dart';


part '_android_ios_macos.dart';
part '_windows.dart';
part 'saved_device.dart';
part '_x_bluetooth_adapter_state.dart';
part 'x_bluetooth_characteristic.dart';
part 'x_bluetooth_device.dart';
part 'x_bluetooth_service.dart';
part 'bluetooth_scanning_requirements.dart';
part 'flowter_bluetooth_pairing_controller.dart';

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
        return _IOBluetoothAndroidIosMacos.connectedDevices;
      case "windows":
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
      default:
        throw Exception("Unsupported platform: ${Platform.operatingSystem}");
    }
  }

  static List<String> get connectedDevicesIds {
    switch (Platform.operatingSystem) {
      case "android":
      case "ios":
      case "macos":
        return _IOBluetoothAndroidIosMacos.connectedDevices
            .map((e) => e.id)
            .toList();
      case "windows":
        return _IOBluetoothWindows.connectedDevicesIds;
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

  
}
