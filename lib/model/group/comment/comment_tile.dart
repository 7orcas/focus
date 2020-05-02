import 'package:flutter/foundation.dart';
import 'package:focus/model/group/comment/comment_entity.dart';

class CommentTile {
  final int id;
  final int id_group; //here for convenience
  final int id_graph;
  final int id_user;
  final String comment;

  CommentTile({
    @required this.id,
    @required this.id_group,
    @required this.id_graph,
    @required this.id_user,
    @required this.comment,
  });

  CommentTile.entity(CommentEntity e)
      : id = e.id,
        id_group = e.id_group,
        id_graph = e.id_graph,
        id_user = e.id_user,
        comment = e.comment;

  CommentEntity toEntity() {
    return CommentEntity(id, id_group, id_graph, id_user, comment);
  }
}
