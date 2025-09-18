import 'package:flowter/widgets/advance_text_editing/advance_text_field.dart';

class CustomTextValidationGroup {
  static void setNonValidatedMessages({
    String Function(String)? isNotEmptyNotValidatedMessage,
    String Function(String)? isIntegerNumberNotValidatedMessage,
    String Function(String) Function(int)?
        isNDigitsOfNumbersNotValidatedMessage,
    String Function(String)? isThirdOrMoreNameNotValidatedMessage,
  }) {
    _isNotEmptyNotValidatedMessage = isNotEmptyNotValidatedMessage;
    _isIntegerNumberNotValidatedMessage = isIntegerNumberNotValidatedMessage;
    _isNDigitsOfNumbersNotValidatedMessage =
        isNDigitsOfNumbersNotValidatedMessage;
    _isThirdOrMoreNameNotValidatedMessage =
        isThirdOrMoreNameNotValidatedMessage;
  }

  static String Function(String)? _isNotEmptyNotValidatedMessage;
  static String Function(String)? _isIntegerNumberNotValidatedMessage;
  static String Function(String) Function(int)?
      _isNDigitsOfNumbersNotValidatedMessage;
  static String Function(String)? _isThirdOrMoreNameNotValidatedMessage;

  static List<TextValidation> isNotEmptyOnTrimmed() => [
        TextValidation.isNotEmptyOnTrimmed(_isNotEmptyNotValidatedMessage ??
            (title) => "<$title:isNotEmptyNotValidatedMessage!>")
      ];

  static List<TextValidation> isIntegerNumber() => [
        TextValidation.isNotEmptyOnTrimmed(_isNotEmptyNotValidatedMessage ??
            (title) => "<$title:isNotEmptyNotValidatedMessage!>"),
        TextValidation.isIntegerNumber(_isIntegerNumberNotValidatedMessage ??
            (title) => "<$title:_isIntegerNumberNotValidatedMessage!>"),
      ];

  static List<TextValidation> isNDigitsOfNumbers(int n) => [
        TextValidation.isNotEmptyOnTrimmed(_isNotEmptyNotValidatedMessage ??
            (title) => "<$title:isNotEmptyNotValidatedMessage!>"),
        TextValidation.isNDigitsOfNumbers(
            n,
            _isNDigitsOfNumbersNotValidatedMessage?.call(n) ??
                (title) =>
                    "<$title:$n:_isNDigitsOfNumbersNotValidatedMessage!>"),
      ];

  static List<TextValidation> thirdOrMoreNameTextValidation = [
    TextValidation.isNotEmptyOnTrimmed(_isNotEmptyNotValidatedMessage ??
        (title) => "<$title:isNotEmptyNotValidatedMessage!>"),
    TextValidation.isThirdName(_isThirdOrMoreNameNotValidatedMessage ??
        (title) => "<$title:isThirdOrMoreNameNotValidatedMessage!>"),
  ];
}
