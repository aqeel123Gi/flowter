import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

class Tabs extends StatefulWidget {
  const Tabs(
      {super.key,
      required this.shown,
      required this.tabs,
      required this.activeTab,
      required this.viewAnimation,
      required this.tabAnimation,
      required this.viewDecoration,
      required this.tabTextStyle,
      required this.tabSize,
      required this.tabDecoration,
      required this.tabOnFocusedDecoration,
      required this.tabOnActiveDecoration,
      required this.iconSize,
      required this.iconAndTextSpacing,
      required this.horizontalPadding,
      required this.viewHorizontalPadding,
      required this.viewVerticalPadding,
      required this.tabButtonForegroundColor,
      required this.iconColor,
      required this.iconColorOnActive,
      required this.verticalTextShifting});

  // Data
  final bool shown;
  final List<ButtonData> tabs;
  final int activeTab;

  // Style
  final DurationCurve viewAnimation;
  final DurationCurve tabAnimation;

  final BoxDecoration viewDecoration;

  final double iconSize;
  final double iconAndTextSpacing;
  final double horizontalPadding;

  final double viewHorizontalPadding;
  final double viewVerticalPadding;

  final TextStyle tabTextStyle;

  final Color tabButtonForegroundColor;
  final Color iconColor;
  final Color iconColorOnActive;

  final double tabSize;

  final BoxDecoration tabDecoration;
  final BoxDecoration tabOnFocusedDecoration;
  final BoxDecoration tabOnActiveDecoration;

  final double verticalTextShifting;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  bool init = false;

  late List<double> tabsWidth;

  @override
  void initState() {
    tabsWidth = [];
    for (int i = 0; i < widget.tabs.length; i++) {
      tabsWidth.add(0);
    }
    addPostFrameCallback(() {
      setState(() {
        init = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        AnimatedPositioned(
            left: 0,
            right: 0,
            duration: widget.viewAnimation.duration,
            curve: widget.viewAnimation.curve,
            bottom: widget.shown && init
                ? 0
                : -(MediaQuery.of(context).padding.bottom +
                    widget.tabSize +
                    (widget.viewVerticalPadding * 2)),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.viewHorizontalPadding,
                  vertical: widget.viewVerticalPadding),
              decoration: widget.viewDecoration,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: widget.tabs.build(
                        (i, e) => _tabButton(i == widget.activeTab, i, e))),
              ),
            ))
      ]);

  _tabButton(bool active, int index, ButtonData tab) {
    return Button(
      foregroundColor: widget.tabButtonForegroundColor,
      duration: widget.tabAnimation.duration,
      curve: widget.tabAnimation.curve,
      height: widget.tabSize,
      decoration: active ? widget.tabOnActiveDecoration : widget.tabDecoration,
      decorationOnFocused:
          active ? widget.tabOnActiveDecoration : widget.tabOnFocusedDecoration,
      onPressed: tab.onPressed,
      zoomingOnClick: false,
      contentBuilder: (context, focused) {
        return Row(
          children: [
            SizedBox(
                width: widget.tabSize,
                child: tab.icon != null
                    ? tab.icon!.withParams(
                        size: widget.iconSize,
                        color: active
                            ? widget.iconColorOnActive
                            : widget.iconColor)
                    : Icon(tab.iconData,
                        size: widget.iconSize,
                        color: active
                            ? widget.iconColorOnActive
                            : widget.iconColor)),
            AnimatedTransform(
                data: active ? appearTransform(index) : hiddenTransform(index),
                child: ChildSizeDetector(
                    flexibleAxis: Axis.horizontal,
                    onChange: (size) {
                      if (mounted) {
                        setState(() {
                          tabsWidth[index] = size.width;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                            tab.title != null
                                ? tab.title!
                                : tab.titleBuilder != null
                                    ? tab.titleBuilder!()
                                    : '',
                            style: widget.tabTextStyle),
                        SizedBox(width: (widget.tabSize - widget.iconSize))
                      ],
                    ))),
          ],
        );
      },
    );
  }

  TransformData hiddenTransform(int tabIndex) => TransformData(
      opacity: 0,
      y: widget.verticalTextShifting,
      x: widget.iconSize,
      width: 0,
      duration: widget.tabAnimation.duration,
      curve: widget.tabAnimation.curve);
  TransformData appearTransform(int tabIndex) => TransformData(
      opacity: 1,
      y: widget.verticalTextShifting,
      x: 0,
      width: tabsWidth[tabIndex],
      duration: widget.tabAnimation.duration,
      curve: widget.tabAnimation.curve);
}
