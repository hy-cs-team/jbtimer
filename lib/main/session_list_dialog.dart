import 'package:flutter/material.dart';
import 'package:jbtimer/main/session_controller.dart';
import 'package:jbtimer/main/session_list.dart';

class SessionListDialog extends AlertDialog {
  SessionListDialog({
    super.key,
    required BuildContext context,
    required List<SessionController> sessionControllers,
    required void Function(int) onSelectedSessionIndexChanged,
  }) : super(
          title: const Text('Select session'),
          content: const SessionList(),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Create new session',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
}
