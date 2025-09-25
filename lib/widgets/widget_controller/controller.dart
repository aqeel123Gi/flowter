part of 'widget_controller.dart';

abstract class WidgetController<W> {

  late bool fakeData;
  bool completedPostInit = false;
  late W widget;
  late State? state;
  late BuildContext context;
  void Function() updateState = (){};
  late bool Function() mounted;

  void onInit(){

  }
  void onPostInit(){

  }

  List<void Function()>? onInitByFollowings;

  void onStartDisposing(){

  }
  void onStateUpdatedAfterDisposed(){

  }
  void onStateStartUpdating(){

  }
  void onStateUpdated(){

  }

  void periodicStateUpdate (Duration breaksDuration) async{
    while(mounted()){
      updateState();
      await Future.delayed(breaksDuration);
    }
  }

  static List<WidgetController> controllers = [];
  static void _addController(WidgetController controller){
    controllers.add(controller);
  }
  static void _removeController(WidgetController controller){
    controllers.remove(controller);
  }

  static List<T> of<T extends WidgetController>(){
    return controllers.where((controller)=>controller.runtimeType==T).toList() as List<T>;
  }

  static T ofSinge<T extends WidgetController>(){
    return controllers.singleWhere((controller)=>controller.runtimeType==T) as T;
  }

  static T? ofTrySinge<T extends WidgetController>(){

    List<T> list = [];
    for (var controller in controllers) {
      if(controller.runtimeType==T){
        list.add(controller as T);
      }
    }

    if(list.length==1){
      return list.first;
    }
    return null;

  }


  static void executeOn<T extends WidgetController>(void Function(T controller) function){

    List<T> list = [];
    for (var controller in controllers) {
      if(controller.runtimeType==T){
        list.add(controller as T);
      }
    }

    for(T controller in list){
      function(controller);
    }

  }


  static void updateStatesOf<T extends WidgetController>(){
    for (var controller in controllers) {
      if(controller.runtimeType==T){
        controller.updateState();
      }
    }
  }



  static void updateStates(){
    for (var controller in controllers) {
      controller.updateState();
    }
  }

}