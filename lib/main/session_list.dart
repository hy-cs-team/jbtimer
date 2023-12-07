import 'package:flutter/material.dart';
import 'package:jbtimer/storage/session_list_storage.dart';

class SessionList extends StatefulWidget {
  const SessionList({super.key});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SessionListStorage.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.requireData.isEmpty) {
          return Text(
            'No saved session.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: snapshot.requireData.map((sessionIdentifier) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                sessionIdentifier.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
