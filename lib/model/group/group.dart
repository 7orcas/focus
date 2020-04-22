import 'package:flutter/foundation.dart';

class Group {
  final int id;
  final String name;
  final bool admin;

  Group({
    @required this.id,
    @required this.name,
    this.admin = false,
  });

  Group.db(this.id, this.name, this.admin);

  Group copyWith({int id, String body}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      admin: admin ?? this.admin,
    );
  }

  Map toJson() => {
    'id' : id,
    'name' : name,
    'admin' : admin,
  };

  @override
  String toString(){
    return toJson().toString();
  }

}
