import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JBComponent extends StatefulWidget {
  final Widget child;
  final Color? downColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final void Function()? onTapDown;
  final void Function()? onTapUp;
  final bool interactWithSpace;

  final bool hasInteraction;

  const JBComponent({
    super.key,
    required this.child,
    this.downColor,
    this.backgroundColor,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.interactWithSpace = false,
  }) : hasInteraction = onTap != null || onTapDown != null || onTapUp != null;

  @override
  State<JBComponent> createState() => _JBComponentState();
}

class _JBComponentState extends State<JBComponent> {
  _State _state = _State.idle;
  final FocusNode _focusNode = FocusNode();

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
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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

    final component = GestureDetector(
      onTapDown: (details) => _down(),
      onTapUp: (details) => _up(),
      onTapCancel: () => _cancel(),
      onTap: () => _tap(),
      child: content,
    );

    if (!widget.interactWithSpace) {
      return component;
    }

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.logicalKey != LogicalKeyboardKey.space) {
          return;
        }

        if (event is RawKeyDownEvent) {
          _down();
        } else if (event is RawKeyUpEvent) {
          _up();
          _tap();
        }
      },
      child: component,
    );
  }

  _down() {
    setState(() {
      _state = _State.tapDown;
    });
    widget.onTapDown?.call();
  }

  _up() {
    widget.onTapUp?.call();
  }

  _cancel() {
    setState(() {
      _state = _State.idle;
    });
  }

  _tap() {
    setState(() {
      _state = _State.tap;
    });
    widget.onTap?.call();
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
