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
        child: Text(
          sessionController.value.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SessionListDialog(
            context: context,
            sessionControllers: [sessionController],
            onSelectedSessionIndexChanged: (index) {},
          ),
        );
      },
    );
  }
}
