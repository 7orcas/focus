import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group_reducers.dart';
import 'package:focus/model/session/session_reducers.dart';

// Define peer functions that change state

AppState appStateReducer(AppState state, action){
  return AppState(
    groups: groupReducer(state.groups, action),
    session: sessionReducer(state.session, action),
  );
}

