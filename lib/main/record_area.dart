import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';

enum _RecordState {
  idle,
  preview,
  penalty,
  running;

  Color get color {
    switch (this) {
      case _RecordState.idle:
        return const Color(0xFF000000);
      case _RecordState.preview:
        return const Color(0xFFF2F7A1);
      case _RecordState.penalty:
        return const Color(0xFF6D67E4);
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
  DateTime _startAt = DateTime.now();
  final Stopwatch _previewStopwatch = Stopwatch();
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  final _stopwatchStreamController = StreamController<String>();

  String _formatElapsedTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    final twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    final threeDigitMilliseconds =
        threeDigits(d.inMilliseconds.remainder(1000));
    return "$twoDigitMinutes:$twoDigitSeconds.$threeDigitMilliseconds";
  }

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
    _previewStopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      final leftPreviewTime = Duration(
        milliseconds:
            _previewStopwatch.elapsed.inMilliseconds < _previewTimeMilli
                ? _previewTimeMilli - _previewStopwatch.elapsed.inMilliseconds
                : _previewStopwatch.elapsed.inMilliseconds - _previewTimeMilli,
      );
      final leftPreviewTimeString = _formatElapsedTime(leftPreviewTime);
      _stopwatchStreamController.sink.add(leftPreviewTimeString);
    });
  }

  void startRecord() {
    _previewStopwatch.stop();
    _timer.cancel();
    setState(() {
      _recordState = _RecordState.running;
      _startAt = DateTime.now();
    });

    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      final runningTimeString = _formatElapsedTime(_stopwatch.elapsed);
      _stopwatchStreamController.sink.add(runningTimeString);
    });
  }

  void stopRecord() {
    _stopwatch.stop();
    _timer.cancel();
    final previewTime = _previewStopwatch.elapsed.inMilliseconds < 15000
        ? 0
        : _previewStopwatch.elapsed.inMilliseconds - 15000;
    widget.sessionController.add(Record(
      dateTime: _startAt,
      recordMs: previewTime + _stopwatch.elapsed.inMilliseconds,
    ));
    reset();
  }

  void reset() {
    _previewStopwatch.reset();
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
      case _RecordState.penalty:
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
          final isOverPreviewTime = _recordState == _RecordState.preview &&
              _previewStopwatch.elapsed.inMilliseconds > _previewTimeMilli;
          final timerTextStyle = TextStyle(
            fontSize: 24,
            color: isOverPreviewTime ? Colors.red : Colors.white,
          );
          return Center(
            child: Text(
              snapshot.data ?? '00:15.000',
              style: timerTextStyle,
            ),
          );
        },
      ),
    );
  }
}
