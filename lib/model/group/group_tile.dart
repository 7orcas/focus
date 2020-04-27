import 'package:flutter/foundation.dart';
import 'package:focus/model/group/group_entity.dart';

class GroupTile {
  final int id;
  final String name;

  GroupTile({
    @required this.id,
    @required this.name,
  });

  GroupTile.db(this.id, this.name);

  GroupTile copyWith({int id, String body}) {
    return GroupTile(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

//  Map toJson() => {
//    'id' : id,
//    'name' : name,
//    'admin' : admin,
//  };

  GroupEntity toEntity() {
    return GroupEntity(id, name);
  }


//  @override
//  String toString(){
//    return toJson().toString();
//  }

}
