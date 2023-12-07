import 'package:flutter/material.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/main/session_list.dart';

class SessionListDialog extends AlertDialog {
  SessionListDialog({
    super.key,
    required BuildContext context,
    required void Function(Session) onSessionSelected,
  }) : super(
          title: const Text('Select session'),
          content: SessionList(onSessionSelected: onSessionSelected),
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
