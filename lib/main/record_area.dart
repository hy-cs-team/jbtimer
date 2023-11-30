import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';

enum RecordState {
  idle,
  preview,
  penalty,
  running;

  Color get color {
    switch (this) {
      case RecordState.idle:
        return const Color(0xFF000000);
      case RecordState.preview:
        return const Color(0xFFF2F7A1);
      case RecordState.penalty:
        return const Color(0xFF6D67E4);
      case RecordState.running:
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
  RecordState _recordState = RecordState.idle;
  int _previewTime = 15;
  int _elapsedPrviewTime = 0;
  int _elapsedTime = 0;
  Timer? _previewCountDownTimer;
  Timer? _penaltyTimer;
  Timer? _recordTimer;
  DateTime _startAt = DateTime.now();

  void startPreview() {
    setState(() {
      _recordState = RecordState.preview;
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
      _recordState = RecordState.penalty;
    });

    _penaltyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedPrviewTime++;
      });
    });
  }

  void startRecord() {
    setState(() {
      _recordState = RecordState.running;
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
      recordMs: _elapsedPrviewTime + _elapsedTime,
    ));
    reset();
  }

  void reset() {
    setState(() {
      _recordState = RecordState.idle;
      _previewTime = 15;
      _elapsedPrviewTime = 0;
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
    if (_recordState == RecordState.idle) {
      startPreview();
    } else if (_recordState == RecordState.preview ||
        _recordState == RecordState.penalty) {
      startRecord();
    } else {
      stopRecord();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayWidget = _recordState == RecordState.preview
        ? Text(
            'Preview: $_previewTime seconds',
            style: const TextStyle(fontSize: 24),
          )
        : _recordState == RecordState.penalty
            ? Text(
                'Penalty Time: $_elapsedPrviewTime seconds',
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
