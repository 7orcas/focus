import 'package:focus/model/group/group.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

class AddGroupAction {
  final String name;
  Group group;
  AddGroupAction(this.name){
    Util(StackTrace.current).out('AddGroupAction constructor');
  }
}

class RemoveGroupAction {
  final Group group;
  RemoveGroupAction(this.group);
}

class RemoveGroupsAction {}

class GroupAdminAction {
  final Group group;
  GroupAdminAction(this.group);
}

class GetGroupsAction {
  GetGroupsAction(){
    Util(StackTrace.current).out('GetGroupsAction constructor');
  }
}

class LoadGroupsAction {
  final List<Group> groups;
  bool loaded = false;
  LoadGroupsAction(this.groups){
    Util(StackTrace.current).out('LoadGroupsAction constructor size=' + this.groups.length.toString());
  }

}