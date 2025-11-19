part of 'flowter_bluetooth.dart';

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