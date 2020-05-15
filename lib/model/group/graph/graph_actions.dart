import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

class SaveGraphAction {
  final int id_group;
  final GraphBuild graph;
  SaveGraphAction(this.id_group, this.graph){
    Util(StackTrace.current).out('AddGraphAction constructor');
  }
}

class DeleteGraphAction {
  final GraphTile graph;
  final Function error;
  DeleteGraphAction(this.graph, this.error){
    Util(StackTrace.current).out('DeleteGraphAction constructor');
  }
}

class AddGraphCommentAction {
  final GraphTile graph;
  final int id_comment;
  final String comment;
  AddGraphCommentAction(this.graph, this.id_comment, this.comment){
    Util(StackTrace.current).out('AddGraphCommentAction constructor');
  }
}

class EditGraphCommentAction {
  final GraphTile graph;
  final int id_comment;
  EditGraphCommentAction(this.graph, this.id_comment){
    Util(StackTrace.current).out('EditGraphCommentAction constructor');
  }
}

class RemoveGraphCommentAction {
  final CommentTile comment;
  RemoveGraphCommentAction(this.comment){
    Util(StackTrace.current).out('RemoveGraphCommentAction constructor');
  }
}