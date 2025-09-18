import 'package:framework/framework.dart';


class CalenderController extends WidgetController<Calender>{



  late int shownYear;
  late int shownMonth;



  @override
  void onInit() {
    shownYear = widget.initYear;
    shownMonth = widget.initMonth;
  }



  void onDaySelected(DateTime selectedDay){

    if(widget.selectionType == SelectionType.none){
      return;
    }

    if(widget.selectionType == SelectionType.single){
      widget.selectedDates
          ..clear()
          ..add(selectedDay);

      widget.onDateSelectChanged(selectedDay,true);
      updateState();
    }

    if(widget.selectionType == SelectionType.multiple){
      bool added = widget.selectedDates.addOrRemove(selectedDay);
      widget.onDateSelectChanged(selectedDay,added);
      updateState();
    }

  }

}