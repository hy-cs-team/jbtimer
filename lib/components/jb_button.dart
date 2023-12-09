import 'package:flutter/material.dart';

class JBButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const JBButton({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: child,
    );
  }
}
