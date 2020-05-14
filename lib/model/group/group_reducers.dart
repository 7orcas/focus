import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/service/util.dart';

// Define peer functions that change state

List<GroupTile> groupReducer(AppState state, action) {

  switch (action.runtimeType) {
    case LoadGroupsAction:
      return action.groups;

    case AddGroupAction:
      GroupTile g = GroupTile(id: state.groups.length + 2, name: action.name);
      action.group = g;
      Util(StackTrace.current)
          .out('groupReducer AddGroupAction, id=' + g.id.toString());
      return []
        ..addAll(state.groups)
        ..add(g);

  }

  return state.groups;
}

