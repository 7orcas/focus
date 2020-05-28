import 'package:focus/model/session/session_actions.dart';
import 'package:redux/redux.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/service/language.dart';

class BaseViewModel {
  final Store<AppState> store;
  final List<GroupTile> groups;
  final Session session;

  BaseViewModel(Store<AppState> store):
    this.store = store,
    this.groups = store.state.groups,
    this.session = store.state.session;

  Language get language => session.language;
  String label(String key) => session.label(key);

  bool get isGroupsEnabled => store.state.isGroupsEnabled;

  onChangeLanguage(String lang) {
    store.dispatch(ChangeLanguageAction(lang));
  }

}
