part of 'extensions.dart';

extension Uint8ListFunctions on Uint8List {

  bool get isSvgImage{
    try {
      // Convert the first few bytes of data to a string
      final svgSignature = String.fromCharCodes(take(4));

      // Check if the data starts with '<svg'
      if (svgSignature == '<svg') {
        return true; // It's an SVG image
      }
      return false; // Not an SVG image
    } catch (e) {
      return false; // If any error occurs, it's not a valid SVG
    }
  }

}