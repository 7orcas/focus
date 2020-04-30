
class CommentEntity {
  final int id;
  final int id_group; //here for convenience
  final int id_graph;
  final int id_user;
  String comment;

  CommentEntity.db(this.id, this.id_group, this.id_graph, this.id_user, this.comment);

}