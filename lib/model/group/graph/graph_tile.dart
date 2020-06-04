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
  bool _highlight;

  GraphTile.entity(GraphEntity e)
      : id_group = e.id_group,
        graph = e.graph,
        comments = List<CommentTile>(),
        seconds = e.getEncoded(PARAM_KEY_TIME, 0),
        count = e.getEncoded(PARAM_KEY_COUNT, 0),
        _highlight = e.getEncoded(PARAM_KEY_HIGHLIGHT, false),
        super(e.id, e.created) {
    if (e.comments != null) {
      comments = e.comments.map((e) => CommentTile.entity(e)).toList();
    }
  }

  GraphEntity toEntity() {
    String e = addEncoded('', PARAM_KEY_TIME, seconds);
    e = addEncoded(e, PARAM_KEY_COUNT, count);
    e = addEncoded(e, PARAM_KEY_HIGHLIGHT, _highlight);

    return GraphEntity(id, dateTime(createdMS()), e, id_group, graph,
        comments.map((e) => e.toEntity()).toList());
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

  String createdFormatShort({hideSameYear: false}) {
    if (created == null) return '';
    if (hideSameYear && created.year == DateTime.now().year) {
      return DateFormat('dd.MMM').format(created);
    }
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

  bool get isHighlight => _highlight;
  void set highLight(bool v) => _highlight = v;
}
