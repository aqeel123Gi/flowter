import 'dart:async';

class AwaitBreaker<T> {

  final Completer<T> _completer = Completer<T>();
  bool _isBroken = false;

  Future<T> wait({Duration? timeout, T? defaultValue}) {
    if (timeout == null) {
      return _completer.future;
    }

    return _completer.future.timeout(
      timeout,
      onTimeout: () {
        if (!_completer.isCompleted) {
          _isBroken = true;
        }
        if(defaultValue != null) return defaultValue;
        throw TimeoutException('AwaitBreaker wait timed out after $timeout');
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