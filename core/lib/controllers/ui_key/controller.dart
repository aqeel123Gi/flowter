part of 'ui_key.dart';

class DistancedWidgetKey {
  DistancedWidgetKey(this.key, this.distance);
  final GlobalKey key;
  final double distance;
}


abstract class UiKeyParentController{
  late final GlobalKey childGlobalKey;
}




class UiKeyTabsParentController extends UiKeyParentController{

  UiKeyTabsParentController({
    required this.controller,
    this.autoFocusOnTabViewedByIndex
  });

  final InteractiveTabsController controller;
  final int? autoFocusOnTabViewedByIndex;
}




class UiKeyController{

  static TransformData globalTransformEffect = TransformData();


  static double Function() _scale = ()=>1;
  static void scaleFrom(double Function() scale){
    _scale = scale;
  }

  static List<GlobalKey> staticGlobalKeys = [];
  static List<List<GlobalKey>> keysOfLayers = [];
  static List<GlobalKey?> focusedKeyOfLayers = [];
  static List<List<void Function()>> updateStatesOfLayers = [];

  static void Function()? staticUpdateState;

  static void addStaticUpdateState(void Function() updateStateFunction){
    staticUpdateState = updateStateFunction;
  }

  static void addStaticWidgets(List<GlobalKey> keys){
    for(GlobalKey key in keys){
      if(!staticGlobalKeys.contains(key)){
        staticGlobalKeys.add(key);
      }
    }
  }

  static void removeStaticWidgets(List<GlobalKey> keys){
    for(GlobalKey key in keys){
      if(staticGlobalKeys.contains(key)){
        staticGlobalKeys.remove(key);
      }
      if(focusedKeyOfLayers.isNotEmpty && focusedKeyOfLayers.last == key){
        focusedKeyOfLayers.last = null;
      }
    }
  }

  static void addWidgetsToCurrentLayer(List<GlobalKey> keys){
    for(GlobalKey key in keys){
      if(keysOfLayers.whereAllList((list) => !list.contains(key))){
        keysOfLayers.last.add(key);
      }
    }
  }


  static void removeWidgetsFromCurrentLayer(List<GlobalKey> keys){
    for(GlobalKey key in keys){
      if(keysOfLayers.last.contains(key)){
        keysOfLayers.last.remove(key);
      }
    }
  }

  static void removeWidgetsFromLayer(List<GlobalKey> keys){
    for(GlobalKey key in keys){
      if(keysOfLayers.last.contains(key)){
        keysOfLayers.last.remove(key);
      }
    }
  }

  static void addUpdateStateToCurrentLayer(void Function() updateStateFunction){
    if(!updateStatesOfLayers.last.contains(updateStateFunction)){
      updateStatesOfLayers.last.add(updateStateFunction);
    }
  }




  static void clearLayers(){
    keysOfLayers = [];
    focusedKeyOfLayers = [];
    updateStatesOfLayers = [];
    updateState();
  }

  static void oneLayer(List<GlobalKey> keys, {GlobalKey? focusedGlobalKey}){
    clearLayers();
    pushLayer(keys, focusedGlobalKey: focusedGlobalKey);
    updateState();
  }

  static void pushLayer(List<GlobalKey> keys, {GlobalKey? focusedGlobalKey}){
    keysOfLayers.add(keys);
    if(focusedGlobalKey==null && staticGlobalKeys.contains(currentFocusedGlobalKey)){
      focusedKeyOfLayers.add(currentFocusedGlobalKey);
    }else{
      focusedKeyOfLayers.add(focusedGlobalKey);
    }
    updateStatesOfLayers.add([]);
  }

  static void updateLayer(List<GlobalKey> keys){
    keysOfLayers.last = keys;
    updateState();
  }

  static void popLayer(){

    keysOfLayers.removeLast();
    if(staticGlobalKeys.contains(currentFocusedGlobalKey)){
      GlobalKey key = currentFocusedGlobalKey!;
      focusedKeyOfLayers.removeLast();
      focusedKeyOfLayers.last = key;
    }else{
      focusedKeyOfLayers.removeLast();
    }
    updateStatesOfLayers.removeLast();
    updateState();
  }

  static void changeFocusedGlobalKey(GlobalKey key){
    focusedKeyOfLayers.last = key;
    (key.currentState as _UiKeyState)._focusNode.requestFocus();
    addPostFrameCallback(() {
      try{
        (key.currentState as _UiKeyState)._focusNode.requestFocus();
      }catch(_){
      }
    });
    (key.currentState as _UiKeyState).updateState();
    Scrollable.ensureVisible(key.currentContext!,alignment: 0.5, duration: const Duration(milliseconds: 1000), curve: Curves.easeOutCirc);
    updateState();

  }


