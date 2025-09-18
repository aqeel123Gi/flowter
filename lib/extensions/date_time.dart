part of 'extensions.dart';

extension DateTimeFunctions on DateTime{
  DateTime get zeroTime => DateTime(year,month,day,0,0,0,0,0);

  bool get isToday => year == DateTime.now().year && month == DateTime.now().month && day == DateTime.now().day;


  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  DateTime get firstDayOfNextMonth{
    int year = this.year;
    int month = this.month;
    if(month == 12){
      year += 1;
      month = 1;
    }else{
      month += 1;
    }
   return DateTime(year,month,1);
  }



  DateTime get firstDayOfPreviousMonth{
    int year = this.year;
    int month = this.month;
    if(month == 1){
      year -= 1;
      month = 12;
    }else{
      month -= 1;
    }
    return DateTime(year,month,1);
  }





  DateTime get firstDayOfMonth => DateTime(year,month,1);

  DateTime get lastDayOfMonth => DateTime(year,month+1,0);



  DateTime? getNearestPreviousDateTime(Iterable<DateTime> dates){

    DateTime? nearest;

    for(DateTime date in dates){
      if((nearest == null && isBefore(date)) || (nearest != null && nearest.isAfter(date))){
        nearest = date;
      }
    }

    return nearest;
  }




  DateTime? getNearestNextDateTime(Iterable<DateTime> dates){

    DateTime? nearest;

    for(DateTime date in dates){
      if((nearest == null && isAfter(date)) || (nearest != null && nearest.isBefore(date))){
        nearest = date;
      }
    }

    return nearest;
  }

  operator -(Duration duration) => subtract(duration);
  operator +(Duration duration) => add(duration);

  operator >(DateTime other) => isAfter(other);
  operator <(DateTime other) => isBefore(other);

  operator >=(DateTime other) => isAfter(other) || compareTo(other) == 0;
  operator <=(DateTime other) => isBefore(other) || compareTo(other) == 0;

}


class DateTimeExtension{


  static DateTime parseFromString(String dateTimeText, String dateTimeFormat) {

    int? year;
    int? month;
    int? day;
    int? hour;
    int? minute;
    int? second;
    int? millisecond;
    int? microsecond;

    void set(String text,String format){
      switch(format){
        case 'yyyy':
          year = int.parse(text);
          break;
        case 'MM':
          month = int.parse(text);
          break;
        case 'dd':
          day = int.parse(text);
          break;
        case 'HH':
          hour = int.parse(text);
          break;
        case 'mm':
          minute = int.parse(text);
          break;
        case 'ss':
          second = int.parse(text);
          break;
        case 'SSS':  // milliseconds
          millisecond = int.parse(text);
          break;
        case 'uuuuuu':  // microseconds
          microsecond = int.parse(text);
          break;
      }
    }

    dateTimeFormat.splitMapJoin(
      RegExp(r'yyyy|MM|dd|HH|hh|mm|ss|wd:ar|wd:en|p:ar|p:en|month'),
      onMatch: (match) {


        set(dateTimeText.substring(match.start,match.end),match.group(0)!);
        return "";
      },
    );

    if(year == null || month == null || day == null){
      throw Exception("Invalid date time format");
    }

    return DateTime(year!,month!,day!,hour??0,minute??0,second??0,millisecond??0,microsecond??0);


  }






}



