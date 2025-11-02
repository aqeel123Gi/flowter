import 'package:flowter_core/controllers/ui_key/ui_key.dart';
import 'package:flowter_core/widgets/screen_debugger/screen_debugger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../functions/functions.dart';

class HiddenTextInputController {
  void Function()? _updateState;
  bool Function()? _focusingOn;

  void focusingOn(bool Function() on) {
    _focusingOn = on;
    if (_updateState != null) {
      _updateState!();
    }
  }
}

class HiddenTextInput extends StatefulWidget {
  const HiddenTextInput(
      {super.key,
      this.eraseOnSubmitted = false,
      this.keyboardType = TextInputType.none,
      this.onSubmitted,
      this.submitWhenTextChangesTo,
      this.controller,
      this.submittable,
      required this.child});

  final Widget child;
  final void Function(String)? onSubmitted;
  final bool Function(String)? submitWhenTextChangesTo;
  final bool eraseOnSubmitted;
  final TextInputType keyboardType;
  final HiddenTextInputController? controller;
  final bool Function(String text)? submittable;

  @override
  State<HiddenTextInput> createState() => _HiddenTextInputState();
}

class _HiddenTextInputState extends State<HiddenTextInput> {
  final FocusNode _node = FocusNode();
  final TextEditingController _controller = TextEditingController();

  void _focus() {
    if (widget.controller == null ||
        widget.controller!._focusingOn == null ||
        widget.controller!._focusingOn!()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _node.requestFocus();
    }
  }

  @override
  void initState() {
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);

    if (widget.controller != null) {
      widget.controller!._updateState = () {
        setState(() {});
      };
    }
    loopExecution(
        function: _focus,
        stopOn: () => !mounted,
        breakDuration: const Duration(milliseconds: 100));
    super.initState();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _submit(_controller.text);
      } else if (physicalKeys.containsKey(event.physicalKey)) {
        _controller.text = _controller.text + physicalKeys[event.physicalKey]!;
        try {
          UiKeyController.changeFocusedGlobalKey(_key);
        } catch (_) {}
      } else if (event.character != null &&
          "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
              .contains(event.character!)) {
        _controller.text = _controller.text + event.character!;
        try {
          UiKeyController.changeFocusedGlobalKey(_key);
        } catch (_) {}
      }
    }

    return true;
  }

  _submit(String text) {
    if (text.isNotEmpty &&
        (widget.submittable == null || widget.submittable!(text))) {
      if (widget.onSubmitted != null) {
        DebuggerConsole.addLine("Submitted: $text");
        widget.onSubmitted!(text);
      }
      if (widget.eraseOnSubmitted) {
        _controller.text = "";
      }
      _focus();
    }
  }

  Map<PhysicalKeyboardKey, String> physicalKeys = {
    PhysicalKeyboardKey.keyA: "a",
    PhysicalKeyboardKey.keyB: "b",
    PhysicalKeyboardKey.keyC: "c",
    PhysicalKeyboardKey.keyD: "d",
    PhysicalKeyboardKey.keyE: "e",
    PhysicalKeyboardKey.keyF: "f",
  };

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _focus();

    return UiKey(
        key: _key,
        focusable: true,
        keyActions: {
          // LogicalKeyboardKey.digit0: ()=>UiKeyController.changeFocusedGlobalKey(_key),
          LogicalKeyboardKey.enter: () {},
          LogicalKeyboardKey.select: () {},
        },
        builder: (context, focused) => Stack(children: [
              Positioned(
                  top: 0, bottom: 0, left: 0, right: 0, child: widget.child),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                      opacity: 0,
                      child: IgnorePointer(
                        child: TextField(
                          readOnly: true,
                          controller: _controller,
                          focusNode: _node,
                          keyboardType: TextInputType.none,
                          autofocus: true,
                          onTapOutside: (_) {
                            _focus();
                          },
                          onChanged: (text) {
                            _focus();
                            if (widget.submitWhenTextChangesTo != null &&
                                widget.submitWhenTextChangesTo!(text)) {
                              _submit(text);
                            }
                          },
                          onSubmitted: (text) {
                            _submit(text);
                          },
                        ),
                      ))),
            ]));
  }
}
