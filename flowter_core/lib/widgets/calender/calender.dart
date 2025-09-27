import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';
import 'controller.dart';

class Calender extends StatefulWidget {
  const Calender(
      {super.key,
      required this.languageCode,
      required this.initYear,
      required this.initMonth,
      required this.selectionType,
      this.availableDateCondition,
      required this.selectedDates,
      required this.onDateSelectChanged,
      required this.previousMonthButtonIcon,
      required this.nextMonthButtonIcon,
      required this.monthShiftingIconSize,
      required this.monthShiftingIconColor,
      required this.headerTextStyle,
      required this.weekDaysTextStyle,
      required this.daysTextStyle,
      required this.daysOnSelectedTextStyle,
      required this.daysOnNotAvailableTextStyle,
      required this.daysBoxDecoration,
      required this.daysOnSelectedBoxDecoration,
      required this.weekDayText,
      required this.daysButtonForegroundColor});

  final String languageCode;
  final int initYear;
  final int initMonth;
  final SelectionType selectionType;
  final bool Function(DateTime date)? availableDateCondition;
  final Set<DateTime> selectedDates;
  final void Function(DateTime date, bool isSelected) onDateSelectChanged;

  //Style
  final TextStyle headerTextStyle;
  final TextStyle weekDaysTextStyle;
  final TextStyle daysTextStyle;
  final TextStyle daysOnSelectedTextStyle;
  final TextStyle daysOnNotAvailableTextStyle;

  final BoxDecoration daysBoxDecoration;
  final BoxDecoration daysOnSelectedBoxDecoration;

  final double monthShiftingIconSize;
  final Color monthShiftingIconColor;

  final Color daysButtonForegroundColor;

  final SDIcon previousMonthButtonIcon;
  final SDIcon nextMonthButtonIcon;

  final String Function(int weekDay) weekDayText;

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final CalenderController _controller = CalenderController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<CalenderController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {
          return UpdatingStateSwitcher(
            switchers:
                "${_controller.shownYear}-${_controller.shownMonth}-${widget.selectedDates}",
            child: Column(
              children: [
                _header,
                const Space(24),
                _weekDays,
                const Space(16),
                AnimatedTransformingSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switcher:
                        "${_controller.shownYear}-${_controller.shownMonth}",
                    builder: (context, switcherKey) =>
                        _days(_controller.shownYear, _controller.shownMonth))
              ],
            ),
          );
        });
  }

  Widget get _header => Row(children: [
        AnimatedTransformingSwitcher(
          duration: const Duration(milliseconds: 500),
          switcher: "${_controller.shownYear}-${_controller.shownMonth}",
          builder: (context, switcherKey) => Text(
              parseDateTimeToString(
                  DateTime(_controller.shownYear, _controller.shownMonth),
                  "month ، yyyy"),
              style: widget.headerTextStyle),
        ),
        const Expanded(child: SizedBox()),
        ColoredIcon(
          iconSize: widget.monthShiftingIconSize,
          color: widget.monthShiftingIconColor,
          containerSize: 30,
          icon: widget.previousMonthButtonIcon,
          onPressed: () {
            int prev = _controller.shownMonth - 1;
            if (prev < 1) {
              _controller.shownYear--;
              prev = 12;
            }
            _controller.shownMonth = prev;
            _controller.updateState();
          },
        ),
        const Space(20),
        ColoredIcon(
          iconSize: widget.monthShiftingIconSize,
          color: widget.monthShiftingIconColor,
          containerSize: 30,
          icon: widget.nextMonthButtonIcon,
          onPressed: () {
            int next = _controller.shownMonth + 1;
            if (next > 12) {
              _controller.shownYear++;
              next = 1;
            }
            _controller.shownMonth = next;
            _controller.updateState();
          },
        ),
      ]);

  Widget get _weekDays => Row(children: [
        for (var e in [7, 1, 2, 3, 4, 5, 6])
          Expanded(
            child: Text(widget.weekDayText(e),
                style: widget.weekDaysTextStyle, textAlign: TextAlign.center),
          )
      ]);

  Widget _days(int year, int month) => Builder(builder: (context) {
        List<List<Widget>> children = List.generate(
            5,
            (_) => List.generate(
                7,
                (_) => const Expanded(
                        child: SizedBox(
                      height: 30,
                      width: 30,
                    ))));

        bool startFilling = false;
        int startWeekDay = DateTime(year, month, 1).weekday;
        int d = 0;

        Widget addDay(int day) {
          bool available = widget.availableDateCondition == null ||
              widget.availableDateCondition!(DateTime(year, month, day));
          bool selected = widget.selectedDates
              .any((date) => isSameDay(date, DateTime(year, month, day)));

          return Expanded(
              child: Center(
            child: Button(
                height: 45,
                width: 45,
                contentBuilder: (context, focused) => CenterRegardlessLayout(
                      verticalShift: 4,
                      child: Text(toStringWithZerosDigits(day, 2),
                          style: selected
                              ? widget.daysOnSelectedTextStyle
                              : available
                                  ? widget.daysTextStyle
                                  : widget.daysOnNotAvailableTextStyle),
                    ),
                decoration: selected
                    ? widget.daysOnSelectedBoxDecoration
                    : widget.daysBoxDecoration,
                onPressed: available
                    ? () =>
                        _controller.onDaySelected(DateTime(year, month, day))
                    : null,
                foregroundColor: widget.daysButtonForegroundColor),
          ));
        }

        for (var r = 0; r < 5; r++) {
          for (var c = 0; c < 7; c++) {
            if (startFilling &&
                DateTime(year, month).add(Duration(days: d)).month == month) {
              d++;
              children[r][c] = addDay(d);
            } else if (c == startWeekDay % 7) {
              startFilling = true;
              d++;
              children[r][c] = addDay(d);
            }
          }
        }

        return Column(children: children.map((i) => Row(children: i)).toList());
      });
}
