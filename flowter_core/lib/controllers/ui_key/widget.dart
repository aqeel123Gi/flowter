part of 'ui_key.dart';


class UiKey extends StatefulWidget {

  const UiKey({
    required super.key,
    this.onSubmit,
    this.keyActions = const {},
    this.parentController,
    required this.builder,
    this.fixed = false,
    required this.focusable
  });

  final UiKeyParentController? parentController;
  final bool fixed;
  final bool focusable;
  final Map<LogicalKeyboardKey,void Function()> keyActions;
  final void Function()? onSubmit;
  final Widget Function(BuildContext context, bool focuedUiKey) builder;

  @override
  createState() => _UiKeyState();
}

class _UiKeyState extends State<UiKey> {

  void updateState(){
    if(mounted){setState((){});}
  }


  final FocusNode _focusNode = FocusNode();

  void requestFocus() {
    _focusNode.requestFocus();
  }

  UiKeyParentController? parentWidgetController;
  FocusNode get focusNode => _focusNode;

  void autoFocus(int index){
    if(index == (parentWidgetController as UiKeyTabsParentController).autoFocusOnTabViewedByIndex){
      UiKeyController.changeFocusedGlobalKey(widget.key as GlobalKey);
    }
  }


  @override
  void initState() {
    parentWidgetController = widget.parentController;
    if(parentWidgetController!=null){
      parentWidgetController!.childGlobalKey = widget.key as GlobalKey;
      if(parentWidgetController is UiKeyTabsParentController && (parentWidgetController as UiKeyTabsParentController).autoFocusOnTabViewedByIndex!=null){
        (parentWidgetController as UiKeyTabsParentController).controller.addListenerOnStartTabChanging(autoFocus);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if(parentWidgetController!=null){
      if(parentWidgetController is UiKeyTabsParentController && (parentWidgetController as UiKeyTabsParentController).autoFocusOnTabViewedByIndex!=null){
        (parentWidgetController as UiKeyTabsParentController).controller.removeListenerOnStartTabChanging(autoFocus);
      }
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(widget.focusable){
      if(widget.fixed){
        UiKeyController.addStaticWidgets([widget.key as GlobalKey]);
      }else{
        UiKeyController.addWidgetsToCurrentLayer([widget.key as GlobalKey]);
      }
    }else{
      if(widget.fixed){
        UiKeyController.removeStaticWidgets([widget.key as GlobalKey]);
      }else{
        UiKeyController.removeWidgetsFromCurrentLayer([widget.key as GlobalKey]);
      }
    }

    return  Focus(
      focusNode: _focusNode,
      child:HoveringBuilder(
          builder: (context,isHovered)=>AnimatedTransform(
            data: (UiKeyController.currentFocusedGlobalKey == widget.key || isHovered) && ThisDevice.isTV?UiKeyController.globalTransformEffect:TransformData(),
              child:widget.builder(context, widget.focusable && (UiKeyController.currentFocusedGlobalKey == widget.key || isHovered)))),
    );
  }
}