import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flowter/flowter.dart';

class DebuggerConsoleData {
  static List<MapEntry<String, Color>> texts = [];
  static List<MapEntry<EdgesCoordinates, Color>> rectangles = [];
  static final Map<String, MapEntry<String, Color>> pinnedLines = {};
  static Uint8List? imageData;
  static Offset? position;
}

class DebuggerConsole extends StatefulWidget {
  static bool initialized = false;

  static late bool Function() enabled;

  static late Future<void> Function() enable;
  static late Future<void> Function() disable;

  static void Function(String key, String text, {Color? color}) setPinnedLine =
      (String key, String text, {Color? color}) {
    DebuggerConsoleData.pinnedLines[key] =
        MapEntry(text, color ?? Colors.green);
  };
  static late void Function(String key) removePinnedLines;

  static late void Function() clear;
  static late void Function() clearLines;
  static late void Function() clearPinnedLines;

  static void Function(String text, {Color? color}) addLine =
      (String text, {Color? color}) {};
  static void Function(EdgesCoordinates edges, {Color? color}) addRectangle =
      (EdgesCoordinates edges, {Color? color}) {};
  static void Function(Uint8List imageData) showImage =
      (Uint8List imageData) {};
  static late void Function(Offset offset) showPosition;

  const DebuggerConsole({super.key, required this.child});

  final Widget child;

  @override
  State<DebuggerConsole> createState() => _DebuggerConsoleState();
}

class _DebuggerConsoleState extends State<DebuggerConsole> {
  bool _enabled = false;

  final double _opacity = 0.7;

  final ScrollController _controller = ScrollController();

  void _scrollToLast() {
    if (DebuggerConsoleData.texts.isNotEmpty) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _clear() {
    setState(() {
      DebuggerConsoleData.texts = [];
      DebuggerConsoleData.rectangles = [];
    });
  }

  void _clearLines() {
    setState(() {
      DebuggerConsoleData.texts = [];
    });
  }

  void _clearPinnedLines() {
    setState(() {
      DebuggerConsoleData.pinnedLines.clear();
    });
  }

  void _addPinnedLine(String key, String text, {Color? color}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLast();
    });
    setState(() {
      DebuggerConsoleData.pinnedLines[key] =
          MapEntry(text, color ?? Colors.green);
    });
  }

  void _removePinnedLine(String key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLast();
    });
    setState(() {
      DebuggerConsoleData.pinnedLines.remove(key);
    });
  }

  void _addLine(String text, {Color? color}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLast();
    });
    setState(() {
      DebuggerConsoleData.texts.add(MapEntry(text, color ?? Colors.green));
    });
  }

  void _addRectangle(EdgesCoordinates edges, {Color? color}) {
    setState(() {
      DebuggerConsoleData.rectangles
          .add(MapEntry(edges, color ?? Colors.green));
    });
  }

  void _showImage(Uint8List imageData) {
    setState(() {
      DebuggerConsoleData.imageData = imageData;
    });
  }

  void _showPosition(Offset offset) {
    setState(() {
      DebuggerConsoleData.position = offset;
    });
  }

  Future<void> _enable() async {
    Box box = await Hive.openBox("DebuggerConsole");
    await box.put("enabled", true);
    setState(() {
      _enabled = true;
    });
  }

  Future<void> _disable() async {
    Box box = await Hive.openBox("DebuggerConsole");
    await box.put("enabled", false);
    setState(() {
      _enabled = false;
    });
  }

  @override
  void initState() {
    DebuggerConsole.clear = _clear;
    DebuggerConsole.clearLines = _clearLines;
    DebuggerConsole.clearPinnedLines = _clearPinnedLines;
    DebuggerConsole.setPinnedLine = _addPinnedLine;
    DebuggerConsole.removePinnedLines = _removePinnedLine;
    DebuggerConsole.addLine = _addLine;
    DebuggerConsole.addRectangle = _addRectangle;
    DebuggerConsole.showImage = _showImage;
    DebuggerConsole.showPosition = _showPosition;

    DebuggerConsole.enable = _enable;
    DebuggerConsole.disable = _disable;

    DebuggerConsole.enabled = () => _enabled;

    DebuggerConsole.initialized = true;

    addPostFrameCallback(() async {
      Box box = await Hive.openBox("DebuggerConsole");
      setState(() {
        _enabled = box.get("enabled", defaultValue: false);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      Visibility(
          visible: _enabled,
          child: IgnorePointer(
              child: Opacity(
                  opacity: _opacity,
                  child: Stack(children: [
                    Stack(children: [
                      Positioned(
                          bottom: 20,
                          height: 100,
                          right: 20,
                          width: 100,
                          child: DebuggerConsoleData.imageData != null
                              ? Image.memory(DebuggerConsoleData.imageData!)
                              : const SizedBox())
                    ]),
                    Stack(
                        children: DebuggerConsoleData.rectangles
                            .map((e) => Positioned(
                                top: e.key.top,
                                height: e.key.bottom - e.key.top,
                                left: e.key.left,
                                width: e.key.right - e.key.left,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: e.value, width: 1)),
                                )))
                            .toList()),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom *
                                    0.2),
                            child: ListView(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                controller: _controller,
                                children: [
                                  ...DebuggerConsoleData.texts.build((_, e) =>
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 3, right: 3, top: 3),
                                              color: Colors.black
                                                  .withValues(alpha: 1),
                                              child: Text(e.key,
                                                  style: TextStyle(
                                                      color: e.value,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold))))),
                                  ...DebuggerConsoleData.pinnedLines.build(
                                      (_, e) => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 3, right: 3, top: 3),
                                              color: Colors.black
                                                  .withValues(alpha: 1),
                                              child: Text(e.key,
                                                  style: TextStyle(
                                                      color: e.value,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold))))),
                                ]))),
                    DebuggerConsoleData.position != null
                        ? Positioned(
                            left: DebuggerConsoleData.position!.dx - 5,
                            top: DebuggerConsoleData.position!.dy - 5,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                            ))
                        : const SizedBox()
                  ])))),
    ]);
  }
}
