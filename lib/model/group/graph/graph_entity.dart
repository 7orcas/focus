import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/database/_scheme.dart';

class GraphEntity {
  final int id;
  final int id_group;
  final String graph;
  final List<CommentEntity> comments;

  GraphEntity(this.id, this.id_group, this.graph, this.comments);

  Map<String, dynamic> toMap() => {
    'id' : id,
    DBK_GROUP : id_group,
    'graph' : graph,
  };

}