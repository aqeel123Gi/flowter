part of 'api.dart';

class ApiResponse {
  final ApiController apiController;
  final int code;
  final dynamic data;

  ApiResponse(this.apiController, this.code, [this.data]);

  T processByCode<T>(Map<int, T Function(dynamic data)> processes) {
    if (processes.containsKey(code)) {
      return processes[code]!(data);
    } else if (apiController.overridenResponseProcessesByCodes
        .containsKey(code)) {
      return apiController.overridenResponseProcessesByCodes[code]!(data);
    }
    throw Exception(
        "No process found for code: $code, either in the custom processes or the static processes");
  }

  @override
  String toString() {
    return 'APIResponse{code: $code, data: $data}';
  }
}
