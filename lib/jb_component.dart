import 'package:flutter/material.dart';

class JBComponent extends StatefulWidget {
  final Widget child;
  final Color? downColor;

  const JBComponent({super.key, required this.child, this.downColor});

  @override
  State<JBComponent> createState() => _JBComponentState();
}

class _JBComponentState extends State<JBComponent> {
  _State _state = _State.idle;

  @override
  Widget build(BuildContext context) {
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
      child: AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: _state == _State.tapDown
              ? widget.downColor ?? Theme.of(context).colorScheme.surfaceTint
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        duration: const Duration(milliseconds: 50),
        child: widget.child,
      ),
    );
  }
}

enum _State {
  idle,
  tapDown,
  tap,
}
