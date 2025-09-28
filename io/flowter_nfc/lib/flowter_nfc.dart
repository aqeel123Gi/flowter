import 'dart:io';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_manager/nfc_manager.dart';


class FlowterNFC{

  static bool _runningNFC = false;

  static bool get isNFCRunning =>_runningNFC;

  static void run<T>(
      {
        required void Function(Map<String, dynamic> tagData) onRead,
        required bool Function() pauseWhile,
        required bool Function() stopWhen
      }) async {


    if(Platform.isWindows){
      return;
    }

    if( _runningNFC || !await NfcManager.instance.isAvailable()){
      return;
    }

    if(await FlutterNfcKit.nfcAvailability == NFCAvailability.available) {

      bool onSession = false;

      while(true){
        _runningNFC = true;
        await Future.delayed(const Duration(seconds: 1));
        if(pauseWhile()){
          if(onSession){
            await NfcManager.instance.stopSession();
            onSession = false;
          }
        }else{
          if(!onSession){
            await NfcManager.instance.startSession(onDiscovered: (NfcTag readTag)async{
              if(!stopWhen() && !pauseWhile()){
                dynamic record;
                try{
                  record = readTag.data;
                }catch(_){}
                onRead(record);
              }
            });
          }
          onSession = true;
        }
        if(stopWhen()){
          if(onSession){
            await NfcManager.instance.stopSession();
          }
          _runningNFC = false;
          return;
        }
      }
    }


  }


  static getHEXIdentifierFromTagData(Map<String, dynamic> tagData){

    dynamic tag;

    if(Platform.isIOS){
      tag = tagData['mifare'];
    }else{
      tag = tagData['nfca'];
    }

    return HEX.parseFromIntList(tag['identifier']);
  }
}


class HEX{

  static String parseFromIntList(List<int> data){
    return data.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }
}


