import 'package:focus/model/app/app.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/session/session_middleware.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/group_middleware.dart';
import 'package:focus/service/util.dart';

final util = Util(StackTrace.current);


void appMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  util.out('appMiddleware action=' + action.runtimeType.toString());

  if (action is LoadAppAction) {
    sessionStateMiddleware(store, GetLanguageAction(), next);
    groupStateMiddleware(store, GetGroupsAction(), next);
    return;
  }

  sessionStateMiddleware(store, action, next);
  groupStateMiddleware(store, action, next);

}
