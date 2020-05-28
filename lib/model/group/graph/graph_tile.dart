import 'package:flutter/foundation.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:intl/intl.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/comment/comment_tile.dart';

class GraphTile extends BaseTile {
  final int id_group;
  final String graph;
  List<CommentTile> comments;
  final int seconds;
  final int count;

//  GraphTile(
//    id,
//    created,
//    this.id_group,
//    this.graph,
//    this.comments,
//    this.seconds,
//    this.count,
//  ) : super(id, created);

  GraphTile.entity(GraphEntity e)
      : id_group = e.id_group,
        graph = e.graph,
        comments = List<CommentTile>(),
        seconds = e.getEncoded(PARAM_KEY_TIME, 0),
        count = e.getEncoded(PARAM_KEY_COUNT, 0),
        super(e.id, e.created){
    if (e.comments != null){
      comments = e.comments.map((e) => CommentTile.entity(e)).toList();
    }
  }

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

//  GraphEntity toEntity() {
//    List<CommentEntity> list = comments.map((t) => t.toEntity()).toList();
//    return GraphEntity(id, createdMS(), addEncoded('', PARAM_KEY_TIME, seconds),
//        id_group, graph, list);
//  }

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
  String createdFormat() {
    if (created == null) return '';
    return DateFormat('hh:mm dd.MMM.yy').format(created);
  }

  String createdFormatShort() {
    if (created == null) return '';
    return DateFormat('dd.MMM.yy').format(created);
  }

  String timeFormat() {
    if (seconds == null) return '';
    return Util.timeFormat(seconds);
  }

  String firstCommentFormat() {
    if (comments == null || comments.length == 0) return '';
    return comments[0].comment.replaceAll('\n', ' ');
  }
}
