import 'package:flutter/cupertino.dart';

extension ListDisposeExtension<T extends ChangeNotifier> on List<T> {
  void dispose() {
    for (final child in this) {
      child.dispose();
    }
  }
}