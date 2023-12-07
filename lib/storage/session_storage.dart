import 'package:jbtimer/data/session.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage _sessionStorage = LocalStorage('sessions');

class SessionStorage {
  static Future<Session> load(String id) async {
    Map<String, dynamic>? json = await _sessionStorage.ready
        .then((ready) => _sessionStorage.getItem(id));
    if (json == null) {
      throw Exception('No session with id: $id');
    }
    return Session.fromJson(json);
  }

  static Future<void> save(Session session) {
    return _sessionStorage.ready
        .then((ready) => _sessionStorage.setItem(session.id, session.toJson()));
  }
}
