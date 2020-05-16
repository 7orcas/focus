import 'package:flutter/material.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/comment/comment_tile.dart';

// Define peer functions that change state

List<GroupTile> groupReducer(AppState state, action) {

  Util(StackTrace.current)
      .out('redux groupReducer action=' + action.runtimeType.toString());

  switch (action.runtimeType) {

    case LoadGroupsStoreAction:
      return action.groups;

    case AddGroupStoreAction:
      return []
        ..addAll(state.groups)
        ..add(action.group);

    case EditGraphCommentAction:
      var group = state.findGroupTile(action.graph.id_group);
      action.graph.editComment(action.id_comment);
      return state.groups.map((e) {
        if (e.id == action.graph.id_group) return group;
        return e;
      }).toList();

    case SaveGraphStoreAction:
      state.setGraphExpansionKey(action.graph.id, true);
      GroupTile gt = state.findGroupTile(action.graph.id_group);
      gt.graphs.add(action.graph);
      return state.groups.map((e) {
        if (e.id == gt.id) return gt;
        return e;
      }).toList();

    case DeleteGraphStoreAction:
      GroupTile gt = state.findGroupTile(action.graph.id_group);
      gt.graphs.removeWhere((g) => g.id == action.graph.id);
       return state.groups.map((e) {
        if (e.id == action.graph.id_group) return gt;
        return e;
      }).toList();

    case SaveGraphCommentStoreAction:
      var group = state.findGroupTile(action.comment.id_group);
      var graph = group.findGraphTile(action.comment.id_graph);
      graph.editClear();

      bool found = false;
      for (int i = 0; i < graph.comments.length; i++) {
        CommentTile c = graph.comments[i];
        if (c.id == action.comment.id) {
          found = true;
          graph.comments[i] = action.comment;
          break;
        }
      }
      if (!found) {
        graph.comments.add(action.comment);
      }

      return state.groups.map((e) {
        if (e.id == graph.id_group) return group;
        return e;
      }).toList();

    case RemoveGraphCommentStoreAction:
      var group = state.findGroupTile(action.comment.id_group);
      var graph = group.findGraphTile(action.comment.id_graph);

      graph.comments.removeWhere((g) => g.id == action.comment.id);
      return state.groups.map((e) {
        if (e.id == action.comment.id_group) return group;
        return e;
      }).toList();

  }

  return state.groups;
}

