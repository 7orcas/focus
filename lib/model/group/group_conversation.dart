import 'package:focus/model/group/graph_entity.dart';

class GroupConversation {
  final int id;
  final String name;
  final List<GraphEntity> graphs;

  GroupConversation.db(this.id, this.name, this.graphs);

  int get count => graphs.length;
}
