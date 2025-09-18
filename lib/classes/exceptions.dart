class NetworkException implements Exception{

  NetworkException({required this.type});

  String type;

  @override
  String toString() {
    return 'Network Exception {e: $type}';
  }

}

class NoConnectionException implements Exception{


  @override
  String toString() {
    return 'No Connection';
  }
}

class ServerErrorException implements Exception{

  ServerErrorException({
    required this.responseCode,
    required this.data
  });

  int responseCode;
  dynamic data;

  @override
  String toString() {
    return 'Server Exception {e: $responseCode, data: $data}';
  }

}