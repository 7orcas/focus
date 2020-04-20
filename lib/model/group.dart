import 'package:flutter/foundation.dart';

class Group {
  final int id;
  final String name;

  Group({
    @required this.id,
    @required this.name,
  });

  Group copyWith({int id, String body}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
