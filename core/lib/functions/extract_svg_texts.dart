import 'package:xml/xml.dart';

String extractTextFromSvg(String svgString) {
  final document = XmlDocument.parse(svgString);
  final textElements = document.findAllElements('text');
  final texts = textElements.map((element) => element.innerXml).join(' ');
  return texts;
}