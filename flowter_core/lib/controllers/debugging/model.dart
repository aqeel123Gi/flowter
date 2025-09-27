import 'dart:convert';

import 'package:flowter_core/functions/functions.dart';

class AppError {
  AppError({
    required this.datetime,
    required this.version,
    required this.exception,
    required this.stackTrace,
    required this.variables,
    required this.currentPage,
  });
  DateTime datetime;
  String version;
  String exception;
  String stackTrace;
  Map<dynamic, dynamic> variables;
  String currentPage;

  static AppError parseFromMemory(DateTime datetime, dynamic record) {
    return AppError(
        datetime: datetime,
        version: tryGet(() => record['version'], "Not Specified")!,
        exception: record['exception'],
        stackTrace: record['stacktrace'],
        currentPage: tryGet(() => record['currentPage'], "Not Specified")!,
        variables: tryGet(() => json.decode(record['variables']), {})!
            as Map<dynamic, dynamic>);
  }
}
