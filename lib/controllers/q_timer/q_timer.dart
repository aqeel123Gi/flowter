import 'dart:developer';

class QTimer {
  static final Map<dynamic, DateTime> _points = {};

  /// Adds a time point or calculates the duration between two points
  static void point(key) {
    final now = DateTime.now();

    if (_points.containsKey(key)) {
      final duration = now.difference(_points[key]!);
      log('Duration for "$key": ${duration.inMilliseconds} ms');
      _points.remove(key); // Remove the point after calculating the duration
    } else {
      _points[key] = now;
      log('Point "$key" recorded at $now');
    }
  }
}