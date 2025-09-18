part of 'api.dart';


class ApiResponse{


  final int code;
  final dynamic data;


  // This will executed on processByCode function executed, and no custom override processes by the function argument will be executed
  static Map<int, dynamic Function(dynamic data)> _staticProcessesByCodes = {};
  static setStaticProcessesByCodes(Map<int, dynamic Function(dynamic data)> staticProcesses){
    _staticProcessesByCodes = staticProcesses;
  }

  ApiResponse(this.code, [this.data]);

  T processByCode<T>(Map<int,T Function(dynamic data)> processes){
    if(processes.containsKey(code)){
      return processes[code]!(data);
    }else if(_staticProcessesByCodes.containsKey(code)){
      return _staticProcessesByCodes[code]!(data);
    }
    throw Exception("No process found for code: $code, either in the custom processes or the static processes");
  }

  @override
  String toString() {
    return 'APIResponse{code: $code, data: $data}';
  }
}