// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:image_scaler/image_scaler.dart';
// import 'package:image_scaler/types.dart';
//
//
//
// class ImageScale extends StatefulWidget {
//   const ImageScale({
//     super.key,
//     required this.image
//   });
//
//   final ui.Image image;
//
//
//
//   @override
//   State<ImageScale> createState() => _ImageScaleState();
// }
//
// class _ImageScaleState extends State<ImageScale> {
//
//   late Future<ui.Image> future;
//
//   @override
//   void initState() {
//     future  = scale(
//         image: widget.image,
//         newSize: const IntSize(200, 200),
//         algorithm: ScaleAlgorithm.megak,
//         areaRadius: 2
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Future<ui.Image> round = scale(
//       image: widget.round,
//       newSize: const IntSize(200, 200),
//       algorithm: ScaleAlgorithm.megak,
//       areaRadius: 2
//     );
//
//     return const Placeholder();
//   }
// }
