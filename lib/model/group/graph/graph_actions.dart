import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

class AddGraphAction {
  final int id_group;
  final GraphBuild graph;
  AddGraphAction(this.id_group, this.graph){
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
  final String comment;
  AddGraphCommentAction(this.graph, this.comment){
    Util(StackTrace.current).out('AddGraphCommentAction constructor');
  }
}