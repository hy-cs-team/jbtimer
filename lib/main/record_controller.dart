import 'dart:async';

import 'package:flutter/cupertino.dart';

class RecordController extends ValueNotifier<int> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  RecordController() : super(0);

  start({void Function(int)? onValueChanged}) {
    stop();
    value = 0;
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      value = _stopwatch.elapsedMilliseconds;
      onValueChanged?.call(value);
    });
  }

  stop() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
  }

  startReverse(int milli, void Function() onDone) {
    stop();
    value = milli;
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      value = milli - _stopwatch.elapsedMilliseconds;
      if (value <= 0) {
        value = 0;
        stop();
        onDone();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
