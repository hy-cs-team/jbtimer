import 'package:flutter/material.dart';
import 'package:jbtimer/components/jb_button.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/edit_session/edit_session_page.dart';
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
            JBButton(
              child: Text(
                'Create new session',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EditSessionPage(
                      onSessionCreated: (session) => onSessionSelected(session),
                    ),
                  ),
                );
              },
            ),
          ],
        );
}
