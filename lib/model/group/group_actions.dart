import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

class AddGroupAction {
  final String name;
  GroupTile group;
  AddGroupAction(this.name){
    Util(StackTrace.current).out('AddGroupAction constructor');
  }
}

class AddGraphsAction {
  final GroupTile group;
  AddGraphsAction(this.group){
    Util(StackTrace.current).out('AddGraphsAction constructor');
  }
}

class RemoveGroupAction {
  final GroupTile group;
  RemoveGroupAction(this.group);
}

class RemoveGroupsAction {}

class GroupAdminAction {
  final GroupTile group;
  GroupAdminAction(this.group);
}

class GetGroupsAction {
  GetGroupsAction(){
    Util(StackTrace.current).out('GetGroupsAction constructor');
  }
}

class LoadGroupsAction {
  final List<GroupTile> groups;
  bool loaded = false;
  LoadGroupsAction(this.groups){
    Util(StackTrace.current).out('LoadGroupsAction constructor size=' + this.groups.length.toString());
  }

}
