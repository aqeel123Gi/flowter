part of 'flowter_bluetooth.dart';

class FlowterBluetoothPairingController {
  /// If the controller is initialized.
  static bool get initialized => _initialized;
  static bool _initialized = false;

  /// Called when a paired device is connected.
  static void Function(
          BluePairedDevice savedDevice, XBluetoothDevice connectedDevice)?
      _onConnected;

  /// Called when a paired device is disconnected.
  static void Function(BluePairedDevice savedDevice)? _onDisconnected;

  /// List of devices that are paired and will be auto connected.
  static List<BluePairedDevice> get savedDevicesForAutoConnectionList =>
      _savedDevicesForAutoConnectionList.copy;
  static late List<BluePairedDevice> _savedDevicesForAutoConnectionList;

  /// Map of devices that are paired and their connection state.
  static Map<BluePairedDevice, bool> get getSavedDevicesWithConnectionStates {
    return _savedDevicesForAutoConnectionList.toMap(
      keyFrom: (index, e) => e,
      valueFrom: (index, e) => isPairedDeviceConnected(e),
    );
  }

  /// Get the connected paired devices.
  static List<BluePairedDevice> get getConnectedPairedDevices {
    return (_savedDevicesForAutoConnectionList.where(isPairedDeviceConnected))
        .toList();
  }

  /// Get the not connected paired devices.
  static List<BluePairedDevice> get getNotConnectedPairedDevices {
    return _savedDevicesForAutoConnectionList
        .where((element) => !isPairedDeviceConnected(element))
        .toList();
  }

  /// Rename a saved device.
  static void renameSavedDevice(BluePairedDevice savedDevice, String newName) {
    savedDevice.name = newName;
    _savePairedDevices();
  }

  /// Start the auto connection process.
  static void start({
    /// Called when a device is connected either paired before or paired newly.
    void Function(
            BluePairedDevice savedDevice, XBluetoothDevice connectedDevice)?
        onConnected,

    /// Called when a device is disconnected either paired before or paired newly.
    void Function(BluePairedDevice savedDevice)? onDisconnected,

    /// Duration between each auto connection attempt.
    Duration autoConnectionBreakDuration = const Duration(seconds: 2),
  }) async {
    // Check if the controller is already initialized.
    if (initialized) {
      throw Exception("Controller already initialized");
    }
    // Set the paired devices from memory.
    await _setPaierdDevicesFromMemory();

    _initialized = true;

    // Set the on connected and on disconnected callbacks.
    _onConnected = onConnected;
    _onDisconnected = onDisconnected;

    // Start the auto connection process.
    loopExecution(
        function: () async => await _autoConnect(),
        stopOn: () => false,
        breakDuration: autoConnectionBreakDuration);
  }

  /// List of devices that are pre connected.
  static List<XBluetoothDevice> _preConnectedDevices = [];

  /// Auto connect the paired devices.
  static Future<void> _autoConnect() async {
    if (_savedDevicesForAutoConnectionList.isNotEmpty &&
        FlowterBluetooth.adapterState == XBluetoothAdapterState.on) {
      // Get scanned devices
      List<XBluetoothDevice> scannedDevices =
          await FlowterBluetooth.scan(seconds: 2);

      await _tryConnectNotConnectedPairedDevices(scannedDevices);
      await _checkDisconnectedPreConnectedDevices();
    }
  }

  /// Try connect not connected paired devices.
  static Future<void> _tryConnectNotConnectedPairedDevices(
      List<XBluetoothDevice> scannedDevices) async {
    for (BluePairedDevice notConnectedDevice in getNotConnectedPairedDevices) {
      XBluetoothDevice? device = scannedDevices
          .tryFirstWhere((element) => element.id == notConnectedDevice.id);
      if (device != null && await FlowterBluetooth.connect(device)) {
        _preConnectedDevices.add(device);
        _onConnected?.call(notConnectedDevice, device);
      }
    }
  }

  /// Try disconnect pre connected devices.
  static Future<void> _checkDisconnectedPreConnectedDevices() async {
    for (XBluetoothDevice device in _preConnectedDevices.copy) {
      if (!FlowterBluetooth.connectedDevicesIds.any((id) => id == device.id)) {
        _preConnectedDevices.remove(device);
        _onDisconnected?.call(_savedDevicesForAutoConnectionList
            .tryFirstWhere((element) => element.id == device.id)!);
      }
    }
  }

  /// Check if a paired device is connected.
  static bool isPairedDeviceConnected(BluePairedDevice pairedDevice) =>
      FlowterBluetooth.connectedDevicesIds.any((id) => id == pairedDevice.id);

  /// Add a device to the auto connection list.
  static void addToAutoConnectionList(String deviceId, String name) async {
    if (!_initialized) {
      throw Exception("Controller is not initialized");
    }

    // Add the device to the auto connection list.
    _savedDevicesForAutoConnectionList
        .add(BluePairedDevice(id: deviceId, name: name));
    _savePairedDevices();
  }

  /// Remove a device from the auto connection list.
  static void removeFromAutoConnectionList(String deviceId) {
    if (!_initialized) {
      throw Exception("Controller is not initialized");
    }

    // Remove the device from the auto connection list.
    _savedDevicesForAutoConnectionList
        .removeWhere((element) => element.id == deviceId);
    _savePairedDevices();
  }

  /// Clear all paired devices from the auto connection list.
  static void clearAllPairedDevices() {
    _savedDevicesForAutoConnectionList = [];
    _savePairedDevices();
  }

  static Future<void> _savePairedDevices() async {
    Box box = await Hive.openBox("io_bluetooth");
    List data = [];
    for (var e in _savedDevicesForAutoConnectionList) {
      data.add(e.toMap());
    }
    await box.put("auto_connection_list", data);
  }

  static Future<void> _setPaierdDevicesFromMemory() async {
    Box box = await Hive.openBox("io_bluetooth");
    List data = par(box.get("auto_connection_list")) ?? [];
    _savedDevicesForAutoConnectionList = [];
    for (var e in data) {
      _savedDevicesForAutoConnectionList.add(BluePairedDevice.fromMap(e));
    }
  }
}
