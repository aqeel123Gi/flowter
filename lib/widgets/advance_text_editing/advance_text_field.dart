library advanced_input_text;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flowter/flowter.dart';

import '../../controllers/ui_key/ui_key.dart';

part 'controller.dart';
part 'text_validation.dart';

class AdvancedTextField extends StatefulWidget {
  const AdvancedTextField({
    super.key,
    this.fixed = false,
    this.editable = true,
    this.hintText = "",
    this.title,
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
  });

  final bool fixed;
  final bool editable;
  final String hintText;
  final String? title;
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

  @override
  createState() => _AdvancedTextFieldState();
}

class _AdvancedTextFieldState extends State<AdvancedTextField> {
  bool _inFocus = false;
  String _nonValidatedMessage = "";
  DateTime _changeDateTime =
      DateTime.now().subtract(const Duration(seconds: 10));
  bool _obscured = false;
  bool _waiting = false;
  bool _errorOnValidation = false;

  final GlobalKey<State<UiKey>> _uiKey = GlobalKey();

  void _requestFocus() {
    _focusNode.requestFocus();
  }

  Future<bool?> _validateText() async {
    if (widget.textValidations.isEmpty) {
      widget.controller.validated = true;
      return true;
    }
    if (_waiting == true) {
      return null;
    }

    if (!mounted) {
      return null;
    }

    setState(() {
      _errorOnValidation = false;
      widget.controller.validated = false;
      if (widget.onValidateChanged != null) {
        widget.onValidateChanged!(widget.controller.validated);
      }
      _nonValidatedMessage = "";
      widget.controller.validationMessage = _nonValidatedMessage;
      _waiting = true;
    });

    for (TextValidation validation in widget.textValidations) {
      bool validated = validation.validate(widget.controller.textEditing.text);
      if (!validated) {
        setState(() {
          _nonValidatedMessage =
              validation.onNotValidatedMessage(widget.title.toString());
          widget.controller.validationMessage = _nonValidatedMessage;
          _waiting = false;
        });
        return false;
      }
    }

    for (FutureTextValidation validation in widget.futureTextValidations) {
      bool validated;

      try {
        validated =
            await validation.validate(widget.controller.textEditing.text);
      } catch (e) {
        setState(() {
          _errorOnValidation = true;
          _nonValidatedMessage = parseErrorMessage(e as Exception);
          widget.controller.validationMessage = _nonValidatedMessage;
          _waiting = false;
        });
        return false;
      }

      if (!validated) {
        setState(() {
          widget.controller.validationMessage = _nonValidatedMessage;
          _waiting = false;
        });
        return false;
      }
    }

    setState(() {
      widget.controller.validated = true;
      if (widget.onValidateChanged != null) {
        widget.onValidateChanged!(widget.controller.validated);
      }
      _nonValidatedMessage = "";
      widget.controller.validationMessage = _nonValidatedMessage;
      _waiting = false;
    });

    if (widget.onValidatedFuture != null) {
      setState(() {
        _waiting = true;
      });
      try {
        await widget.onValidatedFuture!(widget.controller.textEditing.text);
      } catch (e) {
        setState(() {
          _errorOnValidation = true;
          _nonValidatedMessage = parseErrorMessage(e as Exception);
          widget.controller.validationMessage = _nonValidatedMessage;
          _waiting = false;
        });
        return false;
      }
      setState(() {
        _waiting = false;
      });
    }

    return true;
  }

  @override
  void initState() {
    _obscured = widget.obscure;
    if (widget.textValidations.isEmpty) {
      widget.controller.validated = true;
    }

    widget.controller.requestFocus = _requestFocus;

    widget.controller.validate = _validateText;
    widget.controller.changeText = (text, validate) {
      widget.controller.textEditing.text = text;
      if (validate) {
        _validateText();
      }
    };

    super.initState();
  }

