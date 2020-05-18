import 'package:focus/database/_scheme.dart';
import 'package:focus/model/base_entity.dart';

class CommentEntity extends BaseEntity {
  final int id_group; //here for convenience
  final int id_graph;
  final int id_user;
  final int comment_read;
  String comment;

  CommentEntity(id, created, this.id_group, this.id_graph, this.id_user,
      this.comment, this.comment_read)
      : super(id, created);

  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      DBK_GROUP: id_group,
      DBK_GRAPH: id_graph,
      DBK_USER: id_user,
      'comment': comment,
      'comment_read': comment_read
    });

  CommentEntity copyWith(int id, DateTime created) {
    return CommentEntity(id ?? this.id, created ?? this.created, id_group,
        id_graph, id_user, comment, comment_read);
  }
}
