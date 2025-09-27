import 'package:flutter/material.dart';
import 'package:flowter_core/controllers/global_future/global_future.dart';
import '../../controllers/ui_key/ui_key.dart';
import '../buttons/full_stacked_button.dart';
import '../effects/zooming_click_effect.dart';

class Choice<T> extends StatefulWidget {
  const Choice(
      {super.key,
      this.title,
      this.enabled = true,
      required this.hintText,
      this.nullChoicesText = "",
      this.repeatingText = "",
      required this.height,
      required this.currentChoice,
      this.choices,
      this.futureChoices,
      required this.titleDecoration,
      required this.titleDecorationOnDisabled,
      required this.decoration,
      required this.decorationOnFocused,
      required this.clickedButtonColor,
      required this.onPressed,
      required this.titleStyle,
      required this.titleWidth,
      required this.choiceStyle,
      required this.hintStyle,
      required this.pendingWidget,
      this.onErrorDecoration});

  final String? title;
  final bool enabled;
  final Widget pendingWidget;
  final TextStyle titleStyle;
  final TextStyle choiceStyle;
  final TextStyle hintStyle;
  final String nullChoicesText;
  final String repeatingText;
  final String hintText;
  final double height;
  final double titleWidth;
  final T? currentChoice;
  final Map<T, String>? choices;
  final GlobalFuture<Map<T, String>>? futureChoices;
  final Color clickedButtonColor;
  final BoxDecoration titleDecoration;
  final BoxDecoration titleDecorationOnDisabled;
  final BoxDecoration decoration;
  final BoxDecoration decorationOnFocused;
  final BoxDecoration? onErrorDecoration;
  final void Function() onPressed;

  @override
  State<Choice<T>> createState() => _ChoiceState<T>();
}

class _ChoiceState<T> extends State<Choice<T>> {
  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    if (widget.futureChoices != null) {
      widget.futureChoices!.addOnUpdatedListener(_update);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.futureChoices != null) {
      widget.futureChoices!.removeOnUpdatedListener(_update);
    }
    super.dispose();
  }

  Widget get _content {
    if (widget.choices != null) {
      if (widget.currentChoice == null) {
        return Text(widget.hintText, style: widget.hintStyle);
      }
      return Text(widget.choices![widget.currentChoice!]!,
          style: widget.choiceStyle);
    }

    if (widget.futureChoices != null) {
      if (widget.futureChoices!.pending) {
        return widget.pendingWidget;
      }
      if (widget.futureChoices!.error != null) {
        return Text(widget.repeatingText, style: widget.choiceStyle);
      }
      if (widget.futureChoices!.data == null) {
        return Text(widget.nullChoicesText, style: widget.hintStyle);
      }
      if (widget.currentChoice == null) {
        return Text(widget.hintText, style: widget.hintStyle);
      }

      return Text(widget.futureChoices!.data![widget.currentChoice!]!,
          style: widget.choiceStyle);
    }

    return Text(widget.nullChoicesText, style: widget.hintStyle);
  }

  BoxDecoration _decoration(bool focused) {
    if (focused) {
      return widget.decorationOnFocused;
    } else if (widget.futureChoices != null &&
        widget.futureChoices!.error != null) {
      return widget.onErrorDecoration!;
    } else {
      return widget.decoration;
    }
  }

  void Function()? get _onPressed {
    if (widget.enabled &&
        (widget.choices != null ||
            (widget.futureChoices != null &&
                !widget.futureChoices!.pending &&
                widget.futureChoices!.data != null))) {
      return widget.onPressed;
    }
    if (widget.enabled &&
        widget.futureChoices != null &&
        widget.futureChoices!.error != null) {
      return widget.futureChoices!.repeat;
    }
    return null;
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return UiKey(
      key: _key,
      fixed: false,
      focusable: _onPressed != null,
      builder: (context, focused) => ZoomingClickEffect(
        enabled: _onPressed != null,
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          clipBehavior: Clip.antiAlias,
          height: widget.height,
          decoration: _decoration(focused),
          child: FilledButtonAsset(
            foregroundColor: widget.clickedButtonColor,
            onPressed: _onPressed,
            child: Row(children: [
              const SizedBox(width: 3),
              if (widget.title != null)
                AnimatedContainer(
                    width: widget.titleWidth,
                    height: widget.height - 9,
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 500),
                    decoration: (!widget.enabled ||
                            (widget.enabled &&
                                (widget.choices == null &&
                                    (widget.futureChoices == null ||
                                        widget.futureChoices!.pending ||
                                        widget.futureChoices!.data == null))))
                        ? widget.titleDecorationOnDisabled
                        : widget.titleDecoration,
                    child: Center(
                        child: Text(widget.title!, style: widget.titleStyle))),
              Expanded(child: Center(child: _content))
            ]),
          ),
        ),
      ),
    );
  }
}
