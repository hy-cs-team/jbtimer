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

class RecordArea extends StatefulWidget {
  final SessionController sessionController;
  const RecordArea({super.key, required this.sessionController});

  @override
  State<RecordArea> createState() => _RecordAreaState();
}

class _RecordAreaState extends State<RecordArea> {
  _RecordState _recordState = _RecordState.idle;
  int _previewTime = 15;
  int _elapsedPreviewTime = 0;
  int _elapsedTime = 0;
  Timer? _previewCountDownTimer;
  Timer? _penaltyTimer;
  Timer? _recordTimer;
  DateTime _startAt = DateTime.now();

  void startPreview() {
    setState(() {
      _recordState = _RecordState.preview;
    });

    _previewCountDownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _previewTime--;
        if (_previewTime == 0) {
          startPenalty();
          timer.cancel();
        }
      });
    });
  }

  void startPenalty() {
    setState(() {
      _recordState = _RecordState.penalty;
    });

    _penaltyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedPreviewTime++;
      });
    });
  }

  void startRecord() {
    setState(() {
      _recordState = _RecordState.running;
      _startAt = DateTime.now();
    });
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
    _penaltyTimer?.cancel();
  }

  void stopRecord() {
    _recordTimer?.cancel();
    widget.sessionController.add(Record(
      dateTime: _startAt,
      recordMs: _elapsedPreviewTime + _elapsedTime,
    ));
    reset();
  }

  void reset() {
    setState(() {
      _recordState = _RecordState.idle;
      _previewTime = 15;
      _elapsedPreviewTime = 0;
      _elapsedTime = 0;
    });
    _previewCountDownTimer?.cancel();
    _penaltyTimer?.cancel();
  }

  @override
  void dispose() {
    _previewCountDownTimer?.cancel();
    _penaltyTimer?.cancel();
    super.dispose();
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
    final displayWidget = _recordState == _RecordState.preview
        ? Text(
            'Preview: $_previewTime seconds',
            style: const TextStyle(fontSize: 24),
          )
        : _recordState == _RecordState.penalty
            ? Text(
                'Penalty Time: $_elapsedPreviewTime seconds',
                style: const TextStyle(fontSize: 24),
              )
            : Text(
                'Elapsed Time: $_elapsedTime seconds',
                style: const TextStyle(fontSize: 24),
              );
    return JBComponent(
      downColor: _recordState.color,
      onPressed: onRecordAreaTapped,
      child: Center(
        child: displayWidget,
      ),
    );
  }
}
