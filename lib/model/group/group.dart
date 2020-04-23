import 'package:flutter/foundation.dart';
import 'package:focus/model/data/group_entity.dart';

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

//  Map toJson() => {
//    'id' : id,
//    'name' : name,
//    'admin' : admin,
//  };

  GroupEntity toEntity() {
    return GroupEntity(id, name, admin?1:0);
  }


//  @override
//  String toString(){
//    return toJson().toString();
//  }

}
