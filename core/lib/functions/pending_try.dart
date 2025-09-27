import 'package:flowter/classes/on_off.dart';

Future<T> pendingTry<T>({
  required Future<T> Function() process,
  required void Function() onStarted,
  required void Function() onFinished,
})async{
  onStarted();
  try{
    T data = await process();
    onFinished();
    return data;
  }catch(_){
    onFinished();
    rethrow;
  }
}



Future<T> pendingOnOffTry<T>({
  required OnOff onOff,
  required void Function() updateState,
  required Future<T> Function() process,
})async{
  onOff.value = true;
  updateState();
  try{
    T data = await process();
    onOff.value = false;
    updateState();
    return data;
  }catch(_){
    onOff.value = false;
    updateState();
    rethrow;
  }
}