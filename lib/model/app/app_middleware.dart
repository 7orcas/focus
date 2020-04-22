import 'package:focus/model/app/app.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/session/session_middleware.dart';
import 'package:focus/service/util.dart';

final util = Util(StackTrace.current);


void appMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  util.out('middleware sessionStateMiddleware action=' + action.runtimeType.toString());

  sessionStateMiddleware(store, action, next);

}
