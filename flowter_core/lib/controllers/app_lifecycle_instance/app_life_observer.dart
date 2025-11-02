import 'package:flowter_core/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLifecycleObserver {
  static late _LifecycleObserverInstance _instance;

  static initialize() {
    _instance = _LifecycleObserverInstance();
    _instance.init();
  }

  static final Map<AppLifecycleState, Set<void Function()>> _listeners = {};

  static void addListener(AppLifecycleState state, void Function() function) {
    _listeners.addKeyWithValueIfKeyNotExists(state, {});
    _listeners[state]!.add(function);
  }

  static void removeListener(
      AppLifecycleState state, void Function() function) {
    _listeners[state]!.remove(function);
  }
}

class _LifecycleObserverInstance with WidgetsBindingObserver {
  _LifecycleObserverInstance() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleObserver._listeners.containsKey(state)) {
      for (var fun in AppLifecycleObserver._listeners[state]!) {
        try {
          fun();
        } catch (e) {
          if (kDebugMode) {
            print("Error in fun(): $e on state: $state");
          }
          Future.error(e);
        }
      }
    }

    if (state == AppLifecycleState.detached) {
      dispose();
    }
  }

  void init() {}
}
