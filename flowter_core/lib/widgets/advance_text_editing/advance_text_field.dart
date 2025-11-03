library advanced_input_text;

import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/functions/exception_message_parser.dart';
import 'package:flowter_core/widgets/animated_transform_switcher/animated_transform_switcher.dart';
import 'package:flowter_core/widgets/effects/circular_tap_effect.dart';
import 'package:flowter_core/widgets/sd_icon/sd_icon.dart';
import 'package:flowter_core/widgets/widget_controller/widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/ui_key/ui_key.dart';

part 'controller.dart';
part 'widget_controller.dart';
part 'text_validation.dart';

class AdvancedTextField extends StatefulWidget {
  const AdvancedTextField({
    super.key,
    this.fixed = false,
    this.editable = true,
    this.hintText = "",
    this.title,
    this.focusNode,
    required this.textStyle,
    required this.hintTextStyle,
    required this.height,
    required this.controller,
    required this.decoration,
    required this.decorationOnFocus,
    required this.cursorColor,
    required this.nonValidatedTextMessageColor,
    required this.waitingColor,
    required this.nonValidatedTextMessageFontSize,
    required this.nonValidatedTextMessageDirection,
    required this.textDirection,
    this.headingIcon,
    this.textInputType = TextInputType.text,
    this.showHintTextOnTyping = false,
    this.onValidateChanged,
    this.lines = 1,
    this.validateAfterChangeDuration,
    this.onChanged,
    this.textValidations = const [],
    this.futureTextValidations = const [],
    this.onPressed,
    this.obscure = false,
    this.allowedCharacters,
    required this.obscureTextIcon,
    required this.noObscureTextIcon,
    this.onValidatedFuture,
    this.visibleValidationMessage = true,
    this.hideHintTextOnTyping = true,
    this.hintTextAlign = TextAlign.start,
    this.valueTextAlign = TextAlign.start,
  });

  final bool fixed;
  final bool editable;
  final String hintText;
  final String? title;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final int lines;
  final TextStyle textStyle;
  final TextStyle hintTextStyle;
  final double height;
  final AdvancedTextFieldController controller;
  final BoxDecoration decoration;
  final BoxDecoration decorationOnFocus;
  final Color nonValidatedTextMessageColor;
  final Color cursorColor;
  final Color waitingColor;
  final double nonValidatedTextMessageFontSize;
  final TextDirection nonValidatedTextMessageDirection;
  final TextDirection textDirection;
  final bool obscure;
  final bool showHintTextOnTyping;
  final bool visibleValidationMessage;
  final SDIcon obscureTextIcon;
  final SDIcon noObscureTextIcon;
  final Duration? validateAfterChangeDuration;
  final Set<String>? allowedCharacters;
  final List<TextValidation> textValidations; //Return False if error
  final List<FutureTextValidation>
      futureTextValidations; //Return False if error
  final void Function(bool)? onValidateChanged;
  final Future<void> Function(String text)? onValidatedFuture;
  final void Function(String text)? onChanged;
  final bool hideHintTextOnTyping;
  final void Function()? onPressed;
  final TextAlign hintTextAlign;
  final TextAlign valueTextAlign;
  final SDIcon? headingIcon;

  @override
  createState() => _AdvancedTextFieldState();
}

