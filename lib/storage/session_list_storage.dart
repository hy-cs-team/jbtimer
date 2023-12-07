import 'package:localstorage/localstorage.dart';

final LocalStorage _sessionListStorage = LocalStorage('session_list');

class SessionIdentifier {
  final String id;
  final String name;

  SessionIdentifier({required this.id, required this.name});

  SessionIdentifier.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SessionListStorage {
  static Future<List<SessionIdentifier>> load() async {
    List<Map<String, dynamic>>? jsonList = await _sessionListStorage.ready.then(
        (ready) => _sessionListStorage.getItem('identifiers')
            as List<Map<String, String>>?);
    if (jsonList == null) {
      return [];
    }

    return jsonList.map((json) => SessionIdentifier.fromJson(json)).toList();
  }
}
