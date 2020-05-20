import 'package:redux/redux.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';

/// Methods in this file are standalone access methods that
/// update the redux store directly


/// Load group graph and comments and store in group tile
/// Note this method
Future<GroupTile> loadGroupConversation(Store<AppState> store, int id) async {
  GroupTile g = store.state.findGroupTile(id);

  //Already loaded
  if (g != null && g.containsGraphs()) {
    return Future<GroupTile>.value(g);
  }
  //Get from DB
  g = await GroupDB().loadGroupConversation(id);
  store.state.addGroupTile(g);
  return g;
}

/// Load groups for application initialisation
bool LOAD = false;
Future<bool> initialiseGroups(Store<AppState> store) async {
  if (LOAD) return Future<bool>.value(true);

  //Get from DB
  Util(StackTrace.current).out('loading groups');
  LOAD = true;
  store.state.groups = await GroupDB().loadGroups();
  return Future<bool>.value(true);
}
