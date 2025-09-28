import 'package:flowter_core/flowter_core.dart';
import 'package:flowter_core/widgets/public_listener/public_listener.dart';
import 'package:flutter/gestures.dart';

class SleepingChecker {
  bool _run = false;
  bool _pause = false;

  DateTime _lastActivity = DateTime.now();
  Duration _afterLastActivity = Duration.zero;

  Future<void> run(
      {required Duration duration,
      required void Function() onSleep,
      bool Function()? ignore}) async {
    if (_run == true) {
      throw Exception("Sleeping Checker is Running.");
    }
    _run = true;
    _lastActivity = DateTime.now();
    _afterLastActivity = duration;
    while (_run) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_pause && (ignore == null || !ignore())) {
        _updateLastActivity();
        if (DateTime.now().difference(_lastActivity) >= _afterLastActivity) {
          onSleep();
          pause();
        }
      }
    }
  }

  void changeDuration(Duration duration) {
    _afterLastActivity = duration;
  }

  void pause() {
    _pause = true;
  }

  void resume() {
    _lastActivity = DateTime.now();
    _pause = false;
  }

  void stop() {
    _run = false;
  }

  PointerDownEvent? _lastPointerDownEvent;
  PointerMoveEvent? _lastPointerMoveEvent;
  PointerHoverEvent? _lastPointerHoverEvent;
  _updateLastActivity() {
    if (_lastPointerMoveEvent != PublicListener.pointerMoveEvent ||
        _lastPointerDownEvent != PublicListener.pointerDownEvent ||
        _lastPointerHoverEvent != PublicListener.pointerHoverEvent) {
      _lastActivity = DateTime.now();
    }
    _lastPointerDownEvent = PublicListener.pointerDownEvent;
    _lastPointerMoveEvent = PublicListener.pointerMoveEvent;
    _lastPointerHoverEvent = PublicListener.pointerHoverEvent;
  }
}
