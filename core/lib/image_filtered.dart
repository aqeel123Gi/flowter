import 'package:fast_image_resizer/fast_image_resizer.dart';
import 'package:flutter/services.dart';

Future<Uint8List> imageFiltered(String assetPath, {int? height, int? width})async{
  Uint8List imageBytes = (await rootBundle.load(assetPath)).buffer.asUint8List();
  if(height!=null || width!= null){
    imageBytes = (await resizeImage(Uint8List.view(imageBytes.buffer), width: width,height: height))!.buffer.asUint8List();
  }
  return imageBytes;
}