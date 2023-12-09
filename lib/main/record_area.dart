import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/extensions/format_extensions.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/record_controller.dart';
import 'package:jbtimer/main/session_controller.dart';

enum _RecordState {
  idle,
  preview,
  penalty,
  running,
  done;

  Color get backgroundColor {
    switch (this) {
      case _RecordState.idle:
      case _RecordState.done:
        return Colors.transparent;
      case _RecordState.preview:
        return Colors.green;
      case _RecordState.penalty:
        return Colors.red;
      case _RecordState.running:
        return Colors.blue;
    }
  }

  Color get downColor {
    switch (this) {
      case _RecordState.idle:
        return Colors.grey;
      case _RecordState.preview:
        return Colors.greenAccent;
      case _RecordState.penalty:
        return Colors.redAccent;
      case _RecordState.running:
        return Colors.blueAccent;
      case _RecordState.done:
        return Colors.transparent;
    }
  }
}

const _previewTimeMilli = 15000;

class RecordArea extends StatefulWidget {
  final SessionController sessionController;
  final ValueNotifier<bool> isRecordRunningNotifier;

  const RecordArea({
    super.key,
    required this.sessionController,
    required this.isRecordRunningNotifier,
  });

  @override
  State<RecordArea> createState() => _RecordAreaState();
}

class _RecordAreaState extends State<RecordArea> {
  final _recordController = RecordController();

  _RecordState _recordState = _RecordState.idle;
  int _penaltyMs = 0;

  @override
  void dispose() {
    _recordController.dispose();
    super.dispose();
  }

  void _startPreview() {
    setState(() {
      _recordState = _RecordState.preview;
    });

    widget.isRecordRunningNotifier.value = true;
    _recordController.startReverse(_previewTimeMilli, () {
      _startPenalty();
    });
  }

  void _startPenalty() {
    setState(() {
      _recordState = _RecordState.penalty;
    });

    widget.isRecordRunningNotifier.value = true;
    _recordController.start(onValueChanged: (penaltyMs) {
      _penaltyMs = penaltyMs;
    });
  }

  void _startRecord() {
    setState(() {
      _recordState = _RecordState.running;
    });

    widget.isRecordRunningNotifier.value = true;
    _recordController.start();
  }

  void _stopRecord() {
    _recordController.stop();

    widget.isRecordRunningNotifier.value = false;
    widget.sessionController.addRecord(Record(
      dateTime: DateTime.now(),
      recordMs: _recordController.value + _penaltyMs,
    ));

    setState(() {
      _recordState = _RecordState.done;
      _penaltyMs = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return JBComponent(
      interactWithSpace: true,
      downColor: _recordState.downColor,
      backgroundColor: _recordState.backgroundColor,
      onTapDown: () {
        if (_recordState == _RecordState.running) {
          _stopRecord();
        }
      },
      onTapUp: () {
        switch (_recordState) {
          case _RecordState.idle:
            _startPreview();
            break;
          case _RecordState.preview:
          case _RecordState.penalty:
            _startRecord();
            break;
          case _RecordState.running:
            // no-op
            break;
          case _RecordState.done:
            setState(() {
              _recordState = _RecordState.idle;
            });
            break;
        }
      },
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: _recordController,
          builder: (context, milli, child) => Text(
            milli.recordFormat,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
