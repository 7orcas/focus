import 'package:focus/model/app_state.dart';
import 'package:focus/redux/group_reducers.dart';
import 'package:focus/redux/session_reducers.dart';

// Define peer functions that change state

AppState appStateReducer(AppState state, action){
  return AppState(
    groups: groupReducer(state.groups, action),
    session: sessionReducer(state.session, action),
  );
}

