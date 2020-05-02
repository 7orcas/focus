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
    List<GroupTile> l = state.map((e) {
      if (e.id == action.group.id) return action.group;
      return e;
    }).toList();

    //ToDo debug only
    for (GroupTile t in l){
      if (t.id == action.group.id){
        Util(StackTrace.current)
            .out('groupReducer AddGraphsAction, constains=' + t.containsGraphs().toString());
      }
    }
    return l;
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

  if (action is AddGraphAction) {

    Util(StackTrace.current)
        .out('groupReducer AddGraphAction, id=' + action.graph.id.toString());
  }

  return state;
}
