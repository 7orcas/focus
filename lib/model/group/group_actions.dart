import 'package:focus/model/group/group.dart';
import 'package:focus/service/util.dart';

// Actions that can mutate the state

final util = Util(StackTrace.current);

class AddGroupAction {
  static int _id = 0;
  final String name;

  AddGroupAction(this.name){
    _id++;
  }

  int get id => _id;
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
    util.out('GetGroupsAction constructor');
  }
}

class LoadGroupsAction {
  final List<Group> groups;

  LoadGroupsAction(this.groups){
    util.out('LoadGroupsAction constructor size=' + this.groups.length.toString());
  }

}