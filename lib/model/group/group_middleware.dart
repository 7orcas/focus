import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/service/database.dart';
import 'package:focus/service/util.dart';
import 'package:redux/redux.dart';


Future<List<Group>> _loadFromDB() async {
  Util(StackTrace.current).out('groupMiddleware loadFromDB');
  return await FocusDB().loadGroups();
}

void _saveToDB(Group group) async {
  Util(StackTrace.current).out('groupMiddleware saveToDB');
  FocusDB().saveGroup(group.toEntity());
}

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  Util(StackTrace.current).out('groupMiddleware action=' + action.runtimeType.toString());

  if (action is GetGroupsAction) {
    await _loadFromDB()
        .then((state) => store.dispatch(LoadGroupsAction(state)));
  }

  if (action is AddGroupAction) {
    _saveToDB(action.group);
  }

}
