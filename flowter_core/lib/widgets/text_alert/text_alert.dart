import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';

class TextAlert extends StatefulWidget {
  static late void Function(
      {required SDIcon icon,
      required Color iconColor,
      required String text,
      required Duration duration,
      void Function()? onPressed}) push;

  const TextAlert(
      {super.key,
      required this.textStyle,
      required this.frameDecoration,
      required this.horizontalPadding});

  final BoxDecoration frameDecoration;
  final double horizontalPadding;
  final TextStyle textStyle;

  @override
  State<TextAlert> createState() => _TextAlertState();
}

class _TextAlertState extends State<TextAlert> {
  int length = 0;
  List<SDIcon> icons = [];
  List<Color> colors = [];
  List<String> texts = [];
  List<void Function()?> onPressedList = [];
  List<Duration> durations = [];

  bool onMotion = false;
  bool onWindow = false;
  bool openedMessage = false;

  double _width = 0;

  static const Curve _curve = Curves.easeOutCirc;
  static const Duration _duration = Duration(milliseconds: 700);

  @override
  void initState() {
    TextAlert.push = (
        {required SDIcon icon,
        required Color iconColor,
        required String text,
        required Duration duration,
        void Function()? onPressed}) async {
      length++;
      icons.add(icon);
      colors.add(iconColor);
      texts.add(text);
      onPressedList.add(onPressed);
      durations.add(duration);
      if (!onMotion) {
        setState(() {
          onWindow = true;
        });
        await Future.delayed(_duration - const Duration(milliseconds: 300));
        openMessage();
      }
    };
    super.initState();
  }

  void openMessage() async {
    setState(() {
      openedMessage = true;
    });
    await Future.delayed(durations.removeLast());

    disposedFromWindow();
  }

  void disposedFromWindow() async {
    setState(() {
      openedMessage = false;
    });
    await Future.delayed(_duration - const Duration(milliseconds: 300));
    setState(() {
      onWindow = false;
    });
    await Future.delayed(_duration);
    onMotion = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(children: [
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: AnimatedTransform(
            data: TransformData(
                opacity: !onWindow ? 0 : 1,
                y: !onWindow ? 0 : -100,
                duration: _duration,
                curve: _curve),
            child: Center(
              child: Button(
                onPressed: onPressedList.isNotEmpty ? onPressedList.last : null,
                foregroundColor: colors.isNotEmpty
                    ? colors.last.withOpacityMultiply(0.5)
                    : Colors.white,
                padding: 8,
                decoration: widget.frameDecoration,
                contentBuilder: (context, focused) => length == 0
                    ? const SizedBox()
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: icons.last
                              .withParams(color: colors.last, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: AnimatedContainer(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            curve: _curve,
                            duration: _duration,
                            width: openedMessage ? _width : 0,
                            child: ChildSizeDetector(
                                flexibleAxis: Axis.horizontal,
                                onChange: (size) {
                                  setState(() {
                                    _width = size.width;
                                  });
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: Window.width(context) -
                                                ((widget.horizontalPadding *
                                                        2) +
                                                    100)),
                                        child: Text(texts.last,
                                            style: widget.textStyle)),
                                    const SizedBox(width: 8),
                                  ],
                                )),
                          ),
                        )
                      ]),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
