import 'package:framework/framework.dart';



String weekdayToText(int weekday,dynamic languageCode){
  if(languageCode == LanguageCode.ar || languageCode == "ar") {
    switch(weekday){
      case 7:
        return 'الأحد';
      case 1:
        return "الأثنين";
      case 2:
        return "الثلاثاء";
      case 3:
        return "الأربعاء";
      case 4:
        return "الخميس";
      case 5:
        return "الجمعة";
      case 6:
        return "السبت";
    }
  }else{
    switch(weekday){
      case 7:
        return "sunday";
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thursday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
    }
  }
  return "<?>";
}



String fromWeekDayToString(WeekDay weekday,LanguageCode languageCode){
  if(languageCode == LanguageCode.ar) {
    switch(weekday){
      case WeekDay.sunday:
        return 'الأحد';
      case WeekDay.monday:
        return "الأثنين";
      case WeekDay.tuesday:
        return "الثلاثاء";
      case WeekDay.wednesday:
        return "الأربعاء";
      case WeekDay.thursday:
        return "الخميس";
      case WeekDay.friday:
        return "الجمعة";
      case WeekDay.saturday:
        return "السبت";
    }
  }else{
    return weekday.name;
  }
}


String fromWeekDayToStringX(WeekDay weekday,String languageCode){
  if(languageCode == 'ar') {
    switch(weekday){
      case WeekDay.sunday:
        return 'الأحد';
      case WeekDay.monday:
        return "الأثنين";
      case WeekDay.tuesday:
        return "الثلاثاء";
      case WeekDay.wednesday:
        return "الأربعاء";
      case WeekDay.thursday:
        return "الخميس";
      case WeekDay.friday:
        return "الجمعة";
      case WeekDay.saturday:
        return "السبت";
    }
  }else{
    return weekday.name;
  }
}




WeekDay parseWeekDay(dynamic weekday){
  if(weekday is int){
    return {
      7:WeekDay.sunday,
      1:WeekDay.monday,
      2:WeekDay.tuesday,
      3:WeekDay.wednesday,
      4:WeekDay.thursday,
      5:WeekDay.friday,
      6:WeekDay.saturday
    }
    [weekday]!;
  }

  else if (weekday is String){
    return {
      "sunday":WeekDay.sunday,
      "monday":WeekDay.monday,
      "tuesday":WeekDay.tuesday,
      "wednesday":WeekDay.wednesday,
      "thursday":WeekDay.thursday,
      "friday":WeekDay.friday,
      "saturday":WeekDay.saturday
    }
    [weekday.toLowerCase()]!;
  }

  throw Exception("Not implemented for $weekday");
}


int fromWeekDayToIndex(WeekDay weekday, [WeekDay startDay = WeekDay.sunday]) {
  int index = (weekday.index - startDay.index) % 7;
  return index;
}


WeekDay fromIndexToWeekDay(int index, [WeekDay startDay = WeekDay.sunday]) {
  int finalIndex = (startDay.index + index) % 7;
  return WeekDay.values[finalIndex];
}

