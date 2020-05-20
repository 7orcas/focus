import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/comment/comment_tile.dart';

class GraphTile extends BaseTile {
  final int id_group;
  final String graph;
  List<CommentTile> comments;

  GraphTile(
    id,
    created,
    this.id_group,
    this.graph,
    this.comments,
  ) : super(id, created);

  GraphTile.entity(GraphEntity e)
      : id_group = e.id_group,
        graph = e.graph,
        comments = List<CommentTile>(),
        super(e.id, e.created);

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
    return GraphEntity(id, createdMS(), id_group, graph, list);
  }

  CommentTile findCommentTile(int id) {
    for (CommentTile c in comments) {
      if (c.id == id) return c;
    }
    return null;
  }

  CommentTile getEditComment() {
    for (CommentTile c in comments) {
      if (c.isEdit) return c;
    }
    return null;
  }

  void editComment(int id_comment) {
    for (CommentTile c in comments) {
      c.edit(c.id == id_comment);
    }
  }

  void editClear() {
    for (CommentTile c in comments) {
      c.editCancel();
    }
  }

  @override
  String createdFormat(){
    if(created == null) return '';
    return DateFormat('hh:mm dd.MMM.yy').format(created);
  }

  String firstCommentFormat(){
    if(comments == null || comments.length == 0) return '';
    return comments[0].comment;
  }

}
