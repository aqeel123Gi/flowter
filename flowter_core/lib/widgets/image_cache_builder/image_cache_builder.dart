import 'dart:typed_data';
import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/widgets/animated_transform_switcher/animated_transform_switcher.dart';
import 'package:flowter_core/widgets/button/button.dart';
import 'package:flowter_core/widgets/widget_controller/widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flowter_core/flowter_core.dart';
import 'controller.dart';

class ImageCacheBuilder extends StatefulWidget {
  const ImageCacheBuilder({
    super.key,
    required this.height,
    required this.width,
    required this.uri,
    required this.downloadingWidget,
    required this.onNullWidget,
    required this.errorBuilder,
    required this.color,
    this.imageColor,
    required this.decoration,
    required this.decorationOnFocused,
    required this.duration,
    required this.curve,
    required this.builderOnImage,
  });

  final double? height;
  final double? width;

  final String? uri;
  final Widget downloadingWidget;
  final Widget onNullWidget;
  final Widget Function(
          Object exception, StackTrace stackTrace, void Function() repeat)
      errorBuilder;

  final Color color;
  final Color? imageColor;

  final BoxDecoration decoration;
  final BoxDecoration decorationOnFocused;
  final Duration duration;
  final Curve curve;

  final Widget Function(Uint8List data)? builderOnImage;

  @override
  State<ImageCacheBuilder> createState() => _ImageCacheState();
}

class _ImageCacheState extends State<ImageCacheBuilder> {
  final ImageCacheController _controller = ImageCacheController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<ImageCacheController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {
          return FutureBuilder<Uint8List?>(
              future: _controller.data,
              builder: (context, snapshot) {
                return Button(
                    height: widget.height,
                    width: widget.width,
                    decoration: widget.decoration,
                    decorationOnFocused: widget.decorationOnFocused,
                    duration: widget.duration,
                    curve: widget.curve,
                    onPressed: snapshot.hasError
                        ? () {
                            setState(() {
                              _controller.data = _controller.fetchData();
                            });
                          }
                        : null,
                    foregroundColor: widget.color,
                    contentBuilder: (context, focused) {
                      return SizedBox(
                        height: widget.height,
                        width: widget.width,
                        child: Center(
                          child: AnimatedTransformingSwitcher(
                              duration: widget.duration,
                              switcher:
                                  "${widget.uri}${snapshot.hasData}${snapshot.hasError}",
                              builder: (context, switcherKey) {
                                if (widget.uri == null) {
                                  return widget.onNullWidget;
                                }

                                if (snapshot.hasError) {
                                  return widget.errorBuilder(
                                      snapshot.error!, snapshot.stackTrace!,
                                      () {
                                    setState(() {
                                      _controller.data =
                                          _controller.fetchData();
                                    });
                                  });
                                }

                                if (snapshot.hasData) {
                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                          child: snapshot.data!.isSvgImage
                                              ? SvgPicture.memory(
                                                  snapshot.data!,
                                                  height: widget.height,
                                                  width: widget.width,
                                                  fit: BoxFit.fill,
                                                  color: widget.imageColor,
                                                )
                                              : Image.memory(
                                                  snapshot.data!,
                                                  height: widget.height,
                                                  width: widget.width,
                                                  fit: BoxFit.fill,
                                                  color: widget.imageColor,
                                                )),
                                      if (widget.builderOnImage != null)
                                        Positioned.fill(
                                            child: widget.builderOnImage!(
                                                snapshot.data!))
                                    ],
                                  );
                                }

                                return widget.downloadingWidget;
                              }),
                        ),
                      );
                    });
              });
        });
  }
}
