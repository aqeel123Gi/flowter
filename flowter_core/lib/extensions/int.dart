part of 'extensions.dart';

extension IntFunctions on int {

  String get textWithCommasSeparator => toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

}