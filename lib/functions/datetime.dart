part of 'functions.dart';

DateTime getSundayDateTimeOfThisWeek(){
  DateTime sundayDateTimeOfThisWeek = DateTime.now();
  while(sundayDateTimeOfThisWeek.weekday!=7){
    sundayDateTimeOfThisWeek = sundayDateTimeOfThisWeek.subtract(const Duration(days: 1));
  }
  return sundayDateTimeOfThisWeek;
}

String parseDateTimeToString(DateTime datetime ,String format){

  String text = "";
  String change(text){
    switch(text){
      case 'yyyy':
        return toStringWithZerosDigits(datetime.year,4);
      case 'MM':
        return toStringWithZerosDigits(datetime.month,2);
      case 'dd':
        return toStringWithZerosDigits(datetime.day,2);
      case 'HH':
        return toStringWithZerosDigits(datetime.hour,2);
      case 'hh':
        return toStringWithZerosDigits((){
          int tmp = datetime.hour%12;
          if(tmp==0){
            return 12;
          }else{
            return tmp;
          }
        }(),2);
      case 'mm':
        return toStringWithZerosDigits(datetime.minute,2);
      case 'ss':
        return toStringWithZerosDigits(datetime.second,2);
      case 'SSS':  // milliseconds
        return toStringWithZerosDigits(datetime.millisecond, 3);
      case 'uuuuuu':  // microseconds
        return toStringWithZerosDigits(datetime.microsecond, 6);
      case 'p:ar':
        return datetime.hour<12?"ص":"م";
      case 'p:en':
        return datetime.hour<12?"AM":"PM";
      case 'wd:ar':
        return weekdayToText(datetime.weekday, LanguageCode.ar);
      case 'wd:en':
        return weekdayToText(datetime.weekday, LanguageCode.en);
      case 'month':
        return "Month.${datetime.month}".st();
    }
    return "<NF>";
  }

  format.splitMapJoin(
      RegExp(r'yyyy|MM|dd|HH|hh|mm|ss|SSS|uuuuuu|wd:ar|wd:en|p:ar|p:en|month'),
      onMatch: (match) => text+=change(match.group(0)!),
      onNonMatch: (subtext) =>text+=subtext
  );

  return text;

}


bool isSameDay(DateTime dt1, DateTime dt2)=> dt1.year==dt2.year && dt1.month==dt2.month && dt1.day==dt2.day;


Future<void> futureDelayedToDateTime(DateTime dateTime)async{
  Duration duration = dateTime.difference(DateTime.now());
  if(duration.inMilliseconds<0){
    throw Exception("DateTime you set is before now.");
  }
  await Future.delayed(duration);
}