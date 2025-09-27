import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flowter_core/flowter_core.dart';
import 'package:flowter_core/widgets/partial_state_builder/partial_state_builder.dart';

class DraggableBottomSheetController
    extends WidgetController<DraggableBottomSheet> {
  final layoutStatePoint = PartialStatePoint();
  final childrenStatePoint = PartialStatePoint();

  final ScrollController scrollController = ScrollController();

  late double maxLayoutHeight;
  late double maxHeight;

  late double currentHeight;
  double dTouchY = 0;
  late Duration duration;
  double opacity = 0;
  bool expanded = false;
  double sYTouch = 0;

  double contentHeight = 0;

  double shrinkHeight(double maxLayoutHeight) => min(
      widget.shrinkHeight != null
          ? widget.shrinkHeight!(maxLayoutHeight)
          : contentHeight,
      maxLayoutHeight);

  @override
  void onInit() {
    currentHeight = 0;
    duration = Duration.zero;
  }

  @override
  void onPostInit() {
    duration = widget.duration;
    currentHeight = shrinkHeight(maxLayoutHeight);
    updateState();
  }

  double dyTouch(double currentYTouch) => sYTouch - currentYTouch;

  bool canNotDraggingWithScrollController = false;

  void verticalDragStart(PointerDownEvent details) {
    if (scrollController.positions.isNotEmpty &&
        ((scrollController.offset != 0 && expanded) ||
            (scrollController.offset != 0 && !expanded))) {
      canNotDraggingWithScrollController = true;
      return;
    } else {
      canNotDraggingWithScrollController = false;
    }

    sYTouch = details.position.dy;

    widget.onDraggingStateChanged?.call(true);

    DebuggerConsole.setPinnedLine(
        "DraggableBottomSheet:START TOUCH", "START TOUCH: $sYTouch");
  }

  void verticalDragUpdate(PointerMoveEvent details) {
    if (canNotDraggingWithScrollController) {
      return;
    }

    double d = dyTouch(details.position.dy);
    DebuggerConsole.setPinnedLine(
        "DraggableBottomSheet:D TOUCH", "D TOUCH: $d");

    if (expanded) {
      currentHeight =
          max(min(maxHeight + d, maxHeight), shrinkHeight(maxLayoutHeight));
    } else {
      currentHeight = max(min(shrinkHeight(maxLayoutHeight) + d, maxHeight),
          shrinkHeight(maxLayoutHeight));
      scrollController.jumpTo(0);
    }

    // DebuggerConsole.setPinnedLine("DraggableBottomSheet:CURRENT HEIGHT","CURRENT HEIGHT: $currentHeight");
    updateState();
  }

  void verticalDragEnd(PointerUpEvent details) {
    if (canNotDraggingWithScrollController) {
      return;
    }

    if (expanded) {
      if (maxHeight - 30 > currentHeight && maxHeight > currentHeight) {
        expanded = false;
        currentHeight = shrinkHeight(maxLayoutHeight);
        updateState();
      } else {
        currentHeight = maxHeight;
        updateState();
      }
    } else {
      if (shrinkHeight(maxLayoutHeight) + 30 < currentHeight &&
          shrinkHeight(maxLayoutHeight) < currentHeight) {
        expanded = true;
        currentHeight = maxHeight;
        updateState();
      } else {
        currentHeight = shrinkHeight(maxLayoutHeight);
        updateState();
      }
    }

    widget.onDraggingStateChanged?.call(false);

    DebuggerConsole.setPinnedLine(
        "DraggableBottomSheet:EXPANDED", "EXPANDED: ${expanded.yesOrNo}");
  }

  @override
  void onStateUpdatedAfterDisposed() {
    DebuggerConsole.removePinnedLines("DraggableBottomSheet:EXPANDED");
    DebuggerConsole.removePinnedLines("DraggableBottomSheet:CURRENT HEIGHT");
    DebuggerConsole.removePinnedLines("DraggableBottomSheet:D TOUCH");
    DebuggerConsole.removePinnedLines("DraggableBottomSheet:START TOUCH");
  }
}
