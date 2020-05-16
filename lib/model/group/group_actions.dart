import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state


/// Load all groups from the database
class LoadGroupsAction {
  LoadGroupsAction(){
    Util(StackTrace.current).out('GetGroupsAction constructor');
  }
}
/// Callback from [LoadGroupsAction] to mutate the store
class LoadGroupsStoreAction {
  final List<GroupTile> groups;
  LoadGroupsStoreAction(this.groups){}
}

///Add a new group
/// ToDO Refactor - this is here just for testing
class AddGroupAction {
  final GroupTile group;
  AddGroupAction(this.group){}
}
class AddGroupStoreAction {
  final GroupTile group;
  AddGroupStoreAction(this.group){}
}

///Remove a group
/// ToDO Refactor - this is here just for testing
class DeleteGroupAction {
  final GroupTile group;
  DeleteGroupAction(this.group);
}
