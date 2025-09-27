part of 'widget.dart';


class DirectFutureBuilderWidgetController<T> extends WidgetController<DirectFutureBuilder<T>>{


  DirectFutureState directFutureState = DirectFutureState.loading;
  bool init = false;

  T? data;


  @override
  void onInit() {
    if(widget.controller != null) widget.controller!._widgetController = this;
  }


  @override
  void onPostInit() {
    directFuture();
    future();
  }


  Future<void> directFuture()async{
    data = await widget.directFuture();
    init = true;
    updateState();
  }

  Future<void> future()async{
    try{
      directFutureState = DirectFutureState.loading;
      updateState();
      data = await widget.future();
      directFutureState = DirectFutureState.success;
      updateState();
    }catch(_){
      directFutureState = DirectFutureState.error;
      rethrow;
    }
  }

  void repeat(){
    if(directFutureState != DirectFutureState.loading) {
      future();
    } else {
      throw Exception("The future is already running.");
    }
  }


}