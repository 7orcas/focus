import 'dart:async';
import 'dart:convert';
import 'package:focus/model/app/app.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/session/session_actions.dart';
import 'package:focus/service/util.dart';

final util = Util(StackTrace.current);

void _saveToPrefs(Session state) async {
  util.out('middleware saveToPrefs');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var string = json.encode(state.toJson());
  await prefs.setString('sessionState', string);
}

Future<Session> _loadFromPrefs() async {
  util.out('middleware loadFromPrefs');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var string = prefs.getString('sessionState');
  if (string == null) {
    return Session.initialState();
  }
  Map map = json.decode(string);
  util.out('middleware loadFromPrefs map=' + map.toString());
  return Session.fromJson(map);
}

void sessionStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  util.out('sessionStateMiddleware action=' + action.runtimeType.toString());

  if (action is ChangeLanguageAction) {
    _saveToPrefs(store.state.session);
  }

  if (action is GetLanguageAction) {
    await _loadFromPrefs()
        .then((state) => store.dispatch(LoadLanguageAction(state.language)));
  }

}
