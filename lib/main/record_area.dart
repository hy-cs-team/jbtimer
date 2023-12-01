import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/extensions/format_extensions.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';

enum _RecordState {
  idle,
  preview,
  running;

  Color get color {
    switch (this) {
      case _RecordState.idle:
        return const Color(0xFF000000);
      case _RecordState.preview:
        return const Color(0xFFF2F7A1);
      case _RecordState.running:
        return const Color(0xFF46C2CB);
      default:
        return const Color(0xFF000000);
    }
  }
}

const _previewTimeMilli = 15000;

class RecordArea extends StatefulWidget {
  final SessionController sessionController;
  const RecordArea({super.key, required this.sessionController});

  @override
  State<RecordArea> createState() => _RecordAreaState();
}

class _RecordAreaState extends State<RecordArea> {
  _RecordState _recordState = _RecordState.idle;
  int _previewTime = 0;
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  final _stopwatchStreamController = StreamController<String>();

  @override
  void dispose() {
    _timer.cancel();
    _stopwatchStreamController.close();
    super.dispose();
  }

  void startPreview() {
    setState(() {
      _recordState = _RecordState.preview;
    });
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      final leftPreviewTime = Duration(
        milliseconds: _stopwatch.elapsed.inMilliseconds < _previewTimeMilli
            ? _previewTimeMilli - _stopwatch.elapsed.inMilliseconds
            : _stopwatch.elapsed.inMilliseconds - _previewTimeMilli,
      );
      final leftPreviewTimeString = leftPreviewTime.inMilliseconds.recordFormat;
      _stopwatchStreamController.sink.add(leftPreviewTimeString);
    });
  }

  void startRecord() {
    _stopwatch.stop();
    _timer.cancel();
    setState(() {
      _previewTime = _stopwatch.elapsed.inMilliseconds;
      _recordState = _RecordState.running;
    });
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      final runningTimeString = _stopwatch.elapsed.inMilliseconds.recordFormat;
      _stopwatchStreamController.sink.add(runningTimeString);
    });
  }

  void stopRecord() {
    _stopwatch.stop();
    _timer.cancel();
    widget.sessionController.add(Record(
      dateTime: DateTime.now(),
      recordMs: _previewTime + _stopwatch.elapsed.inMilliseconds,
    ));
    reset();
  }

  void reset() {
    _stopwatch.reset();
    setState(() {
      _recordState = _RecordState.idle;
    });
  }

  void onRecordAreaTapped() {
    switch (_recordState) {
      case _RecordState.idle:
        startPreview();
        break;
      case _RecordState.preview:
        startRecord();
        break;
      case _RecordState.running:
        stopRecord();
        break;
      default:
        stopRecord();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return JBComponent(
      downColor: _recordState.color,
      onPressed: onRecordAreaTapped,
      child: StreamBuilder<String>(
        stream: _stopwatchStreamController.stream,
        builder: (context, snapshot) {
          Color startColor, endColor;
          int elapsedTime, totalDuration;

          if (_recordState == _RecordState.preview) {
            startColor = Colors.red.shade300;
            endColor = Colors.red.shade800;
            elapsedTime = _stopwatch.elapsed.inMilliseconds;
            totalDuration = _previewTimeMilli;
          } else if (_recordState == _RecordState.running) {
            startColor = Colors.purple.shade300;
            endColor = Colors.purple.shade900;
            elapsedTime = _stopwatch.elapsed.inMilliseconds;
            totalDuration = 60000;
          } else {
            startColor = endColor = _recordState.color;
            elapsedTime = totalDuration = 1;
          }

          double progress = elapsedTime / totalDuration;
          Color animatedColor =
              Color.lerp(startColor, endColor, progress.clamp(0.0, 1.0)) ??
                  Colors.transparent;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: animatedColor,
            ),
            child: Center(
              child: Text(
                snapshot.data ?? _previewTimeMilli.recordFormat,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}
