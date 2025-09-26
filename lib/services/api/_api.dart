part of 'api.dart';





class API {


  static String get baseURL => _baseURL;


  static late String? Function()? _getToken;


  static late String? Function()? _getAcceptLanguage;


  static late String? Function()? _getUserType;

  static late List<int> exceptionOnResponseCodes;

  static late String _baseURL;


  static late int _apiDefaultVersion;

  static void initialize({
    required String baseURL,
    int apiDefaultVersion = 1,
    String? Function()? getToken,
    String? Function()? getAcceptLanguage,
    String? Function()? getUserType,
  }){
    _baseURL = baseURL;
    _apiDefaultVersion = apiDefaultVersion;
    _getToken = getToken;
    _getAcceptLanguage = getAcceptLanguage;
    _getUserType = getUserType;
  }


  static final List<void Function(String path, HttpRequestType type, Map<String, String> headers, dynamic body)> _onRequestCallbacks = [];



  static void addOnRequestCallback(void Function(String path, HttpRequestType type, Map<String, String> headers, dynamic body) callback){
    _onRequestCallbacks.add(callback);
  }



  static void removeOnRequestCallback(void Function(String path, HttpRequestType type, Map<String, String> headers, dynamic body) callback){
    _onRequestCallbacks.remove(callback);
  }



  static final List<void Function(String path, HttpRequestType type, String code, Map<String, String> headers, dynamic body)> _onResponseCallbacks = [];



  static void addOnResponseCallback(void Function(String path, HttpRequestType type, String code, Map<String, String> headers, dynamic body) callback){
    _onResponseCallbacks.add(callback);
  }



  static void removeOnResponseCallback(void Function(String path, HttpRequestType type, String code, Map<String, String> headers, dynamic body) callback){
    _onResponseCallbacks.remove(callback);
  }


