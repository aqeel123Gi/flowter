import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  @override
  createState() => _DatePickerState();
  final DateTime initDay;
  final DateTime? minDate;
  final Function(DateTime day) onConfirm;
  const DatePicker({
    super.key,
    required this.onConfirm, required this.initDay, this.minDate
  });
}

class _DatePickerState extends State<DatePicker> {

  @override
  Widget build(BuildContext context) {
    return Center(child:Container(
      padding: const EdgeInsets.all(10),

        clipBehavior: Clip.antiAlias,
        height: 400,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              blurRadius: 7,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const SizedBox()

      //   SfDateRangePicker(
      //     minDate: widget.minDate,
      //     onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
      //       widget.onConfirm(args.value);
      //       Navigator.pop(context);
      //     },
      //     initialSelectedDate: widget.initDay,
      // )
    ));
  }
}