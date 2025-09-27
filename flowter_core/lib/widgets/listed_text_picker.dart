import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';

class ListedTextsPicker extends StatefulWidget {
  const ListedTextsPicker(
      {super.key,
      required this.size,
      required this.decoration,
      required this.textStyle,
      required this.choices,
      this.initChoice,
      required this.onChanged});

  final Size size;
  final BoxDecoration decoration;
  final TextStyle textStyle;
  final int? initChoice;
  final List<String> choices;
  final void Function(int index, String choice) onChanged;

  @override
  State<ListedTextsPicker> createState() => _ListedTextsPickerState();
}

class _ListedTextsPickerState extends State<ListedTextsPicker> {
  final ScrollController _controller = ScrollController();
  double? _startOffset;
  List<double> _moves = [];

  void _onPointerDown(PointerDownEvent e) {
    _startOffset = _controller.offset;
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (_startOffset != null) {
      _controller.jumpTo(_startOffset! +
          PublicListener.pointerDownEvent!.position.dy -
          e.position.dy);
      _moves.add(e.position.dy);
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    if (_startOffset != null) {
      if ((e.position.dy - _moves.getFromLast(2)).abs() <= 2) {
        _animate();
      } else {
        _controller.animateTo(
            _controller.offset +
                ((e.position.dy - _moves.getFromLast(2)) * -12),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCirc);
        Future.delayed(const Duration(milliseconds: 250), _animate);
      }

      _startOffset = null;
      _moves = [];
    }
  }

  void _animate([int? index]) {
    _controller.animateTo((index ?? _getCurrentIndex()) * widget.size.height,
        duration: const Duration(seconds: 1), curve: Curves.easeOutCirc);
  }

  int _getCurrentIndex() {
    int i = (_controller.offset / widget.size.height).round();
    return i < 0
        ? 0
        : i >= widget.choices.length
            ? widget.choices.length - 1
            : i;
  }

  _onChange() {
    int i = _getCurrentIndex();
    widget.onChanged(i, widget.choices[i]);
  }

  @override
  void initState() {
    PublicListener.addOnMoveListener(_onPointerMove);
    PublicListener.addOnUpListener(_onPointerUp);
    _controller.addListener(_onChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(
          (widget.initChoice ?? _getCurrentIndex()) * widget.size.height);
    });
    super.initState();
  }

  @override
  void dispose() {
    PublicListener.removeOnMoveListener(_onPointerMove);
    PublicListener.removeOnUpListener(_onPointerUp);
    _controller.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            decoration: widget.decoration,
            child: Listener(
                onPointerDown: _onPointerDown,
                child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: Container(
                        color: Colors.transparent,
                        child: IgnorePointer(
                            child: ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                controller: _controller,
                                children: widget.choices
                                    .map((e) => SizedBox(
                                        height: widget.size.height,
                                        child: Center(
                                            child: Text(e,
                                                style: widget.textStyle,
                                                textAlign: TextAlign.center))))
                                    .toList())))))));
  }
}
