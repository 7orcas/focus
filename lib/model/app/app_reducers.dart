import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_reducers.dart';
import 'package:focus/model/session/session_reducers.dart';

// Define peer functions that change state

AppState appStateReducer(AppState state, action){
  return state.copyWith(
    sessionReducer(state, action),
    groupReducer(state, action),
  );
}

