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

  GraphEntity toEntity() {
    List<CommentEntity> list = comments.map((t) => t.toEntity()).toList();
    return GraphEntity(id, id_group, graph, list);
  }
}