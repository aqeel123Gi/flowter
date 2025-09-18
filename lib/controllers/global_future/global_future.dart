import 'package:flutter/foundation.dart';

class GlobalFuture<T>{

  final dynamic key;
  final Future<T> Function(dynamic data) future;

  GlobalFuture({
    required this.key,
    required this.future,
    void Function()? onUpdated,
    void Function(MapEntry<Object,StackTrace> error)? onError
  }){

    if(!_pendingFutures.containsKey(key)){
      _pendingFutures[key] = false;
    }

    if(!_dataOfFutures.containsKey(key)){
      _dataOfFutures[key] = null;
    }

    if(!_errorsOfFutures.containsKey(key)){
      _errorsOfFutures[key] = null;
    }

    if(onUpdated!=null){
      if(!_onUpdatedFutures.containsKey(key)){
        _onUpdatedFutures[key] = [];
      }
      _onUpdatedFutures[key]!.add(onUpdated);
    }

    if(onError!=null){
      if(!_onThrownErrorsFutures.containsKey(key)){
        _onThrownErrorsFutures[key] = [];
      }
      _onThrownErrorsFutures[key]!.add(onError);
    }

  }



  static final Map<dynamic,bool> _pendingFutures = {};
  static final Map<dynamic,dynamic> _dataOfFutures = {};
  static final Map<dynamic,MapEntry<Object,StackTrace>?> _errorsOfFutures = {};

  static final Map<dynamic,List<void Function()>> _onUpdatedFutures = {};
  static final Map<dynamic,List<void Function(MapEntry<Object,StackTrace> error)>> _onThrownErrorsFutures = {};



  static void addStaticOnErrorThrown(void Function(MapEntry<Object,StackTrace> error) onThrown){
    _onThrownErrorsListeners.add(onThrown);
  }

  static final List<void Function(MapEntry<Object,StackTrace> error)> _onThrownErrorsListeners = [];



  void resetData(){
    _pendingFutures[key] = false;
    _dataOfFutures[key] = null;
    _errorsOfFutures[key] = null;
  }

  bool get pending => _pendingFutures[key]!;

  T? get data => _dataOfFutures[key];

  MapEntry<Object,StackTrace>? get error => _errorsOfFutures[key];

  late dynamic _lastEnteredData;
  late bool _lastEnteredRefresh;

  Future<void> execute({dynamic data,bool refresh = false})async{

    _lastEnteredData = data;
    _lastEnteredRefresh = refresh;

    if(refresh){
      _dataOfFutures[key] = null;
      _errorsOfFutures[key] = null;
    }
    _pendingFutures[key] = true;
    _dataOfFutures[key] = null;
    _errorsOfFutures[key] = null;
    _onUpdatedFutures[key]?.forEach((element)=>element());
    try{
      _dataOfFutures[key] = await future(data);
    }catch(e,s){
      MapEntry<Object,StackTrace> error = MapEntry(e,s);
      if(kDebugMode){
        print(e);
        print(s);
      }
      _errorsOfFutures[key] = error;
      _onThrownErrorsFutures[key]?.forEach((element)=>element(error));
      for (var element in _onThrownErrorsListeners) {
        element(error);
      }
    }
    _pendingFutures[key] = false;
    _onUpdatedFutures[key]?.forEach((element)=>element());
  }

  Future<void> repeat() async => await execute(data: _lastEnteredData, refresh: _lastEnteredRefresh);

  addOnUpdatedListener(void Function() onUpdated){
    if(!_onUpdatedFutures.containsKey(key)){
      _onUpdatedFutures[key] = [];
    }
    _onUpdatedFutures[key]!.add(onUpdated);
  }

  addOnErrorListener(void Function(MapEntry<Object,StackTrace> error) onError){
    if(!_onThrownErrorsFutures.containsKey(key)){
      _onThrownErrorsFutures[key] = [];
    }
    _onThrownErrorsFutures[key]!.add(onError);
  }

  removeOnUpdatedListener(void Function() onUpdated){
    _onUpdatedFutures[key]?.remove(onUpdated);
  }

  removeOnErrorListener(void Function(Object exception, StackTrace stackTrace) onError){
    _onThrownErrorsFutures[key]?.remove(onError);
  }


  @override
  String toString() {
    return "GlobalFuture {key: $key, pending: $pending, hasData: ${data!=null}, hasError: ${error!=null}}";
  }



}