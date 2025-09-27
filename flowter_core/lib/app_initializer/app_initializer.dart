library app_initializer;

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flowter_core/controllers/auth/auth.dart';
import 'package:flowter_core/controllers/brightness_mode/brightness_mode.dart';
import 'package:flowter_core/controllers/dev_stage/dev_stage.dart';
import 'package:flowter_core/controllers/dictionary/dictionary.dart';
import 'package:flowter_core/flowter_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import '../controllers/analytics/analytics.dart';
import '../controllers/app_lifecycle_instance/app_life_observer.dart';
import '../controllers/logs/logs.dart';
import '../controllers/ui_key/ui_key.dart';
import '../services/api/api.dart';
import '../services/notifications/notifications.dart';
import '../widgets/auto_scale.dart';
import '../widgets/no_scroller/no_scroller.dart';

part '_environment.dart';
part '_app_init.dart';
part '_logs.dart';
part '_base_widget.dart';

/// AppFramework is the main entry point for the app by use of [AppFramework.appInitializer] function,
/// which uses a group of basic internal [made by AQeeL] & external libraries of the framework to use
/// in the app instead of implementing them manually one-by-one with use an object of [AppCustomization]
/// to ease the process. This with [onAppStartInitializing] and [onAppInitialized] args to customize your
/// needs of the app.
///
///
///
/// Some internal Libraries initialized or used, you can go to their documentations to know more about
/// them:
/// - [AdvancedTextField]
/// - [API]
/// - [AppLifecycleObserver]
/// - [AuthController]
/// - [BrightnessController]
/// - [DictionaryController]
/// - [DevStageController]
/// - [Logs]
/// - [RunOnce]
/// - [TemplateController]
///
///
///
/// Widgets applied on the base of App, you can go to their documentations to know more about them:
/// - [DebuggerConsole]
/// - [PreferredScreen]
/// - [PublicListener]
/// - [Scaling]
///
///
///
class AppFramework {
  static late AppCustomization appCustomization;

  static void appInitializer({
    required AppCustomization customization,
    Future<void> Function(AppCustomization environment)? onAppStartInitializing,
    Future<void> Function(AppCustomization environment)? onAppInitialized,
  }) async {
    runZonedGuarded(() async {
      appCustomization = customization;

      await onAppStartInitializing?.call(customization);

      await appInit(customization);

      await onAppInitialized?.call(customization);

      runApp(AppBaseWidget(appCustomization: appCustomization));
    }, (Object e, StackTrace s) {
      if (customization.onErrorThrown != null) {
        customization.onErrorThrown!(e, s);
      }
    });
  }
}
