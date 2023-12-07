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
  running;

  Color get color {
    switch (this) {
      case _RecordState.idle:
        return Colors.transparent;
      case _RecordState.preview:
        return const Color(0xFF6D67E4);
      case _RecordState.penalty:
        return Colors.red;
      case _RecordState.running:
        return const Color(0xFF453C67);
      default:
        return Colors.transparent;
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

    _recordController.startReverse(_previewTimeMilli, () {
      _startPenalty();
    });
  }

  void _startPenalty() {
    setState(() {
      _recordState = _RecordState.penalty;
    });

    _recordController.start(onValueChanged: (penaltyMs) {
      _penaltyMs = penaltyMs;
    });
  }

  void _startRecord() {
    setState(() {
      _recordState = _RecordState.running;
    });

    _recordController.start();
  }

  void _stopRecord() {
    _recordController.stop();

    widget.sessionController.add(Record(
      dateTime: DateTime.now(),
      recordMs: _recordController.value + _penaltyMs,
    ));

    _reset();
  }

  void _reset() {
    setState(() {
      _recordState = _RecordState.idle;
      _penaltyMs = 0;
    });
  }

  void _onRecordAreaTapped() {
    switch (_recordState) {
      case _RecordState.idle:
        _startPreview();
        break;
      case _RecordState.preview:
      case _RecordState.penalty:
        _startRecord();
        break;
      case _RecordState.running:
        _stopRecord();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return JBComponent(
      downColor: _recordState.color,
      onPressed: _onRecordAreaTapped,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: _recordState.color,
        ),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: _recordController,
            builder: (context, milli, child) => Text(
              milli.recordFormat,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