  static GlobalKey? get currentFocusedGlobalKey {
    if(focusedKeyOfLayers.isEmpty){
      return null;
    }
    return focusedKeyOfLayers.last;
  }

  static void updateState(){
    for (var key in currentReachableGlobalKeys) {
      if(key.currentState!=null){
        (key.currentState as _UiKeyState).updateState();
      }
    }
    if(staticUpdateState!=null){
      staticUpdateState!();
    }
    for (var list in updateStatesOfLayers) {
      for(var updateState in list){
        updateState();
      }
    }

  }

  static filterNullWidgetsOfKeys(){
    for(var layer in keysOfLayers){
      layer.removeWhere((key) => key.currentWidget == null);
    }
    staticGlobalKeys.removeWhere((key) => key.currentWidget == null);
    for(int i=0;i<focusedKeyOfLayers.length;i++){
      if(focusedKeyOfLayers[i]!=null && focusedKeyOfLayers[i]!.currentWidget == null){
        focusedKeyOfLayers[i]=null;
      }
    }
  }

  // Initialize
  static void initialize(){
    HardwareKeyboard.instance.addHandler(_handler);
  }

  static bool _handler (KeyEvent key){


    if(key is KeyDownEvent){
      if(currentFocusedGlobalKey?.currentWidget!=null && (currentFocusedGlobalKey!.currentState as _UiKeyState).widget.keyActions.containsKey(key.logicalKey)){
        (currentFocusedGlobalKey!.currentState as _UiKeyState).widget.keyActions[key.logicalKey]!();
        return true;
      }else if(globalKeyDownActions.containsKey(key.logicalKey)){
        globalKeyDownActions[key.logicalKey]!();
        return true;
      }
    }
    else if(key is KeyUpEvent){
      if(currentFocusedGlobalKey?.currentWidget!=null && (currentFocusedGlobalKey!.currentState as _UiKeyState).widget.keyActions.containsKey(key.logicalKey)){
        // (currentFocusedGlobalKey!.currentState as _UiKeyState).widget.keyActions[key.logicalKey]!();
        return true;
      }else if(globalKeyUpActions.containsKey(key.logicalKey)){
        globalKeyUpActions[key.logicalKey]!();
        return true;
      }
    }
    return false;
  }


  // Actions
  //
  //
  //


  static Map<LogicalKeyboardKey,void Function()> globalKeyDownActions = {
    LogicalKeyboardKey.arrowUp: ()=>move(Side.top),
    LogicalKeyboardKey.arrowDown: ()=>move(Side.bottom),
    LogicalKeyboardKey.arrowLeft: ()=>move(Side.left),
    LogicalKeyboardKey.arrowRight: ()=>move(Side.right),
    LogicalKeyboardKey.enter: ()=>down(),
    LogicalKeyboardKey.select: ()=>down(),
  };

  static Map<LogicalKeyboardKey,void Function()> globalKeyUpActions = {
    LogicalKeyboardKey.enter: ()=>up(),
    LogicalKeyboardKey.select: ()=>up(),
  };

  static List<GlobalKey> get currentReachableGlobalKeys {
    return [...keysOfLayers.isNotEmpty?keysOfLayers.last:[], ...staticGlobalKeys];
  }

