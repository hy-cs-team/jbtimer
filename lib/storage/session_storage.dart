import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/storage/session_list_storage.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage _sessionStorage = LocalStorage('sessions');

class SessionStorage {
  static Future<Session?> loadSelected() async {
    String? id = await SessionListStorage.getSelectedId();
    if (id == null) return null;

    return await load(id);
  }

  static Future<Session?> load(String id) async {
    await _sessionStorage.ready;

    Map<String, dynamic>? json = _sessionStorage.getItem(id);
    if (json == null) {
      return null;
    }
    return Session.fromJson(json);
  }

  static Future<void> save(Session session) {
    return _sessionStorage.ready
        .then((ready) => _sessionStorage.setItem(session.id, session.toJson()));
  }
}
