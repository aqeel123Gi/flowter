import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<ui.Image> loadImage( Uint8List data ,int size) async {
  final img.Image image = img.decodeImage(data)!;
  final img.Image resized = img.copyResize(image, width: size,height: size);
  final Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resized));
  final Completer<ui.Image> completer = Completer();

  ui.decodeImageFromList(resizedBytes, (ui.Image img) => completer.complete(img));
  return completer.future;
}

Future<Uint8List> testImage()async{
  ui.PictureRecorder recorder = ui.PictureRecorder();
  Paint paint = Paint()
    ..strokeWidth = 5
    ..color = Colors.black
    ..style = PaintingStyle.fill;
  Canvas c = Canvas(recorder, const Rect.fromLTWH(0.0, 0.0, 200.0, 200.0));
  c.drawOval(const Rect.fromLTRB(0, 0, 200, 200), paint);
  var image = await recorder.endRecording().toImage(200, 200);
  ByteData data = (await image.toByteData(format: ui.ImageByteFormat.png))!;
  return data.buffer.asUint8List();
}

Future<Uint8List> advancedImageFilter(Uint8List imageUInt8List,int size)async{

  ui.PictureRecorder recorder = ui.PictureRecorder();
  Paint paint = Paint()
    ..strokeWidth = 5
    ..color = Colors.black
    ..style = PaintingStyle.fill;
  ui.Image image = await loadImage(imageUInt8List,size);
  Canvas canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, size.toDouble(), size.toDouble()));
  Path path = Path()..addOval(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));
  canvas.clipPath(path);
  canvas.drawImage(image, const Offset(0, 0), paint);

  var x = await recorder.endRecording().toImage(size, size);

  ByteData data = (await x.toByteData(format: ui.ImageByteFormat.png))!;
  return data.buffer.asUint8List();
}


