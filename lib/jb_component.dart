import 'package:flutter/material.dart';

class JBComponent extends StatefulWidget {
  final Widget child;
  final Color? downColor;
  final void Function()? onPressed;

  const JBComponent({
    super.key,
    required this.child,
    this.downColor,
    this.onPressed,
  });

  @override
  State<JBComponent> createState() => _JBComponentState();
}

class _JBComponentState extends State<JBComponent> {
  _State _state = _State.idle;

  @override
  Widget build(BuildContext context) {
    Widget content = _Content(
      color: _state == _State.tapDown
          ? widget.downColor ?? Theme.of(context).colorScheme.surfaceTint
          : Colors.transparent,
      child: widget.child,
    );

    if (widget.onPressed == null) {
      return content;
    }

    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _state = _State.tapDown;
        });
      },
      onTapUp: (details) {
        setState(() {
          _state = _State.tap;
        });
      },
      onTap: widget.onPressed,
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
      child: child,
    );
  }
}

enum _State {
  idle,
  tapDown,
  tap,
}
