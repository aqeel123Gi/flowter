part of 'animated_widget_switcher.dart';

class _WidgetSwitcherData<T>{

  final GlobalKey globalKey;
  final AnimateController animateController;
  final T switchingKey;
  final Widget Function(T switchingKey) builder;

  _WidgetSwitcherData({
    required this.globalKey,
    required this.animateController,
    required this.switchingKey,
    required this.builder
  });

}


class _AnimatedWidgetSwitcherController<T> extends WidgetController<AnimatedWidgetSwitcher<T>>{

  List<_WidgetSwitcherData<T>?> data = [];

  void appendOnSwitchingKeyChanged(){
    if(data.isEmpty || data.last!.switchingKey != widget.switchingKey){

      if(data.isNotEmpty){
        GlobalKey lastGlobalKey = data.last!.globalKey;
        data.last!.animateController.hide();
        Future.delayed(widget.hidingTransform?.duration??const Duration(milliseconds: 500),(){
          data.removeWhere((e)=>e?.globalKey == lastGlobalKey);
          updateState();
        });
      }

      data.add(_WidgetSwitcherData(
          globalKey: GlobalKey(),
          animateController: AnimateController(),
          switchingKey: widget.switchingKey,
          builder: widget.builder
      ));

    }
  }


}