import 'dart:math';
import 'package:flowter_core/flowter_core.dart';
import 'package:flutter/material.dart';
import '../../_trash/show_transparent_page.dart';

class CenterPopup extends StatefulWidget {
  static List<void Function()> hidesList = [];
  static void hide() {
    hidesList.removeLast()();
  }

  @override
  createState() => _CenterPopupState();

  const CenterPopup({
    super.key,
    required this.child,
    this.stackedChild,
    this.backAndCloseOn,
    required this.backgroundColor,
    required this.decoration,
  });

  final Widget child;
  final Widget? stackedChild;
  final bool Function()? backAndCloseOn;
  final Color backgroundColor;
  final BoxDecoration decoration;
}

class _CenterPopupState extends State<CenterPopup> {
  FocusNode focusNode = FocusNode();

  final Curve _curve = Curves.easeOutExpo;

  bool initialized = false;
  double _bottom = -99999;
  int _durationSeconds = 0;
  double _opacity = 0;
  double _height = 0;

  bool _inMiddle = false;

  height() {
    if (_height >
        (Window.height(context) - MediaQuery.of(context).viewInsets.bottom) *
            0.8) {
      return (Window.height(context) -
                  MediaQuery.of(context).viewInsets.bottom) *
              0.8 +
          4;
    }
    BoxBorder? boxBorder = widget.decoration.border;
    double borderWidth = 0;
    if (boxBorder != null) {
      borderWidth = boxBorder.top.width * 2;
    }
    return _height + borderWidth;
  }

  _hide() {
    if (widget.backAndCloseOn == null || widget.backAndCloseOn!()) {
      Navigator.pop(context);
      setState(() {
        _bottom = -height();
        _opacity = 0;
        _inMiddle = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    CenterPopup.hidesList.add(_hide);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: _opacity == 0,
        child: Material(
            color: Colors.transparent,
            child: PopScope(
                onPopInvokedWithResult: (_, __) {
                  _hide();
                },
                canPop: false,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: [
                      Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Blur(
                            curve: Curves.easeOutCirc,
                            duration: const Duration(seconds: 2),
                            opacity: _opacity == 0 ? 0 : 1,
                          )),
                      GestureDetector(
                          onTap: () {
                            if (MediaQuery.of(context).viewInsets.bottom > 0) {
                              FocusScope.of(context).requestFocus(focusNode);
                            } else {
                              _hide();
                            }
                          },
                          child: AnimatedContainer(
                              curve: _curve,
                              duration:
                                  Duration(milliseconds: _durationSeconds),
                              color: widget.backgroundColor
                                  .withOpacityMultiply(_opacity))),
                      AnimatedPositioned(
                          curve: _curve,
                          duration: Duration(milliseconds: _durationSeconds),
                          bottom: (_inMiddle
                                  ? (MediaQuery.of(context).size.height * 0.5) -
                                      (height() * 0.5) +
                                      MediaQuery.of(context).padding.bottom
                                  : _bottom) +
                              (MediaQuery.of(context).viewInsets.bottom * 0.5),
                          left: 0,
                          right: 0,
                          child: AnimatedOpacity(
                              curve: _curve,
                              duration:
                                  Duration(milliseconds: _durationSeconds),
                              opacity: _opacity,
                              child: Center(
                                  child: Blur(
                                      strength: 25,
                                      radius: 20,
                                      child: AnimatedContainer(
                                          constraints: BoxConstraints(
                                              maxWidth: min(
                                                  Window.width(context) * 0.8,
                                                  400)),
                                          clipBehavior: Clip.antiAlias,
                                          duration: Duration(
                                              milliseconds: _durationSeconds),
                                          height: height(),
                                          curve: _curve,
                                          decoration: widget.decoration,
                                          child: SingleChildScrollView(
                                              padding: EdgeInsets.zero,
                                              child: ChildSizeDetector(
                                                  child: widget.child,
                                                  onChange: (Size size) {
                                                    if (!initialized) {
                                                      initialized = true;
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        setState(() {
                                                          _height = size.height;
                                                          _bottom = -height();
                                                        });
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          setState(() {
                                                            _inMiddle = true;
                                                            _opacity = 1.0;
                                                            _durationSeconds =
                                                                1000;
                                                          });
                                                        });
                                                      });
                                                    } else {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        setState(() {
                                                          _height = size.height;
                                                        });
                                                      });
                                                    }
                                                  }))))))),
                      widget.stackedChild ?? const SizedBox()
                    ])))));
  }
}

showCenterPopup(BuildContext context, Widget child,
    {Widget? stackedChild,
    required Color backgroundColor,
    required BoxDecoration decoration,
    bool Function()? backAndCloseOn}) {
  showTransparentPage(
      context,
      CenterPopup(
        backAndCloseOn: backAndCloseOn,
        backgroundColor: backgroundColor,
        decoration: decoration,
        stackedChild: stackedChild,
        child: child,
      ));
}
