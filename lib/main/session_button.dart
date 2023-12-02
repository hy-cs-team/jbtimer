import 'package:flutter/material.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';
import 'package:jbtimer/main/session_list_dialog.dart';

class SessionButton extends StatelessWidget {
  final List<SessionController> sessionControllers;
  final int selectedSessionIndex;
  final void Function(int) onSelectedSessionIndexChanged;

  const SessionButton({
    super.key,
    required this.sessionControllers,
    required this.selectedSessionIndex,
    required this.onSelectedSessionIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return JBComponent(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          sessionControllers[selectedSessionIndex].value.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SessionListDialog(
            context: context,
            sessionControllers: sessionControllers,
            onSelectedSessionIndexChanged: onSelectedSessionIndexChanged,
          ),
        );
      },
    );
  }
}
