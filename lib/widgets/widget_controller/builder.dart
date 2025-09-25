part of 'widget_controller.dart';


class WidgetControllerBuilder<T extends WidgetController> extends StatefulWidget {
  const WidgetControllerBuilder({
    super.key,
    required this.widget,
    this.state,
    required this.controller,
    required this.builder,
    this.fakeData = false,
  });

  final State? state;
  final Widget widget;
  final Widget Function(BuildContext context, T controller) builder;
  final T controller;
  final bool fakeData;

  @override
  State<WidgetControllerBuilder<T>> createState() => _WidgetControllerBuilderState<T>();
}





class _WidgetControllerBuilderState<T extends WidgetController> extends State<WidgetControllerBuilder<T>> {

  late T _controller;

  @override
  void initState() {

    _controller = widget.controller;
    _controller.fakeData = widget.fakeData;
    WidgetController._addController(_controller);

    _controller.widget = widget.widget;
    _controller.state = widget.state;
    _controller.updateState = (){
      if(mounted){
        setState(() {});
      }
    };
    _controller.context = context;
    _controller.mounted = ()=> mounted;
    _controller.onInit();
    addPostFrameCallback((){
      _controller.onPostInit();
      addPostFrameCallback((){
        _controller.completedPostInit = true;
      });
    });

    _controller.state = this;

    if(_controller.onInitByFollowings!=null && _controller.onInitByFollowings!.isNotEmpty){

      void runNext(int index) {
        if (index < _controller.onInitByFollowings!.length) {
          _controller.onInitByFollowings![index]();
          addPostFrameCallback(() {
            runNext(index + 1);
          });
          if(index!=0){
            _controller.updateState();
          }
        }
      }
      runNext(0);

    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.onStartDisposing();
    addPostFrameCallback((){
      _controller.onStateUpdatedAfterDisposed();
    });
    WidgetController._removeController(_controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.widget = widget.widget;
    _controller.state = widget.state;
    _controller.onStateStartUpdating();
    addPostFrameCallback((){
      _controller.onStateUpdated();
    });
    return widget.builder(context, _controller);
  }

}
