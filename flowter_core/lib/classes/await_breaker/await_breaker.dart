import 'dart:async';
import 'package:flowter_core/classes/reference.dart';

class AwaitBreaker<T> {
  final Completer<T> _completer = Completer<T>();
  bool _isBroken = false;

  Future<T> wait({Duration? timeout, Ref<T>? defaultValueReference}) {
    if (timeout == null) {
      return _completer.future;
    }

    return _completer.future.timeout(
      timeout,
      onTimeout: () {
        if (!_completer.isCompleted) {
          _isBroken = true;
        }
        if (defaultValueReference != null) return defaultValueReference.value;
        throw TimeoutException(
            'AwaitBreaker wait timed out after $timeout, and no defaultValueReference is set.');
      },
    );
  }

  void breakWithValue(T value) {
    if (!_completer.isCompleted) {
      _isBroken = true;
      _completer.complete(value);
    }
  }

  bool get isBroken => _isBroken;
}
