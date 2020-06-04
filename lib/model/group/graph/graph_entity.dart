import 'package:focus/database/_scheme.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/comment/comment_entity.dart';

const PARAM_KEY_TIME = 'time';
const PARAM_KEY_COUNT = 'count';
const PARAM_KEY_HIGHLIGHT = 'hl';

class GraphEntity extends BaseEntity {
  final int id_group;
  final String graph;
  final List<CommentEntity> comments;

  GraphEntity(id, createdMS, encoded, this.id_group, this.graph, this.comments)
      : super(id, createdMS, encoded);

  GraphEntity.build(this.id_group, this.graph)
      : comments = List<CommentEntity>(),
        super(null, null, null);

  Map<String, dynamic> toMap() => super.toMap()
    ..addAll({
      DBK_GROUP: id_group,
      'graph': graph,
    });

  GraphEntity copyWith(int id, DateTime created) {
    return GraphEntity(
      id ?? this.id,
      created ?? this.created,
      encoded,
      id_group,
      graph,
      comments,
    );
  }
}
