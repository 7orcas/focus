import 'package:redux/redux.dart';
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

  //Convenience method
  String label(String key) {
    return session.label(key);
  }

  //Convenience method
  Language get language => session.language;

}
