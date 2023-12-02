import 'package:flutter/material.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';

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
          builder: (context) => AlertDialog(
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
          ),
        );
      },
    );
  }
}