  final GlobalKey<State<UiKey>> _obscureButtonKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: UiKey(
        key: _uiKey,
        focusable: widget.editable,
        fixed: widget.fixed,
        keyActions: {
          LogicalKeyboardKey.arrowLeft: () {
            if (widget.obscure) {
              UiKeyController.changeFocusedGlobalKey(_obscureButtonKey);
            }
          },
          LogicalKeyboardKey.enter: () {
            setState(() {
              _focusNode.requestFocus();
            });
          },
          LogicalKeyboardKey.goBack: () {},
        },
        builder: (context, focused) => Listener(
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
            decoration: _inFocus || focused
                ? widget.decorationOnFocus
                : widget.decoration,
            child: LayoutBuilder(
              builder: (_, c) => Stack(children: [
                CenterRegardlessLayout(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Focus(
                          onFocusChange: (inFocus) {
                            setState(() {
                              _inFocus = inFocus;
                            });
                            if (!_inFocus) {
                              _validateText();
                            }
                          },
                          child: TextField(
                              focusNode: _focusNode,
                              enabled: widget.editable,
                              style: widget.textStyle,
                              textAlign: TextAlign.center,
                              textDirection: widget.textDirection,
                              cursorColor: widget.cursorColor,
                              cursorWidth: 2,
                              obscureText: _obscured,
                              keyboardType: widget.textInputType,
                              onChanged: (text) async {
                                int startSelection = widget
                                    .controller.textEditing.selection.start;

                                // Chars conversion
                                List<String> textChars =
                                    text.characters.toList();
                                textChars.forIndexedEach((index, element) {
                                  if (AdvancedTextFieldController
                                      ._globalCharConversion
                                      .containsKey(element)) {
                                    textChars[index] =
                                        AdvancedTextFieldController
                                            ._globalCharConversion[element]!;
                                  }
                                });
                                text = textChars.join();
                                widget.controller.textEditing.text = text;
                                widget.controller.textEditing.selection =
                                    TextSelection(
                                        baseOffset: startSelection,
                                        extentOffset: startSelection);

                                // Remove not allowed characters
                                if (widget.allowedCharacters != null) {
                                  int startSelection = widget
                                      .controller.textEditing.selection.start;
                                  String tmp = "";
                                  int erased = 0;
                                  for (var c in text.characters) {
                                    if (widget.allowedCharacters!.contains(c)) {
                                      tmp += c;
                                    } else {
                                      erased++;
                                    }
                                  }
                                  if (text.length != tmp.length) {
                                    widget.controller.textEditing.text = tmp;
                                    widget.controller.textEditing.selection =
                                        TextSelection(
                                            baseOffset: startSelection - erased,
                                            extentOffset:
                                                startSelection - erased);
                                  }
                                }

                                // Additional user defined
                                if (widget.onChanged != null) {
                                  widget.onChanged!(text);
                                }

                                if (widget.validateAfterChangeDuration !=
                                    null) {
                                  _changeDateTime = DateTime.now();
                                  await Future.delayed(
                                      widget.validateAfterChangeDuration!);
                                  if (DateTime.now()
                                          .difference(_changeDateTime)
                                          .inMilliseconds >=
                                      widget.validateAfterChangeDuration!
                                          .inMilliseconds) {
                                    _validateText();
                                  }
                                }

                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              controller: widget.controller.textEditing,
                              maxLines: widget.lines,
                              decoration: InputDecoration(
                                focusColor: widget.cursorColor,
                                // hintStyle: widget.hintTextStyle,
                                // hintText: widget.hintText,
                                border: InputBorder.none,
                              )))),
                ),
                widget.hideHintTextOnTyping
                    ? Center(
                        child: AnimatedOpacity(
                            opacity: widget.controller.textEditing.text.isEmpty
                                ? 1
                                : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOutCirc,
                            child: IgnorePointer(
                                child: Center(
                                    child: Text(widget.hintText,
                                        style: widget.hintTextStyle)))),
                      )
                    : AnimatedPositionedDirectional(
                        start: 0,
                        end: widget.controller.textEditing.text.isEmpty
                            ? 0
                            : c.maxWidth * (2 / 3),
                        top: 0,
                        bottom: 0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOutCirc,
                        child: IgnorePointer(
                            child: Center(
                                child: Text(widget.hintText,
                                    style: widget.hintTextStyle)))),
                PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    end: 3,
                    child: Center(
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: AnimatedTransformingSwitcher(
                                switcher: _waiting
                                    ? 1
                                    : _errorOnValidation
                                        ? 2
                                        : 0,
                                duration: const Duration(milliseconds: 200),
                                builder: (context, switcherKey) => _waiting
                                    ? SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                            color: widget.waitingColor,
                                            strokeWidth: 3))
                                    : _errorOnValidation
                                        ? Center(
                                            child: CircularTapEffect(
                                                color: widget.waitingColor,
                                                onPressed: () {
                                                  _validateText();
                                                },
                                                child:
                                                    const Icon(Icons.refresh)))
                                        : const SizedBox())))),
                widget.obscure
                    ? Positioned(
                        top: 0,
                        bottom: 0,
                        left: 6,
                        child: CircularTapEffect(
                            uiKey: _obscureButtonKey,
                            keyActions: {
                              LogicalKeyboardKey.arrowRight: () {
                                UiKeyController.changeFocusedGlobalKey(_uiKey);
                              }
                            },
                            color: widget.waitingColor.withOpacityMultiply(0.3),
                            onPressed: () {
                              setState(() {
                                _obscured = !_obscured;
                              });
                            },
                            child: AnimatedTransformingSwitcher(
                                switcher: _obscured,
                                duration: const Duration(milliseconds: 200),
                                builder: (context, switcherKey) => (_obscured
                                        ? widget.noObscureTextIcon
                                        : widget.obscureTextIcon)
                                    .withParams(
                                        size: 24, color: widget.waitingColor))))
                    : const SizedBox(),
                // PositionedDirectional(
                //     top: -2,
                //     start: 3,
                //     child: AnimatedOpacity(
                //         opacity: widget.controller.textEditing.text==""?0:1,
                //         duration: const Duration(milliseconds: 300),
                //         child:Padding(
                //             padding: const EdgeInsets.symmetric(horizontal:5),
                //             child:Text(widget.hintText,style: widget.hintTextStyle))))
              ]),
            ),
          ),
        ),
      )),
      const SizedBox(height: 3),
      Visibility(
        visible: widget.visibleValidationMessage,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: AnimatedTransformingSwitcher(
            switcher: _nonValidatedMessage,
            duration: const Duration(milliseconds: 500),
            builder: (context, switcherKey) => Center(
              child: Text(_nonValidatedMessage,
                  style: TextStyle(
                      fontSize: widget.nonValidatedTextMessageFontSize,
                      color: widget.nonValidatedTextMessageColor),
                  textAlign: TextAlign.center,
                  textDirection: widget.nonValidatedTextMessageDirection),
            ),
          ),
        ),
      )
    ]);
  }
}
