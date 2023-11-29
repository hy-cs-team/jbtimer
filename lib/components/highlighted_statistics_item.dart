import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jbtimer/components/statistics_item.dart';

class HighlightedStatisticsItem extends StatefulWidget {
  final Color recordHighlightColor;
  final String name;
  final int? record;
  final double? standardDeviation;

  const HighlightedStatisticsItem({
    super.key,
    required this.recordHighlightColor,
    required this.name,
    this.record,
    this.standardDeviation,
  });

  @override
  State<HighlightedStatisticsItem> createState() =>
      _HighlightedStatisticsItemState();
}

class _HighlightedStatisticsItemState extends State<HighlightedStatisticsItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Color?>? _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _colorAnimation = ColorTween(
        begin: widget.recordHighlightColor,
        end: Theme.of(context).colorScheme.onSurface,
      ).animate(_controller)
        ..addListener(() => setState(() {}));
      _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant HighlightedStatisticsItem oldWidget) {
    if (oldWidget.record != widget.record) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatisticsItem(
      name: widget.name,
      record: widget.record,
      standardDeviation: widget.standardDeviation,
      recordColor: _colorAnimation?.value,
    );
  }
}
