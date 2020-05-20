import 'package:focus/model/app/app_state.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/app/app_actions.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/model/session/session_middleware.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/group_middleware.dart';
import 'package:focus/service/util.dart';

appMiddleware(Store<AppState> store, action, NextDispatcher next) async {

  Util(StackTrace.current)
      .out('appMiddleware action=' + action.runtimeType.toString());

  if (action is LoadAppAction) {
    groupStateMiddleware(store, LoadGroupsAction(), null);
    sessionStateMiddleware(store, GetLanguageAction(), null);
    return;
  }

  if (next != null) next(action);
}

List<Middleware<AppState>> listMiddleware() {
  return [appMiddleware, groupStateMiddleware, sessionStateMiddleware];
}