class _AdvancedTextFieldState extends State<AdvancedTextField> {
  final AdvancedTextFieldWidgetController _widgetController =
      AdvancedTextFieldWidgetController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<AdvancedTextFieldWidgetController>(
      widget: widget,
      controller: _widgetController,
      builder: (context, c) => _buildContent(context, c),
    );
  }

  Widget _buildContent(
      BuildContext context, AdvancedTextFieldWidgetController c) {
    return Column(children: [
      Center(
          child: Listener(
        onPointerDown: (event) {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          clipBehavior: Clip.antiAlias,
          height: widget.height,
          decoration: c.inFocus ? widget.decorationOnFocus : widget.decoration,
          child: Row(
            children: [
              _headingIcon,
              Expanded(
                child: LayoutBuilder(
                  builder: (_, constraints) => Stack(children: [
                    _textField(constraints),
                    _hintText(constraints),
                    _waitingIndicator,
                  ]),
                ),
              ),
              _obscureButton,
            ],
          ),
        ),
      )),
      const SizedBox(height: 3),
      _validationMessage
    ]);
  }

  Widget _textField(BoxConstraints constraints) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Focus(
              onFocusChange: (inFocus) {
                _widgetController.inFocus = inFocus;
                _widgetController.updateState();
                if (!_widgetController.inFocus) {
                  _widgetController.validateText();
                }
              },
              child: TextField(
                  focusNode: _widgetController.effectiveFocusNode,
                  enabled: widget.editable,
                  style: widget.textStyle,
                  textAlign: widget.valueTextAlign,
                  textDirection: widget.textDirection,
                  cursorColor: widget.cursorColor,
                  cursorWidth: 2,
                  obscureText: _widgetController.obscured,
                  keyboardType: widget.textInputType,
                  onChanged: _widgetController.onTextChanged,
                  controller: widget.controller.textEditing,
                  maxLines: widget.lines,
                  decoration: InputDecoration(
                    filled: false,
                    fillColor: Colors.transparent,
                    focusColor: widget.cursorColor,
                    hoverColor: Colors.transparent,
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  )))),
    );
  }

  Widget _hintText(BoxConstraints constraints) {
    return widget.hideHintTextOnTyping
        ? Center(
            child: AnimatedOpacity(
                opacity: widget.controller.textEditing.text.isEmpty ? 1 : 0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCirc,
                child: IgnorePointer(
                    child: Center(
                        child: Text(widget.hintText,
                            style: widget.hintTextStyle,
                            textAlign: widget.hintTextAlign)))),
          )
        : AnimatedPositionedDirectional(
            start: 0,
            end: widget.controller.textEditing.text.isEmpty
                ? 0
                : constraints.maxWidth * (2 / 3),
            top: 0,
            bottom: 0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutCirc,
            child: IgnorePointer(
                child: Center(
                    child: Text(widget.hintText,
                        style: widget.hintTextStyle,
                        textAlign: widget.hintTextAlign))));
  }

  Widget get _waitingIndicator {
    return PositionedDirectional(
        top: 0,
        bottom: 0,
        end: 3,
        child: Center(
            child: SizedBox(
                height: 30,
                width: 30,
                child: AnimatedTransformingSwitcher(
                    switcher: _widgetController.waiting
                        ? 1
                        : _widgetController.errorOnValidation
                            ? 2
                            : 0,
                    duration: const Duration(milliseconds: 200),
                    builder: (context, switcherKey) => _widgetController.waiting
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                color: widget.waitingColor, strokeWidth: 3))
                        : _widgetController.errorOnValidation
                            ? Center(
                                child: CircularTapEffect(
                                    color: widget.waitingColor,
                                    onPressed: () {
                                      _widgetController.validateText();
                                    },
                                    child: const Icon(Icons.refresh)))
                            : const SizedBox()))));
  }

  Widget get _obscureButton {
    return widget.obscure
        ? Positioned.directional(
            top: 0,
            bottom: 0,
            end: 6,
            textDirection: widget.textDirection,
            child: CircularTapEffect(
                uiKey: _widgetController.obscureButtonKey,
                keyActions: {
                  LogicalKeyboardKey.arrowRight: () {
                    UiKeyController.changeFocusedGlobalKey(
                        _widgetController.uiKey);
                  }
                },
                color: widget.waitingColor.withOpacityMultiply(0.3),
                onPressed: () {
                  _widgetController.obscured = !_widgetController.obscured;
                  _widgetController.updateState();
                },
                child: AnimatedTransformingSwitcher(
                    switcher: _widgetController.obscured,
                    duration: const Duration(milliseconds: 200),
                    builder: (context, switcherKey) =>
                        (_widgetController.obscured
                                ? widget.noObscureTextIcon
                                : widget.obscureTextIcon)
                            .withParams(size: 24, color: widget.waitingColor))))
        : const SizedBox();
  }

  Widget get _headingIcon {
    if (widget.headingIcon != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: 16.0),
        child: widget.headingIcon!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget get _validationMessage {
    return Visibility(
        visible: widget.visibleValidationMessage,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedTransformingSwitcher(
                switcher: _widgetController.nonValidatedMessage,
                duration: const Duration(milliseconds: 500),
                builder: (context, switcherKey) => Center(
                      child: Text(_widgetController.nonValidatedMessage,
                          style: TextStyle(
                              fontSize: widget.nonValidatedTextMessageFontSize,
                              color: widget.nonValidatedTextMessageColor),
                          textAlign: TextAlign.center,
                          textDirection:
                              widget.nonValidatedTextMessageDirection),
                    ))));
  }
}
