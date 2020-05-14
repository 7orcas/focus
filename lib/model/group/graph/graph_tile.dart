import 'package:flutter/foundation.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/comment/comment_tile.dart';

class GraphTile {
  final int id;
  final int id_group;
  final String graph;
  List<CommentTile> comments;

  GraphTile(
    this.id,
    this.id_group,
    this.graph,
    this.comments,
  );

  GraphTile.entity(GraphEntity e)
      : id = e.id,
        id_group = e.id_group,
        graph = e.graph,
        comments = List<CommentTile>();

  CommentTile addComment(String comment, int id_user) {
    CommentTile t = CommentTile(
        id: null,
        id_group: id_group,
        id_graph: id,
        id_user: id_user,
        comment: comment,
        comment_read: true);
    comments.add(t);
    return t;
  }

  GraphEntity toEntity() {
    List<CommentEntity> list = comments.map((t) => t.toEntity()).toList();
    return GraphEntity(id, id_group, graph, list);
  }

  CommentTile getEditComment(){
    for (CommentTile c in comments){
      if (c.isEdit) return c;
    }
    return null;
  }

  void editComment (int id_comment){
    for (CommentTile c in comments){
      c.edit(c.id == id_comment);
    }
  }

  void editClear(){
    for (CommentTile c in comments){
      c.editCancel();
    }
  }

}
