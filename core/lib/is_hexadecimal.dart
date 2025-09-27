bool isHexadecimal(String input) {
  final RegExp hexRegex = RegExp(r'^[0-9a-fA-F]+$');
  return hexRegex.hasMatch(input);
}