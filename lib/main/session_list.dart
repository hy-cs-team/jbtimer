import 'package:flutter/material.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/storage/session_list_storage.dart';
import 'package:jbtimer/storage/session_storage.dart';

class SessionList extends StatefulWidget {
  final void Function(Session) onSessionSelected;

  const SessionList({super.key, required this.onSessionSelected});

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
                _onSessionIdentifierSelected(sessionIdentifier);
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

  _onSessionIdentifierSelected(SessionIdentifier sessionIdentifier) async {
    Session? session = await SessionStorage.load(sessionIdentifier.id);
    if (session == null) {
      throw Exception('No such session with id: ${sessionIdentifier.id}');
    }

    widget.onSessionSelected(session);
  }
}
