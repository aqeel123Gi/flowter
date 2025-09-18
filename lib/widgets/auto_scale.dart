import 'package:framework/classes/window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class GlobalScaling extends StatefulWidget {

  static double _currentScale = 0;
  static double _currentHeight = 0;
  static double _currentWidth = 0;


  static double get currentScale => _currentScale;
  static double get currentHeight => _currentHeight;
  static double get currentWidth => _currentWidth;
  static Size get currentSize => Size(_currentWidth,_currentHeight);


  // static double currentScale = 1;
  // static double currentScale = 1;


  static void _onChanged(){
    for (var onChanged in _onChangedList) {
      onChanged();
    }
  }


  static void setScale(BuildContext context, double scale){
    GlobalScaling._currentScale = scale;
    rescale(context);
  }

  static void rescale(BuildContext context){
    GlobalScaling._currentHeight = MediaQuery.of(context).size.height / GlobalScaling._currentScale;
    GlobalScaling._currentWidth = MediaQuery.of(context).size.width / GlobalScaling._currentScale;
    _onChanged();
  }

  static final List<void Function()> _onChangedList = [];
  static void addListener(void Function() onChanged)=>_onChangedList.add(onChanged);
  static void removeListener(void Function() onChanged)=>_onChangedList.remove(onChanged);

  const GlobalScaling({
    super.key,
    required this.child
  });

  final Widget child;



  @override
  State<GlobalScaling> createState() => _GlobalScalingState();
}

class _GlobalScalingState extends State<GlobalScaling> with WindowListener{


  @override
  void onWindowEvent(String eventName) {
    GlobalScaling.rescale(context);
    super.onWindowEvent(eventName);
  }

  @override
  void onWindowResize() {
    GlobalScaling.rescale(context);
    super.onWindowResized();
  }

  @override
  void onWindowResized() {
    GlobalScaling.rescale(context);
    super.onWindowResized();
  }

  @override
  void onWindowLeaveFullScreen() {
    GlobalScaling.rescale(context);
    super.onWindowLeaveFullScreen();
  }

  @override
  void onWindowEnterFullScreen() {
    GlobalScaling.rescale(context);
    super.onWindowEnterFullScreen();
  }

  @override
  void onWindowMaximize() {
    GlobalScaling.rescale(context);
    super.onWindowMaximize();
  }

  @override
  void onWindowUnmaximize() {
    GlobalScaling.rescale(context);
    super.onWindowUnmaximize();
  }

  // void _update(){
  //   Future.delayed(const Duration(milliseconds: 100),()=>setState((){}));
  //   Future.delayed(const Duration(milliseconds: 200),()=>setState((){}));
  //   setState((){});
  // }

  @override
  void initState() {

    windowManager.addListener(this);

    WidgetsBinding.instance.addPostFrameCallback((_)=>GlobalScaling.setScale(context, 0.5));

    super.initState();
  }


  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    double verticalPadding = - Window.height(context) * .5 * (1/GlobalScaling.currentScale);
    double horizontalPadding = - Window.width(context) * .5 * (1/GlobalScaling.currentScale);

    return Stack(children:[
        Positioned(
          top: verticalPadding,
          bottom: verticalPadding,
          left: horizontalPadding,
          right: horizontalPadding,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity().scaled(GlobalScaling.currentScale),
            child: widget.child,
          )
        )
      ]
    );
  }

}


class Scaling extends StatefulWidget {
  const Scaling({super.key, required this.scaleFrom, required this.child});

  final double Function() scaleFrom;
  final Widget child;

  @override
  State<Scaling> createState() => _ScalingState();
}

class _ScalingState extends State<Scaling> {

  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(

      builder: (context, constraints) {


        double verticalPadding =  ((constraints.maxHeight/widget.scaleFrom())-constraints.maxHeight) * 0.5;
        double horizontalPadding =  ((constraints.maxWidth/widget.scaleFrom())-constraints.maxWidth) * 0.5;

        return Stack(children: [
          Positioned(
              top: -verticalPadding,
              bottom: -verticalPadding,
              left: -horizontalPadding,
              right: -horizontalPadding,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity().scaled(widget.scaleFrom()),
                child: widget.child,
              )
          )
        ]
        );
      },
    );
  }
}

