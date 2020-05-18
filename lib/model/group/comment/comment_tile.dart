import 'package:flutter/foundation.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/comment/comment_entity.dart';

class CommentTile extends BaseTile {
  final int id_group; //here for convenience
  final int id_graph;
  final int id_user;
  final String comment;
  bool comment_read;
  bool _edit = false; //true == user is editing this comment

  CommentTile({
    @required id,
    @required created,
    @required this.id_group,
    @required this.id_graph,
    @required this.id_user,
    @required this.comment,
    @required this.comment_read,
  }) : super(id, created);

  CommentTile.entity(CommentEntity e)
      : id_group = e.id_group,
        id_graph = e.id_graph,
        id_user = e.id_user,
        comment = e.comment,
        comment_read = BaseEntity.toBoolean(e.comment_read),
        super(e.id, e.created);

  CommentEntity toEntity() {
    return CommentEntity(id, createdMS(), id_group, id_graph, id_user, comment,
        fromBool(comment_read));
  }

  void edit(bool v) {
    _edit = v;
  }

  void editCancel() {
    _edit = false;
  }

  bool get isEdit => _edit;
}