  static void move(Side side) {

    filterNullWidgetsOfKeys();

    if (currentReachableGlobalKeys.isEmpty) {
      if (kDebugMode) {
        DebuggerConsole.addLine("No UiKeys in the scene");
      }
      return;
    }

    if (focusedKeyOfLayers.last==null) {
      changeFocusedGlobalKey(currentReachableGlobalKeys.first);
      return;
    }

    DistancedWidgetKey? toWidgetKey;
    UiKeyParentController? parentWidgetController = (focusedKeyOfLayers.last!.currentWidget as UiKey).parentController;

    // If in InteractiveTabs
    //
    //

    InteractiveTabsController? getTabsController(GlobalKey key){
      return tryGet(()=>(((key.currentWidget as UiKey).parentController as UiKeyParentController) as UiKeyTabsParentController).controller);
    }


    if(parentWidgetController!=null){
      if(parentWidgetController is UiKeyTabsParentController){
        toWidgetKey = _getGlobalKeyOfNearestWidgetFromOriginalWidget(isInAngleArea, focusedKeyOfLayers.last!, side, keysOfLayers.last.where((e)=>(getTabsController(e) == (parentWidgetController).controller)).toList());
        if(toWidgetKey!=null){
          return changeFocusedGlobalKey(toWidgetKey.key);
        }
        toWidgetKey = _getGlobalKeyOfNearestWidgetFromOriginalWidget(isInSideArea, focusedKeyOfLayers.last!, side, keysOfLayers.last.where((e)=>(e.currentWidget as UiKey).parentController==parentWidgetController).toList());
        if(toWidgetKey!=null){
          return changeFocusedGlobalKey(toWidgetKey.key);
        }



        // TODO: Directionality by widget, Not dictionary.

        bool prev(){
          if(parentWidgetController.controller.currentIndex<parentWidgetController.controller.length()-1){
            parentWidgetController.controller.toTab(parentWidgetController.controller.currentIndex+1);
            return true;
          }
          return false;
        }
        bool next(){
          if(parentWidgetController.controller.currentIndex>0){
            parentWidgetController.controller.toTab(parentWidgetController.controller.currentIndex-1);
            return true;
          }
          return false;
        }

        if(side == Side.left){
          if(DictionaryController.currentLanguage.direction == TextDirection.rtl){
            if (prev()) return;
          }else{
            if (next()) return;
          }
        }
        if(side == Side.right){
          if(DictionaryController.currentLanguage.direction == TextDirection.rtl){
            if (next()) return;
          }else{
            if (prev()) return;
          }
        }

        // END_TODO


      }
    }



    // Outside
    //
    //

    toWidgetKey = _getGlobalKeyOfNearestWidgetFromOriginalWidget(isInAngleArea, focusedKeyOfLayers.last!, side, keysOfLayers.last);
    toWidgetKey = _getGlobalKeyOfNearestWidgetFromOriginalWidget(isInAngleArea, focusedKeyOfLayers.last!, side, staticGlobalKeys, toWidgetKey);
    if(toWidgetKey!=null){
      return changeFocusedGlobalKey(toWidgetKey.key);
    }

    toWidgetKey = _getGlobalKeyOfNearestWidgetFromOriginalWidget(isInSideArea, focusedKeyOfLayers.last!, side, keysOfLayers.last);
    toWidgetKey = _getGlobalKeyOfNearestWidgetFromOriginalWidget(isInSideArea, focusedKeyOfLayers.last!, side, staticGlobalKeys, toWidgetKey);
    if(toWidgetKey!=null){
      return changeFocusedGlobalKey(toWidgetKey.key);
    }

  }

  static DistancedWidgetKey? _getGlobalKeyOfNearestWidgetFromOriginalWidget(
      bool Function(Side side, Offset origin, Offset distance) inAreaFunction,
      GlobalKey originalWidgetKey,
      Side side,
      List<GlobalKey> othersToCompared,
      [DistancedWidgetKey? startWithDistancedWidgetKey]
      ){
    Offset currentWidgetOffset = getCenterPointOfWidgetPosition(originalWidgetKey,_scale())!;
    DistancedWidgetKey? toWidgetKey = startWithDistancedWidgetKey;
    for (var key in othersToCompared) {
      if (key != originalWidgetKey) {
        Offset widgetOffset = getCenterPointOfWidgetPosition(key,_scale())!;
        if (inAreaFunction(side, currentWidgetOffset, widgetOffset)) {
          if (toWidgetKey == null) {
            toWidgetKey = DistancedWidgetKey(key,getDistanceBetweenTwoOffsets(currentWidgetOffset, widgetOffset));
          } else {
            double distance = getDistanceBetweenTwoOffsets(currentWidgetOffset, widgetOffset);
            if (distance < toWidgetKey.distance) {
              toWidgetKey = DistancedWidgetKey(key,distance);
            }
          }
        }
      }
    }
    return toWidgetKey;
  }

  static void tap(){
    if(currentFocusedGlobalKey!=null){
      pointerSimulationOnCenter(currentFocusedGlobalKey!, PointerType.tap, _scale());
    }
  }

  static void down(){
    if(currentFocusedGlobalKey!=null){
      pointerSimulationOnCenter(currentFocusedGlobalKey!, PointerType.down, _scale());
    }
  }

  static void up(){
    if(currentFocusedGlobalKey!=null){
      pointerSimulationOnCenter(currentFocusedGlobalKey!, PointerType.up, _scale());
    }
  }


}