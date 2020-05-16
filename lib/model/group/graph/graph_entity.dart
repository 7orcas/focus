import 'package:focus/database/_scheme.dart';
import 'package:focus/model/group/comment/comment_entity.dart';

class GraphEntity {
  final int id;
  final int id_group;
  final String graph;
  final List<CommentEntity> comments;

  GraphEntity(this.id, this.id_group, this.graph, this.comments);

  GraphEntity.build(this.id_group, this.graph)
      : id = null,
        comments = List<CommentEntity>();

  Map<String, dynamic> toMap() => {
        'id': id,
        DBK_GROUP: id_group,
        'graph': graph,
      };

  GraphEntity copyWith(int id) {
    return GraphEntity(id ?? this.id, id_group, graph, comments);
  }

  String _graphCompress(){
    if (graph == null) return '';

  }


}
