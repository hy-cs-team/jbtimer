import 'package:flutter/material.dart';

class JBComponent extends StatefulWidget {
  final Widget child;
  final Color? downColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final void Function()? onTapDown;
  final void Function()? onTapUp;

  final bool hasInteraction;

  const JBComponent({
    super.key,
    required this.child,
    this.downColor,
    this.backgroundColor,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
  }) : hasInteraction = onTap != null || onTapDown != null || onTapUp != null;

  @override
  State<JBComponent> createState() => _JBComponentState();
}

class _JBComponentState extends State<JBComponent> {
  _State _state = _State.idle;

  Color get color {
    switch (_state) {
      case _State.idle:
      case _State.tap:
        return widget.backgroundColor ?? Colors.transparent;
      case _State.tapDown:
        return widget.downColor ?? Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _Content(
      color: color,
      child: widget.child,
    );

    if (!widget.hasInteraction) {
      return content;
    }

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _state = _State.tapDown;
          widget.onTapDown?.call();
        });
      },
      onTapUp: (details) {
        widget.onTapUp?.call();
      },
      onTapCancel: () {
        setState(() {
          _state = _State.idle;
        });
      },
      onTap: () {
        setState(() {
          _state = _State.tap;
        });
        widget.onTap?.call();
      },
      child: content,
    );
  }
}

class _Content extends StatelessWidget {
  final Color color;
  final Widget child;

  const _Content({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      duration: const Duration(milliseconds: 50),
      child: Center(child: child),
    );
  }
}

enum _State {
  idle,
  tapDown,
  tap,
}
