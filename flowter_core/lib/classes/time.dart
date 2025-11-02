import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/functions/functions.dart';
import '../controllers/dictionary/dictionary.dart';

class Time implements Comparable<Time> {
  Time([this.hour = 0, this.minute = 0, this.second = 0]);

  int hour;
  int minute;
  int second;

  static Time get zero {
    return Time(0, 0, 0);
  }

  @override
  String toString({format12h = true, withSeconds = true}) {
    if (format12h) {
      String period = '57'.st();
      int hour_ = hour;
      if (hour > 12) {
        period = '58'.st();
        hour_ -= 12;
      }
      if (hour_ == 12) {
        period = '58'.st();
      }
      if (hour_ == 0) {
        period = '57'.st();
        hour_ = 12;
      }
      return "${_fixed2Digits(hour_)}:${_fixed2Digits(minute)}${withSeconds ? ":${_fixed2Digits(second)}" : ""} ${period.toUpperCase()}";
    }
    return "${_fixed2Digits(hour)}:${_fixed2Digits(minute)}${withSeconds ? ":${_fixed2Digits(second)}" : ""}";
  }

  @override
  int compareTo(Time other) {
    if (hour != other.hour) {
      return hour.compareTo(other.hour);
    } else if (minute != other.minute) {
      return minute.compareTo(other.minute);
    } else {
      return second.compareTo(other.second);
    }
  }

  Time add(int hours, int minutes, int seconds) {
    Time tmp = Time(hour + hours, minute + minutes, second + seconds);

    //On Addition
    if (tmp.second >= 60) {
      tmp.second -= 60;
      tmp.minute++;
    }
    if (tmp.minute >= 60) {
      tmp.minute -= 60;
      tmp.hour++;
    }
    if (tmp.hour >= 24) {
      tmp.hour -= 24;
    }

    //On Subtraction
    if (tmp.second < 0) {
      tmp.second += 60;
      tmp.minute--;
    }
    if (tmp.minute < 0) {
      tmp.minute += 60;
      tmp.hour--;
    }
    if (tmp.hour < 0) {
      tmp.hour += 24;
    }

    return tmp;
  }

  String _fixed2Digits(int number) {
    return number >= 10 ? number.toString() : "0$number";
  }

  // static Time parse(String time){
  //   List<String> list = time.split(":");
  //   return Time(
  //     int.parse(list[0]),
  //     int.parse(list[1]),
  //     tryGet(()=>int.parse(list[2]),0)!);
  // }

  static Time parse(String time, {bool format12h = false}) {
    int hour = 0, minute = 0, second = 0;

    if (format12h) {
      List<String> list = time.split(" ");
      String splitTime = list[0];
      String period = list[1];

      List<String> timeList = splitTime.split(":");
      if (timeList.length == 3) {
        hour = int.parse(timeList[0]);
        minute = int.parse(timeList[1]);
        second = int.parse(timeList[2]);
      } else if (timeList.length == 2) {
        hour = int.parse(timeList[0]);
        minute = int.parse(timeList[1]);
      } else if (timeList.length == 1) {
        hour = int.parse(timeList[0]);
      }

      if (period == 'am' && hour == 12) {
        hour = 0;
      } else if (period == 'pm' && hour != 12) {
        hour += 12;
      }
    } else {
      List<String> timeList = time.split(":");
      if (timeList.length == 3) {
        hour = int.parse(timeList[0]);
        minute = int.parse(timeList[1]);
        second = int.parse(timeList[2]);
      } else if (timeList.length == 2) {
        hour = int.parse(timeList[0]);
        minute = int.parse(timeList[1]);
      } else if (timeList.length == 1) {
        hour = int.parse(timeList[0]);
      }
    }

    return Time(hour, minute, second);
  }

  static Time? tryParse(String? time, {bool format12h = false}) {
    if (time == null) {
      return null;
    }
    return tryGet(() => parse(time, format12h: format12h));
  }

  static Time now() {
    DateTime now = DateTime.now();
    return Time(now.hour, now.minute, now.second);
  }

  static Time parseFromDateTime(DateTime datetime) {
    return Time(datetime.hour, datetime.minute, datetime.second);
  }

  bool equals(Time time) {
    if (hour == time.hour && minute == time.minute && second == time.second) {
      return true;
    }
    return false;
  }

  int differenceInSeconds(Time time) {
    return ((hour - time.hour) * 3600) +
        ((minute - time.minute) * 60) +
        (second - time.second);
  }

  toJson() {
    return toString(format12h: false);
  }

  static Future<void> executeDaily(
      {required Time time,
      required bool Function() stopOn,
      required void Function() process}) async {
    while (!stopOn()) {
      await futureDelayedToDateTime(time.getNextDateTime());
      if (!stopOn()) {
        process();
      }
    }
  }

  DateTime getNextDateTime() {
    Time now = Time.now();
    DateTime nextDateTime = DateTime.now().zeroTime;
    nextDateTime = nextDateTime
        .add(Duration(hours: hour, minutes: minute, seconds: second));
    if (now.differenceInSeconds(this) >= 0) {
      nextDateTime = nextDateTime.add(const Duration(days: 1));
    }
    return nextDateTime;
  }

  void subtractFromMinutes(int minutesToSubtract) {
    int totalMinutes = (hour * 60) + minute - minutesToSubtract;
    if (totalMinutes < 0) {
      totalMinutes = 1440 + (totalMinutes % 1440);
    }
    hour = (totalMinutes ~/ 60) % 24;
    minute = totalMinutes % 60;
  }

  bool isBefore(Time other) {
    return hour < other.hour ||
        (hour == other.hour && minute < other.minute) ||
        (hour == other.hour && minute == other.minute && second < other.second);
  }

  bool isAfter(Time other) {
    return hour > other.hour ||
        (hour == other.hour && minute > other.minute) ||
        (hour == other.hour && minute == other.minute && second > other.second);
  }

  Time get copy {
    return Time(hour, minute, second);
  }

  bool get isAM {
    return hour < 12;
  }

  bool get isPM {
    return hour >= 12;
  }

  int get totalSeconds => hour * 3600 + minute * 60 + second;

  Time? nextNearestTime(Iterable<Time> times) {
    final currentSeconds = hour * 3600 + minute * 60 + second;

    return times
        .where((time) => time.totalSeconds > currentSeconds)
        .reduce((a, b) => a.totalSeconds < b.totalSeconds ? a : b);
  }

  Duration difference(Time time) {
    return Duration(
        hours: hour - time.hour,
        minutes: minute - time.minute,
        seconds: second - time.second);
  }
}
