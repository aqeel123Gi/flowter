part of 'bluetooth.dart';


enum XBluetoothAdapterState{
  disabled,
  unavailable,
  unknown,
  unauthorized,
  turningOn,
  on,
  turningOff,
  off
}



XBluetoothAdapterState fromFlutterBluePlusPackage(BluetoothAdapterState state){
  switch(state){
    case BluetoothAdapterState.unknown:
      return XBluetoothAdapterState.unknown;
    case BluetoothAdapterState.unauthorized:
      return XBluetoothAdapterState.unauthorized;
    case BluetoothAdapterState.turningOn:
      return XBluetoothAdapterState.turningOn;
    case BluetoothAdapterState.on:
      return XBluetoothAdapterState.on;
    case BluetoothAdapterState.turningOff:
      return XBluetoothAdapterState.turningOff;
    case BluetoothAdapterState.off:
      return XBluetoothAdapterState.off;
    case BluetoothAdapterState.unavailable:
      return XBluetoothAdapterState.unavailable;
  }
}




XBluetoothAdapterState fromWinBlePackage(BleState state){
  switch(state){
    case BleState.Unknown:
      return XBluetoothAdapterState.unknown;
    case BleState.On:
      return XBluetoothAdapterState.on;
    case BleState.Off:
      return XBluetoothAdapterState.off;
    case BleState.Unsupported:
      return XBluetoothAdapterState.unavailable;
    case BleState.Disabled:
      return XBluetoothAdapterState.disabled;
  }
}