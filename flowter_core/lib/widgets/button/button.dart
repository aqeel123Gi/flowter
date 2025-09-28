import 'package:flowter_core/classes/transform_data/transform_data.dart';
import 'package:flowter_core/flowter_core.dart';
import 'package:flowter_core/widgets/animated_transform/animated_transform.dart';
import 'package:flowter_core/widgets/blur/blur.dart';
import 'package:flowter_core/widgets/effects/zooming_click_effect.dart';
import 'package:flutter/material.dart';
import '../../controllers/ui_key/ui_key.dart';
import '../buttons/full_stacked_button.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.contentBuilder,
    required this.decoration,
    this.decorationOnFocused,
    this.height,
    this.fixed = false,
    this.width,
    required this.onPressed,
    this.focusedUiKey = true,
    this.onLongPress,
    this.padding = 0,
    this.bottomMargin = 0,
    this.duration = const Duration(milliseconds: 3000),
    this.curve = Curves.easeOutCirc,
    required this.foregroundColor,
    this.blurred = false,
    this.zoomingOnClick = false,
    this.onFocusedTransformation,
    this.expandingTappingSensitivity = 0,
  });

  final Widget Function(BuildContext context, bool focused) contentBuilder;
  final Decoration decoration;
  final Decoration? decorationOnFocused;
  final Color foregroundColor;
  final bool focusedUiKey;
  final bool fixed;
  final bool blurred;
  final bool zoomingOnClick;
  final double padding;
  final double bottomMargin;
  final double? height;
  final double? width;
  final double expandingTappingSensitivity;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final Duration duration;
  final Curve curve;
  final TransformData? onFocusedTransformation;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final GlobalKey<State<UiKey>> _uiKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return UiKey(
        key: _uiKey,
        fixed: widget.fixed,
        focusable: widget.onPressed != null && widget.focusedUiKey,
        builder: (context, focused) {
          return Padding(
              padding: EdgeInsets.only(bottom: widget.bottomMargin),
              child: GestureDetector(
                onTap: widget.onPressed,
                child: Container(
                  padding: EdgeInsets.all(widget.expandingTappingSensitivity),
                  color: Colors.transparent,
                  child: AnimatedTransform(
                    data: focused
                        ? (widget.onFocusedTransformation ?? TransformData())
                        : (widget.onFocusedTransformation != null
                            ? widget.onFocusedTransformation!.copyWith(
                                opacity: 1, scale: 1, x: 0, y: 0, forwardedX: 0)
                            : TransformData()),
                    child: ZoomingClickEffect(
                        enabled: widget.zoomingOnClick,
                        child: Stack(fit: StackFit.loose, children: [
                          Positioned.fill(
                            child: Blur(strength: 10, active: widget.blurred),
                          ),
                          AnimatedContainer(
                              curve: widget.curve,
                              duration: widget.duration,
                              clipBehavior: Clip.antiAlias,
                              height: widget.height,
                              width: widget.width,
                              decoration: focused
                                  ? widget.decorationOnFocused ??
                                      widget.decoration
                                  : widget.decoration,
                              child: FilledButtonAsset(
                                  foregroundColor: widget.foregroundColor,
                                  onPressed: widget.onPressed,
                                  onLongPress: widget.onLongPress,
                                  child: Padding(
                                      padding: EdgeInsets.all(widget.padding),
                                      child: widget.contentBuilder(
                                          context, focused))))
                        ])),
                  ),
                ),
              ));
        });
  }
}
