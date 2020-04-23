import 'package:focus/model/app/app.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/session/session_middleware.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/group_middleware.dart';
import 'package:focus/service/util.dart';


void appMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  Util(StackTrace.current).out('appMiddleware action=' + action.runtimeType.toString());

  if (action is LoadAppAction) {
    sessionStateMiddleware(store, GetLanguageAction(), next);
    groupStateMiddleware(store, GetGroupsAction(), next);
    return;
  }
}

List<Middleware<AppState>> listMiddleware() {
  return [
    appMiddleware,
    groupStateMiddleware,
    sessionStateMiddleware];
}
