import 'package:focus/model/group/group.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/service/util.dart';

// Define peer functions that change state

List<Group> groupReducer(List<Group> state, action){

  if (action is AddGroupAction){
    Group g = Group(id: state.length+2, name: action.name);
    action.group = g;
    Util(StackTrace.current).out('groupReducer AddGroupAction, id=' + g.id.toString());
    return []
      ..addAll(state)
      ..add(g);
  }

  if (action is RemoveGroupAction){
    return List.unmodifiable(List.from(state)
      ..remove(action.group)
    );
  }

  if (action is RemoveGroupsAction){
    return List.unmodifiable(<Group>[]);
  }

  if (action is LoadGroupsAction){
    return action.groups;
  }

  return state;
}
