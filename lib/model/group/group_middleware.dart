import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/service/database.dart';
import 'package:focus/service/util.dart';
import 'package:redux/redux.dart';

final util = Util(StackTrace.current);

Future<List<Group>> _loadFromDB() async {
  util.out('middleware loadFromDB');
  FocusDB db = FocusDB();
  return await db.loadGroups();
}

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  util.out('groupStateMiddleware action=' + action.runtimeType.toString());

  if (action is GetGroupsAction) {
    await _loadFromDB()
        .then((state) => store.dispatch(LoadGroupsAction(state)));
  }

}
