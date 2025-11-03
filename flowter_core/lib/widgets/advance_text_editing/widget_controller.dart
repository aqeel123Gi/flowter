part of 'advance_text_field.dart';

class AdvancedTextFieldWidgetController
    extends WidgetController<AdvancedTextField> {
  bool inFocus = false;
  String nonValidatedMessage = "";
  DateTime changeDateTime =
      DateTime.now().subtract(const Duration(seconds: 10));
  bool obscured = false;
  bool waiting = false;
  bool errorOnValidation = false;
  final GlobalKey<State<UiKey>> obscureButtonKey = GlobalKey();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<State<UiKey>> uiKey = GlobalKey();

  FocusNode get effectiveFocusNode => widget.focusNode ?? focusNode;

  void requestFocus() {
    effectiveFocusNode.requestFocus();
  }

  Future<bool?> validateText() async {
    if (widget.textValidations.isEmpty) {
      widget.controller.validated = true;
      return true;
    }
    if (waiting == true) {
      return null;
    }

    if (!mounted()) {
      return null;
    }

    updateState();
    errorOnValidation = false;
    widget.controller.validated = false;
    if (widget.onValidateChanged != null) {
      widget.onValidateChanged!(widget.controller.validated);
    }
    nonValidatedMessage = "";
    widget.controller.validationMessage = nonValidatedMessage;
    waiting = true;
    updateState();

    for (TextValidation validation in widget.textValidations) {
      bool validated = validation.validate(widget.controller.textEditing.text);
      if (!validated) {
        nonValidatedMessage =
            validation.onNotValidatedMessage(widget.title.toString());
        widget.controller.validationMessage = nonValidatedMessage;
        waiting = false;
        updateState();
        return false;
      }
    }

    for (FutureTextValidation validation in widget.futureTextValidations) {
      bool validated;

      try {
        validated =
            await validation.validate(widget.controller.textEditing.text);
      } catch (e) {
        errorOnValidation = true;
        nonValidatedMessage = parseErrorMessage(e as Exception);
        widget.controller.validationMessage = nonValidatedMessage;
        waiting = false;
        updateState();
        return false;
      }

      if (!validated) {
        widget.controller.validationMessage = nonValidatedMessage;
        waiting = false;
        updateState();
        return false;
      }
    }

    widget.controller.validated = true;
    if (widget.onValidateChanged != null) {
      widget.onValidateChanged!(widget.controller.validated);
    }
    nonValidatedMessage = "";
    widget.controller.validationMessage = nonValidatedMessage;
    waiting = false;
    updateState();

    if (widget.onValidatedFuture != null) {
      waiting = true;
      updateState();
      try {
        await widget.onValidatedFuture!(widget.controller.textEditing.text);
      } catch (e) {
        errorOnValidation = true;
        nonValidatedMessage = parseErrorMessage(e as Exception);
        widget.controller.validationMessage = nonValidatedMessage;
        waiting = false;
        updateState();
        return false;
      }
      waiting = false;
      updateState();
    }

    return true;
  }

  @override
  void onInit() {
    obscured = widget.obscure;
    if (widget.textValidations.isEmpty) {
      widget.controller.validated = true;
    }

    widget.controller.requestFocus = requestFocus;
    widget.controller.validate = validateText;
    widget.controller.changeText = (text, validate) {
      widget.controller.textEditing.text = text;
      if (validate) {
        validateText();
      }
    };
  }



  Future<void> onTextChanged(String text) async {
    int startSelection = widget.controller.textEditing.selection.start;

    // Chars conversion
    List<String> textChars = text.characters.toList();
    textChars.forIndexedEach((index, element) {
      if (AdvancedTextFieldController._globalCharConversion
          .containsKey(element)) {
        textChars[index] =
            AdvancedTextFieldController._globalCharConversion[element]!;
      }
    });
    text = textChars.join();
    widget.controller.textEditing.text = text;
    widget.controller.textEditing.selection =
        TextSelection(baseOffset: startSelection, extentOffset: startSelection);

    // Remove not allowed characters
    if (widget.allowedCharacters != null) {
      int startSelection = widget.controller.textEditing.selection.start;
      String tmp = "";
      int erased = 0;
      for (var char in text.characters) {
        if (widget.allowedCharacters!.contains(char)) {
          tmp += char;
        } else {
          erased++;
        }
      }
      if (text.length != tmp.length) {
        widget.controller.textEditing.text = tmp;
        widget.controller.textEditing.selection = TextSelection(
            baseOffset: startSelection - erased,
            extentOffset: startSelection - erased);
      }
    }

    // Additional user defined
    if (widget.onChanged != null) {
      widget.onChanged!(text);
    }

    if (widget.validateAfterChangeDuration != null) {
      changeDateTime = DateTime.now();
      await Future.delayed(widget.validateAfterChangeDuration!);
      if (DateTime.now().difference(changeDateTime).inMilliseconds >=
          widget.validateAfterChangeDuration!.inMilliseconds) {
        validateText();
      }
    }

    updateState();
  }
}
