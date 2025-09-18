import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../_trash/show_transparent_page.dart';

class Pending extends StatefulWidget {

  static bool shown = false;
  static show({
    required BuildContext context,
    required Widget child,
    required Color backgroundColor,
    Duration showDuration = const Duration(milliseconds: 1000),
    Duration hideDuration = const Duration(milliseconds: 400),
  }){
    if(shown){
      if (kDebugMode) {
        print("Pending Widget is shown.");
      }
      return;
    }
    showTransparentPage(context, Pending(backgroundColor: backgroundColor,
    showDuration: showDuration,
    hideDuration: hideDuration,
    child: child),
        back: false,
        routeName:"<PENDING>"
    );
  }
  static void Function() hide = (){};

  @override
  createState() => _PendingState();


  const Pending({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.showDuration,
    required this.hideDuration,
    this.onTouch,
  });

  final Widget child;
  final Color backgroundColor;
  final void Function()? onTouch;
  final Duration showDuration;
  final Duration hideDuration;

}

class _PendingState extends State<Pending> {

  final Curve _curve = Curves.easeOutExpo;

  double _opacity = 0;
  late Duration _duration;


  _hide(){
      Navigator.pop(context);
      setState(() {
        _duration = widget.hideDuration;
        _opacity = 0;
      });
  }

  @override
  void initState() {
    super.initState();
    _duration = widget.showDuration;
    Pending.hide = _hide;
  }


  @override
  Widget build(BuildContext context) {


    return Material(
        color: Colors.transparent,
        child: PopScope(canPop: false, child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: AnimatedOpacity(
              opacity: _opacity,
                curve: _curve,
                duration: _duration,
              child:Container(
                  color:widget.backgroundColor,
                  child:Center(child: widget.child))
            )
            )));
  }
}
