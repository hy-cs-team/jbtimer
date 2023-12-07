import 'package:flutter/material.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';
import 'package:jbtimer/main/session_list_dialog.dart';

class SessionButton extends StatelessWidget {
  final SessionController sessionController;

  const SessionButton({
    super.key,
    required this.sessionController,
  });

  @override
  Widget build(BuildContext context) {
    return JBComponent(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: sessionController,
          builder: (context, session, child) => Text(
            session.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SessionListDialog(
            context: context,
            onSessionSelected: (session) {
              sessionController.select(session);
            },
          ),
        );
      },
    );
  }
}
