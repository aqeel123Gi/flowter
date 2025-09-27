library interactive_tabs_paging;

import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

part 'controller.dart';

class InteractiveTabsPaging extends StatefulWidget {
  const InteractiveTabsPaging(
      {super.key,
      this.initTitle,
      required this.initPage,
      required this.controller,
      this.onChanged});

  @override
  State<InteractiveTabsPaging> createState() => _InteractiveTabsPagingState();

  final String? initTitle;
  final Widget initPage;

  final InteractiveTabsPagingController controller;
  final void Function(int index, String? title)? onChanged;
}

class _InteractiveTabsPagingState extends State<InteractiveTabsPaging> {
  @override
  void initState() {
    widget.controller._tabsController = controller;
    widget.controller._titles[0] = widget.initTitle;
    widget.controller._pages[0] = widget.initPage;
    super.initState();
  }

  InteractiveTabsController controller = InteractiveTabsController();

  @override
  Widget build(BuildContext context) {
    return InteractiveTabs(
      parentHeight: true,
      scrollable: false,
      controller: controller,
      onChanged: (i) =>
          widget.onChanged?.call(i, widget.controller._titles.last),
      children: widget.controller._pages,
    );
  }
}
