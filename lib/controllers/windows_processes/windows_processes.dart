import 'dart:io';
import '../../functions/functions.dart';


class WindowsProcesses{


  static Future<List<String>> getAllNames() async {
    List<String> stream = await _getProcessesLines;
    stream = stream.map((e) => e.substring(0,26).trim()).toList();

    return stream;
  }

  static Future<bool> hasProcessName(String name) async {
    List<String> names = await getAllNames();
    return names.contains(name);
  }

  static Future<void> exitIfRepeatedAppForWindows(String yourAppProcessName) async {

    if(Platform.isWindows && (await getAllNames()).where((processName) => processName==yourAppProcessName).length>1){
      exit(0);
    }

  }


  static Future<List<int>> getPIdsByName(String name) async{
    List<String> lines = await _getProcessesLines;
    return lines.where((line)=>line.contains(name)).map((line)=>int.parse(line.substring(29,34).trim())).toList();
  }


  static Future<void> executeAppForWindowsOnNewOpenAndExitIfRepeated(String yourAppProcessName,void Function() process) async {

    if(Platform.isWindows){

      // Exit if there are more than one running && delay for 1 second to allow the pre-running app to detect and re-opened.
      if((await getAllNames()).where((processName) => processName.startsWith(yourAppProcessName)).length>1){
        await Future.delayed(const Duration(seconds: 1));
        exit(0);
      }

      // To Open The App if there are others running in the background.
      loopExecution(
        function: ()async{
          if((await getAllNames()).where((processName) => processName.startsWith(yourAppProcessName)).length>1){
            process();
          }
        },
        stopOn: ()=>false,
        breakDuration: const Duration(milliseconds: 600)
      );

    }
  }





  static Future<List<String>> get _getProcessesLines async{
    ProcessResult result = await Process.run('tasklist',[]);
    List<String> stream = (result.stdout as String).split('\n');
    stream = stream.sublist(3,stream.length-1);
    return stream;
  }



}