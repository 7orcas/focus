import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/service/util.dart';

// Define peer functions that change state

List<GroupTile> groupReducer(List<GroupTile> state, action) {

  if (action is AddGroupAction) {
    GroupTile g = GroupTile(id: state.length + 2, name: action.name);
    action.group = g;
    Util(StackTrace.current)
        .out('groupReducer AddGroupAction, id=' + g.id.toString());
    return []
      ..addAll(state)
      ..add(g);
  }

  //ToDo refactor
  if (action is AddGraphsAction) {
    Util(StackTrace.current)
        .out('groupReducer AddGraphsAction, constains=' + action.group.containsGraphs().toString());
    return state.map((e) {
      if (e.id == action.group.id) return action.group;
      return e;
    }).toList();
  }

  if (action is RemoveGroupAction) {
    return List.unmodifiable(List.from(state)..remove(action.group));
  }

  if (action is RemoveGroupsAction) {
    return List.unmodifiable(<GroupTile>[]);
  }

  if (action is LoadGroupsAction) {
    return action.groups;
  }

  if (action is AddGraphAction || action is DeleteGraphAction) {
    Util(StackTrace.current)
        .out('groupReducer xxxxGraphAction, type=' + action.runtimeType.toString());
  }

  return state;
}