  static Future<bool> hasConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.anyContainsIn([ConnectivityResult.mobile, ConnectivityResult.wifi, ConnectivityResult.ethernet]);
  }






  static Future<ApiResponse> request(
      {
        required HttpRequestType type,
        required String path,
        int? version,
        Map<String,String> headers = const {},
        dynamic body, int timeout = 60,
        dynamic virtualBody,
        List<String>? keysToFilter,


      }) async {

    if (!await hasConnectivity()) {
      throw NoConnectionException();
    }


    version ??= _apiDefaultVersion;


    try {
      Map<String, String> modifiedHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      }..addAll(headers);

      if(_getAcceptLanguage!=null && _getAcceptLanguage!() != null){
        modifiedHeaders['Accept-Language'] = _getAcceptLanguage!()!;
      }

      if (_getToken!=null && _getToken!() != null) {
        modifiedHeaders['Authorization'] = 'Bearer ${_getToken!()}';
      }

      if (_getUserType!=null && _getUserType!() != null) {
        modifiedHeaders['User-Type'] = _getUserType!()!;
      }




      for (var callback in _onRequestCallbacks) {
        callback('$_baseURL/api/v$version/$path', type, modifiedHeaders, body);
      }

      if(kDebugMode && body != null){
        printStructure(body,title: 'REQUEST BODY');
      }


      Response response;
      switch(type){
        case HttpRequestType.get:
          response = await get(
            Uri.parse('$_baseURL/api/v$version/$path'),
            headers: modifiedHeaders,
          ).timeout(Duration(seconds: timeout));
          break;
        case HttpRequestType.post:
          response = await post(
              Uri.parse('$_baseURL/api/v$version/$path'),
              headers: modifiedHeaders,
              body: json.encode(body)
          ).timeout(Duration(seconds: timeout));
          break;
        case HttpRequestType.put:
          response = await put(
              Uri.parse('$_baseURL/api/v$version/$path'),
              headers: modifiedHeaders,
              body: json.encode(body)
          ).timeout(Duration(seconds: timeout));
          break;
        case HttpRequestType.delete:
          response = await delete(
              Uri.parse('$_baseURL/api/v$version/$path'),
              headers: modifiedHeaders,
              body: json.encode(body)
          ).timeout(Duration(seconds: timeout));
          break;
        case HttpRequestType.patch:
          response = await patch(
              Uri.parse('$_baseURL/api/v$version/$path'),
              headers: modifiedHeaders,
              body: json.encode(body)
          ).timeout(Duration(seconds: timeout));
          break;
      }

      for (var callback in _onResponseCallbacks) {
        callback('$_baseURL/api/v$version/$path', type, response.statusCode.toString(), response.headers, body);
      }

      if(kDebugMode){
        dynamic body = tryGet(()=>json.decode(response.body));
        if(body != null){
          printStructure(body,title: 'RESPONSE BODY');
        }else{
          par(response.body,'RESPONSE BODY');
        }
      }

      return ApiResponse(response.statusCode,tryGet(()=>json.decode(response.body),response.body));


    } catch (e) {
      if (e is TimeoutException || e is SocketException || e is HandshakeException) {
        throw NetworkException(type: e.toString());
      } else {
        rethrow;
      }
    }
  }










  static Future<ApiResponse> multipartRequest(
      {
        required HttpRequestType type,
        required String path,
        int? version,
        Map<String,String> headers = const {},
        Map<String,File> files = const {},
        Map<String,dynamic> fields = const {},
        int timeout = 60,
        dynamic virtualBody,
        List<String>? keysToFilter,


      }) async {

    if (!await hasConnectivity()) {
      throw NoConnectionException();
    }


    version ??= _apiDefaultVersion;


    try {
      Map<String, String> modifiedHeaders = {
        // 'Content-type': 'application/json',
        // 'Accept': 'application/json'
      }..addAll(headers);

      if(_getAcceptLanguage!=null && _getAcceptLanguage!() != null){
        modifiedHeaders['Accept-Language'] = _getAcceptLanguage!()!;
      }

      if (_getToken!=null && _getToken!() != null) {
        modifiedHeaders['Authorization'] = 'Bearer ${_getToken!()}';
      }

      if (_getUserType!=null && _getUserType!() != null) {
        modifiedHeaders['User-Type'] = _getUserType!()!;
      }




      for (var callback in _onRequestCallbacks) {
        callback('$_baseURL/api/v$version/$path', type, modifiedHeaders, fields);
      }



      var request = MultipartRequest(type.name.toUpperCase(), Uri.parse('$_baseURL/api/v$version/$path'));

      for(var header in modifiedHeaders.entries){
        request.headers[header.key] = header.value;
      }


      for(var file in files.entries){
        var multipartFile = MultipartFile(
          file.key,
          ByteStream(file.value.openRead())..cast(),
          await file.value.length(),
          filename: file.value.path.split('/').last,
        );
        request.files.add(multipartFile);
      }



      for(var field in fields.entries){
        request.fields[field.key] = field.value.toString();
      }


      StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      for (var callback in _onResponseCallbacks) {
        callback('$_baseURL/api/v$version/$path', type, response.statusCode.toString(), response.headers, responseBody);
      }

      return ApiResponse(response.statusCode,tryGet(()=>json.decode(responseBody),responseBody));


    } catch (e) {
      if (e is TimeoutException || e is SocketException || e is HandshakeException) {
        throw NetworkException(type: e.toString());
      } else {
        rethrow;
      }
    }
  }









  static Future<dynamic> virtualResponse({Map<String,
      dynamic>? body, dynamic resBody, Exception? virtualException}) async {
    await Future.delayed(const Duration(seconds: 3));
    if (virtualException != null) {
      throw virtualException;
    } else {
      return resBody;
    }
  }


}


void replaceToValuesByKeys(dynamic data, Map<dynamic,dynamic> keysWithNewValues) {

  if(data is List){
    for (var element in data) {
      replaceToValuesByKeys(element,keysWithNewValues);
    }
  }

  else if(data is Map){
    for (var key in data.keys.toList()) {
      if(keysWithNewValues.keys.contains(key)){
        data[key] = keysWithNewValues[key];
      }else if(data[key] is List || data[key] is Map){
        replaceToValuesByKeys(data[key],keysWithNewValues);
      }
    }
  }

}

void replaceValueForKey(dynamic data, Map<dynamic,dynamic> keysWithNewValues) {
  if (data is List) {
    // If data is a list, iterate through its elements
    for (int i = 0; i < data.length; i++) {
      replaceValueForKey(data[i], keysWithNewValues);
    }
  } else if (data is Map) {
    // If data is a map, check if it contains the specified key
    for(var key in keysWithNewValues.keys){
      if (data.containsKey(key)) {
        // Replace the value for the key with the new value
        data[key] = keysWithNewValues[key];
      }
    }


    // Recursively check and replace in map values
    for (var value in data.values) {
      replaceValueForKey(value, keysWithNewValues);
    }
  }
  // For other types, do nothing
}

