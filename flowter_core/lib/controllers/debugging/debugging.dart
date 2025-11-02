import 'dart:convert';
import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/functions/dynamic_clone.dart';
import 'package:flowter_core/functions/functions.dart';
import 'package:hive/hive.dart';
import '../../services/api/api.dart';
import '../app_version/app_version.dart';
import 'model.dart';

class DebuggingController {
  static final List<MapEntry<String, dynamic>> _variables = [];
  static late List<String> _keysForSensitiveData;
  static late List<AppError> _errors;
  static List<AppError> get errors => _errors.copy;

  static Future<void> initialize(
      {required List<String> keysForSensitiveData}) async {
    _keysForSensitiveData = keysForSensitiveData;
    Box errorsBox = await Hive.openBox("errors");
    _errors = [];
    for (String key in errorsBox.keys) {
      _errors.add(
          AppError.parseFromMemory(DateTime.parse(key), errorsBox.get(key)));
    }
  }

  static void addVariable(String id, dynamic data,
      [Duration durationToRemove = const Duration(minutes: 1)]) async {
    dynamic newData = dynamicClone(data);
    replaceValueForKey(
        newData,
        _keysForSensitiveData.toMap(
            keyFrom: (_, e) => e, valueFrom: (_, e) => "<SensitiveData>"));

    MapEntry<String, dynamic> variable = MapEntry<String, dynamic>(id, newData);

    _variables.add(variable);

    Future.delayed(durationToRemove, () {
      _variables.remove(variable);
    });

    par("${(_parseVariablesToJsonString().length / 1024).toStringAsFixed(2)} KB",
        "Current Debugging Variables' size");
  }

  static Future<void> addError(
      {required Object exception,
      required StackTrace stackTrace,
      required String currentPage,
      required List<String> filterErrorsOnSubtexts,
      required void Function(AppError error)? onNewTodayError}) async {
    if (filterErrorsOnSubtexts
            .any((element) => exception.toString().contains(element)) ||
        filterErrorsOnSubtexts
            .any((element) => stackTrace.toString().contains(element))) {
      return;
    }

    DateTime now = DateTime.now();

    for (AppError error in _errors) {
      if (isSameDay(error.datetime, now) &&
          stackTrace.toString() == error.stackTrace) {
        return;
      }
    }

    Box errorsBox = await Hive.openBox("errors");
    errorsBox.put(now.toString(), {
      'currentPage': currentPage,
      'version': AppInfo.version,
      'exception': exception.toString(),
      'stacktrace': stackTrace.toString(),
      'variables': _parseVariablesToJsonString(),
    });

    AppError error = AppError(
        datetime: now,
        currentPage: currentPage,
        version: AppInfo.version,
        exception: exception.toString(),
        stackTrace: stackTrace.toString(),
        variables: {}..addEntries(_variables));

    _errors.add(error);
    if (onNewTodayError != null) {
      onNewTodayError(error);
    }
  }

  static Future<void> clear() async {
    _errors = [];
    await (await Hive.openBox("errors")).clear();
  }

  static String _parseVariablesToJsonString() {
    for (var element in _variables) {
      json.encode(element.value);
    }
    return json.encode({}..addEntries(_variables));
  }
}
