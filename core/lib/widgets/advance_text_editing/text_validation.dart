part of 'advance_text_field.dart';

class TextValidation{

  final bool Function(String text) validate;
  final String Function(String textFieldTitle) onNotValidatedMessage;
  TextValidation({
    required this.validate,
    required this.onNotValidatedMessage
  });

  /// ✅ التحقق من أن النص غير فارغ بعد التخفيف
  static TextValidation isNotEmptyOnTrimmed(
      String Function(String title) onNotValidatedMessage) {
    return TextValidation(
      validate: (text) => text.trim().isNotEmpty,
      onNotValidatedMessage: onNotValidatedMessage,
    );
  }


  static TextValidation isIntegerNumber(
      String Function(String title) onNotValidatedMessage) {
    return TextValidation(
      validate: (text) => int.tryParse(text) != null,
      onNotValidatedMessage: onNotValidatedMessage,
    );
  }

  /// ✅ التحقق من صحة البريد الإلكتروني
  static TextValidation isEmail(
      String Function(String title) onNotValidatedMessage) {
    return TextValidation(
      validate: (text) {
        final regExr = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
        return regExr.hasMatch(text.trim());
      },
      onNotValidatedMessage: onNotValidatedMessage,
    );
  }

  /// ✅ التحقق من أن النص يحتوي على n أرقام بالضبط
  static TextValidation isNDigitsOfNumbers(
      int n, String Function(String title) onNotValidatedMessage) {
    return TextValidation(
      validate: (text) => text.length == n && RegExp(r'^[0-9]+$').hasMatch(text.trim()),
      onNotValidatedMessage: onNotValidatedMessage,
    );
  }

  /// ✅ التحقق من أن النص يحتوي على n محارف أو أكثر
  static TextValidation isNDigitsOrMore(
      int n, String Function(String title) onNotValidatedMessage) {
    return TextValidation(
      validate: (text) => text.length >= n,
      onNotValidatedMessage: onNotValidatedMessage,
    );
  }

  /// ✅ التحقق من أن الاسم يحتوي على 3 كلمات أو أكثر
  static TextValidation isThirdName(
      String Function(String title) onNotValidatedMessage) {
    return TextValidation(
      validate: (text) => text.trim().split(' ').length >= 3,
      onNotValidatedMessage: onNotValidatedMessage,
    );
  }

}



class FutureTextValidation{
  final Future<bool> Function(String text) validate;
  final String Function(String textFieldTitle) onNotValidatedMessage;
  FutureTextValidation({
    required this.validate,
    required this.onNotValidatedMessage
  });
}