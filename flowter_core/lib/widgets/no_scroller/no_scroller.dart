import 'package:flutter/material.dart';

/// Remove the scroller from [ListView] or [SingleChildScrollView] for its children.
class NoScroller extends StatefulWidget {
  const NoScroller({
    super.key,
    this.active = true,
    required this.child
  });

  final bool active;
  final Widget child;

  @override
  State<NoScroller> createState() => _NoScrollerState();
}

class _NoScrollerState extends State<NoScroller> {

  @override
  Widget build(BuildContext context) {

    return ScrollConfiguration(
        behavior: NoScrollGlowBehavior(widget.active),
        child: widget.child
    );
  }
}

class NoScrollGlowBehavior extends ScrollBehavior {

  final bool active;

  const NoScrollGlowBehavior(this.active);

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return active?child:super.buildOverscrollIndicator(context,child,details);
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return active?child:super.buildScrollbar(context,child,details);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }



}
