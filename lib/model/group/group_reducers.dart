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

//    case LoadGroupConversationAction:
//      state.addGroupTile(action.group);
//      return []..addAll(state.groups);

    case AddGroupStoreAction:
      return []
        ..addAll(state.groups)
        ..add(action.group);

    case EditGraphCommentAction:
      var group = state.findGroupTile(action.graph.id_group);
      if (group == null) break;
      action.graph.editComment(action.id_comment);
      return state.groups.map((e) {
        if (e.id == action.graph.id_group) return group;
        return e;
      }).toList();


  }

  return state.groups;
}

