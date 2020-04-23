import 'package:focus/model/group/group.dart';
import 'package:focus/model/group/group_actions.dart';

// Define peer functions that change state

List<Group> groupReducer(List<Group> state, action){

  bool _loaded = false; //TODO delete

  void loaded() {
    _loaded = true;
  }

  if (action is AddGroupAction){
    return []
      ..addAll(state)
      ..add(Group(id: action.id, name: action.name));
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
//    if (_loaded) return "None";
    return action.groups;
  }

  return state;
}
