import 'package:focus/model/group.dart';

// Actions that can mutate the state

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

