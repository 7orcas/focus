import 'package:flutter/material.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

/// Save results of a graph to the database
class SaveGraphAction {
  final int id_group;
  final GraphBuild graph;
  SaveGraphAction(this.id_group, this.graph){
    Util(StackTrace.current).out('AddGraphAction constructor');
  }
}

/// Callback from [SaveGraphAction] to mutate the store
class SaveGraphStoreAction {
  final GraphTile graph;
  SaveGraphStoreAction(this.graph){}
}

class DeleteGraphAction {
  final GraphTile graph;
  final Function error;
  DeleteGraphAction(this.graph, this.error){
    Util(StackTrace.current).out('DeleteGraphAction constructor');
  }
}

/// Callback from [DeleteGraphAction] to mutate the store
class DeleteGraphStoreAction {
  final GraphTile graph;
  DeleteGraphStoreAction(this.graph){}
}

class SaveGraphCommentAction {
  final GraphTile graph;
  final int id_comment;
  final String comment;
  SaveGraphCommentAction(this.graph, this.id_comment, this.comment){
    Util(StackTrace.current).out('AddGraphCommentAction constructor');
  }
}

/// Callback from [SaveGraphCommentAction] to mutate the store
class SaveGraphCommentStoreAction {
  final CommentTile comment;
  SaveGraphCommentStoreAction(this.comment){}
}

class EditGraphCommentAction {
  final GraphTile graph;
  final int id_comment;
  EditGraphCommentAction(this.graph, this.id_comment){
    Util(StackTrace.current).out('EditGraphCommentAction constructor');
  }
}

class DeleteGraphCommentAction {
  final CommentTile comment;
  DeleteGraphCommentAction(this.comment){
    Util(StackTrace.current).out('RemoveGraphCommentAction constructor');
  }
}

/// Callback from [DeleteGraphCommentAction] to mutate the store
class RemoveGraphCommentStoreAction {
  final CommentTile comment;
  RemoveGraphCommentStoreAction(this.comment){
    Util(StackTrace.current).out('RemoveGraphCommentAction constructor');
  }
}

class ToggleHighlightAction {
  final GraphTile graph;
  ToggleHighlightAction(this.graph){}
}