import 'package:focus/model/group/comment_entity.dart';

class GraphEntity {
  final int id;
  final int id_group;
  final String graph;
  final List<CommentEntity> comments;

  GraphEntity.db(this.id, this.id_group, this.graph, this.comments);

  Map<String, dynamic> toMap() => {
    'id' : id,
    'id_group' : id_group,
    'graph' : graph,
  };

}