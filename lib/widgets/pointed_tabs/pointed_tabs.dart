import 'dart:math';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import '../buttons/full_stacked_button.dart';

class TabPoint{

  String title;
  bool enabled;

  TabPoint({required this.title,required this.enabled});
}

class TabPoints extends StatefulWidget {
  const TabPoints({
    super.key,
    required this.currentIndex,
    this.axis = Axis.horizontal,
    required this.shownText,
    required this.points,
    required this.duration,
    required this.curve,
    required this.currentTabPointSize,
    required this.tabPointsSize,
    required this.spaceBetweenPoints,
    this.currentTabPointDecoration = const BoxDecoration(),
    this.otherEnabledTabPointDecoration = const BoxDecoration(),
    this.otherDisabledTabPointDecoration = const BoxDecoration(),
    this.currentTabPointTextStyle = const TextStyle(),
    this.otherEnabledTabPointTextStyle = const TextStyle(),
    this.otherDisabledTabPointTextStyle = const TextStyle(),
    this.textWidth = 100,
    this.spaceBetweenTextsAndPoints = 50,

    required this.onTabPointPressed
  });

  final int currentIndex;
  final bool shownText;
  final Axis axis;
  final double spaceBetweenPoints;
  final double currentTabPointSize;
  final double tabPointsSize;
  final double textWidth;
  final double spaceBetweenTextsAndPoints;
  final BoxDecoration currentTabPointDecoration;
  final BoxDecoration otherEnabledTabPointDecoration;
  final BoxDecoration otherDisabledTabPointDecoration;
  final TextStyle currentTabPointTextStyle;
  final TextStyle otherEnabledTabPointTextStyle;
  final TextStyle otherDisabledTabPointTextStyle;
  final Duration duration;
  final Curve curve;
  final List<TabPoint> points;
  final void Function(int index) onTabPointPressed;

  @override
  State<TabPoints> createState() => _TabPointsState();
}

class _TabPointsState extends State<TabPoints> {


  Widget tabPointWidgetVerticalWithOutline(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          duration: widget.duration,
          curve: widget.curve,
          height: widget.currentIndex == index ? widget.currentTabPointSize : widget
              .tabPointsSize,
          width: widget.currentIndex == index ? widget.currentTabPointSize : widget
              .tabPointsSize,
          decoration: widget.currentIndex == index ?
          widget.currentTabPointDecoration
              : widget.points[index].enabled
              ? widget.otherEnabledTabPointDecoration
              : widget.otherDisabledTabPointDecoration,
          child: FilledButtonAsset(
            onPressed: widget.points[index].enabled ? () =>
                widget.onTabPointPressed(index) : null,
          ),
        ),
        !widget.shownText?const SizedBox():SizedBox(width: widget.spaceBetweenTextsAndPoints),
        !widget.shownText?const SizedBox():SizedBox(
          width: widget.textWidth,
          child: AnimatedDefaultTextStyle(
              style: widget.currentIndex == index ? widget.currentTabPointTextStyle : widget.points[index].enabled?widget.otherEnabledTabPointTextStyle:widget.otherDisabledTabPointTextStyle,
              curve: widget.curve,
              duration: widget.duration,
              child: Text(widget.points[index].title)),
        )
      ],
    );
  }


  Widget tabPointWidgetHorizontal(int index) {
    return AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          duration: widget.duration,
          curve: widget.curve,
          height: widget.currentIndex == index ? widget.currentTabPointSize : widget
              .tabPointsSize,
          width: widget.currentIndex == index ? widget.currentTabPointSize : widget
              .tabPointsSize,
          decoration: widget.currentIndex == index ?
          widget.currentTabPointDecoration
              : widget.points[index].enabled
              ? widget.otherEnabledTabPointDecoration
              : widget.otherDisabledTabPointDecoration,
          child: FilledButtonAsset(
            onPressed: widget.points[index].enabled ? () =>
                widget.onTabPointPressed(index) : null,
          ),
        );
  }

  Widget outline (int index) {
    return AnimatedTransformingSwitcher(
          duration: widget.duration,
          switcher: index,
          builder: (context, switcherKey)=>Center(child: Text(tryGet(()=>widget.points[index].title,"")!,style: widget.currentTabPointTextStyle))
    );
  }

  @override
  Widget build(BuildContext context) {

    return widget.axis == Axis.horizontal
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: max(widget.currentTabPointSize, widget.tabPointsSize),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(widget.points.length, (index) => tabPointWidgetHorizontal(index)).insertBetweenElements(
                        widget.axis == Axis.horizontal ? SizedBox(width: widget.spaceBetweenPoints) : SizedBox(width: widget.spaceBetweenPoints))),
                  ),
                  !widget.shownText?const SizedBox():SizedBox(height: widget.spaceBetweenTextsAndPoints),
                  !widget.shownText?const SizedBox():Center(child: outline(widget.currentIndex))
                ],
              )
              : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(widget.points.length, (index) => tabPointWidgetVerticalWithOutline(index)).
    insertBetweenElements(widget.axis == Axis.horizontal ? SizedBox(width: widget.spaceBetweenPoints) : SizedBox(height: widget.spaceBetweenPoints)))
        ;
  }
}



