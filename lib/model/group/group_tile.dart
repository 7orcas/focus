import 'package:flutter/foundation.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/service/util.dart';

class GroupTile {
  final int id;
  final String name;
  List<GraphTile> graphs;

  GroupTile({
    @required this.id,
    @required this.name,
    @required this.graphs,
  });

  GroupTile.entity(GroupEntity e)
      : id = e.id,
        name = e.name,
        graphs = null;

  GroupTile copyWith({int id, String body}) {
    return GroupTile(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  bool containsGraphs () {
    Util(StackTrace.current).out('containsGraphs :' + (graphs != null).toString());
    return graphs != null;
  }

  GroupEntity toEntity() {
    return GroupEntity(id, name);
  }

  GroupConversation toConversation(){
    return GroupConversation.db(id, name, null, null, graphs);
  }


}
