import 'package:flowter/flowter.dart';
import 'package:flutter/material.dart';
import '../../_trash/show_transparent_page.dart';

class BottomPopup extends StatefulWidget {
  static List<void Function()> hidesList = [];
  static void hide() {
    hidesList.removeLast()();
  }

  @override
  createState() => _BottomPopupState();

  const BottomPopup({
    super.key,
    required this.child,
    this.backAndCloseOn,
    this.onHidden,
    required this.cancelByDragging,
    required this.decoration,
    required this.backgroundColor,
    this.maxHeight,
  });
  final Widget child;
  final bool Function()? backAndCloseOn;
  final void Function()? onHidden;
  final bool cancelByDragging;
  final BoxDecoration decoration;
  final Color backgroundColor;
  final double? maxHeight;
}

class _BottomPopupState extends State<BottomPopup> {
  final Curve _curve = Curves.easeOutExpo;

  bool initialized = false;
  double _bottom = -99999;
  double _draggedBottom = 0;
  int _durationSeconds = 0;
  double _opacity = 0;
  double _height = 0;

  height() {
    double h = _height + MediaQuery.of(context).padding.bottom;
    double s = widget.maxHeight ?? MediaQuery.of(context).size.height;
    return h < s ? h : s;
  }

  _hide() {
    if (widget.backAndCloseOn == null || widget.backAndCloseOn!()) {
      Navigator.pop(context);
      setState(() {
        _bottom = -height();
        _opacity = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BottomPopup.hidesList.add(_hide);
  }

  double _touchY = 0;

  @override
  Widget build(BuildContext context) {
    return PublicListener(
        child: PopScope(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  GestureDetector(
                      onTap: () async {
                        BottomPopup.hide();
                      },
                      child: AnimatedContainer(
                          curve: _curve,
                          duration: Duration(milliseconds: _durationSeconds),
                          color: widget.backgroundColor
                              .withOpacityMultiply(_opacity))),
                  Stack(children: [
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
                    AnimatedPositioned(
                        curve: _curve,
                        duration: Duration(milliseconds: _durationSeconds),
                        bottom: _bottom -
                            _draggedBottom +
                            MediaQuery.of(context).viewInsets.bottom,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                            onVerticalDragStart: widget.cancelByDragging
                                ? (p) {
                                    _touchY = p.globalPosition.dy;
                                  }
                                : null,
                            onVerticalDragUpdate: widget.cancelByDragging
                                ? (p) {
                                    setState(() {
                                      _draggedBottom =
                                          p.globalPosition.dy - _touchY;
                                      _draggedBottom = _draggedBottom < 0
                                          ? 0
                                          : _draggedBottom;
                                    });
                                  }
                                : null,
                            onVerticalDragEnd: widget.cancelByDragging
                                ? (p) {
                                    if (_draggedBottom > 30) {
                                      BottomPopup.hide();
                                    } else {
                                      setState(() {
                                        _draggedBottom = 0;
                                      });
                                    }
                                  }
                                : null,
                            child: Blur(
                                strength: 25,
                                child: AnimatedContainer(
                                    clipBehavior: Clip.antiAlias,
                                    duration: Duration(
                                        milliseconds: _durationSeconds),
                                    height: height(),
                                    curve: _curve,
                                    padding: EdgeInsets.zero,
                                    decoration: widget.decoration,
                                    child: ChildSizeDetector(
                                      child: widget.child,
                                      onChange: (Size size) {
                                        if (!initialized) {
                                          initialized = true;
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              _height = size.height;
                                              _bottom = -height();
                                            });
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                _bottom = 0;
                                                _opacity = 1;
                                                _durationSeconds = 500;
                                              });
                                            });
                                          });
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            setState(() {
                                              _height = size.height;
                                            });
                                          });
                                        }
                                      },
                                    )))))
                  ])
                ])),
            onPopInvokedWithResult: (_, __) async {
              BottomPopup.hide();
            }));
  }
}

showBottomPopup(
    {required Widget child,
    required Color backgroundColor,
    required BoxDecoration decoration,
    void Function()? onHidden,
    double? maxHeight,
    bool cancelByDragging = true}) {
  showTransparentPage(
      TemplateController.context,
      BottomPopup(
          onHidden: onHidden,
          cancelByDragging: cancelByDragging,
          backgroundColor: backgroundColor,
          decoration: decoration,
          maxHeight: maxHeight,
          child: child),
      back: true);
}
