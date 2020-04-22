import 'package:focus/model/app/app.dart';
import 'package:redux/redux.dart';
import 'package:focus/service/util.dart';

final util = Util(StackTrace.current);

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  util.out('groupStateMiddleware action=' + action.runtimeType.toString());

}
