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
        return const Color(0xFF6D67E4);
      case _RecordState.running:
        return const Color(0xFF453C67);
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
  final _stopwatchStreamController = StreamController<int>();

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
      _stopwatchStreamController.sink.add(leftPreviewTime.inMilliseconds);
    });
  }

  void startRecord() {
    _stopwatch.stop();
    _timer.cancel();
    setState(() {
      _previewTime = _stopwatch.elapsed.inMilliseconds > _previewTimeMilli
          ? _stopwatch.elapsed.inMilliseconds - _previewTimeMilli
          : 0;
      _recordState = _RecordState.running;
    });
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      _stopwatchStreamController.sink.add(_stopwatch.elapsed.inMilliseconds);
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
      child: StreamBuilder<int>(
        stream: _stopwatchStreamController.stream,
        builder: (context, snapshot) {
          final isOverPreviewTime = _recordState == _RecordState.preview &&
              _stopwatch.elapsed.inMilliseconds > _previewTimeMilli;
          final backgroundColor =
              isOverPreviewTime ? Colors.red.shade900 : _recordState.color;
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Center(
              child: Text(
                snapshot.data != null
                    ? snapshot.data!.recordFormat.toString()
                    : _previewTimeMilli.recordFormat,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}
