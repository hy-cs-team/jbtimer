import 'package:flutter/material.dart';
import 'package:jbtimer/main/session_controller.dart';

class SessionListDialog extends AlertDialog {
  SessionListDialog({
    super.key,
    required BuildContext context,
    required List<SessionController> sessionControllers,
    required void Function(int) onSelectedSessionIndexChanged,
  }) : super(
          title: const Text('Select session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: sessionControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final sessionController = entry.value;
              return TextButton(
                onPressed: () {
                  onSelectedSessionIndexChanged(index);
                  Navigator.of(context).pop();
                },
                child: Text(
                  sessionController.value.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
          ),
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
