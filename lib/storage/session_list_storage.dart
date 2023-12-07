import 'package:jbtimer/data/session.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage _sessionListStorage = LocalStorage('session_list');

class SessionIdentifier {
  final String id;
  final String name;

  SessionIdentifier({required this.id, required this.name});

  SessionIdentifier.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  SessionIdentifier.fromSession(Session session)
      : id = session.id,
        name = session.name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SessionListStorage {
  static Future<List<SessionIdentifier>> load() async {
    await _sessionListStorage.ready;

    List<dynamic>? jsonList = _sessionListStorage.getItem('identifiers');
    if (jsonList == null) {
      return [];
    }

    return jsonList.map((json) => SessionIdentifier.fromJson(json)).toList();
  }

  static Future<void> onCreate(Session createdSession) async {
    List<SessionIdentifier> sessionIdentifiers = await load();
    sessionIdentifiers.add(SessionIdentifier.fromSession(createdSession));
    List<Map<String, dynamic>> jsonList =
        sessionIdentifiers.map((identifier) => identifier.toJson()).toList();

    _sessionListStorage.setItem('identifiers', jsonList);
  }
}
