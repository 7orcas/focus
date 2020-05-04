import 'package:focus/model/app/app.dart';
import 'package:focus/route.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/database/db_graph.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/service/util.dart';
import 'package:redux/redux.dart';

Future<GroupConversation> getGroupConversation(Store<AppState> store, int id) {
  GroupTile g = store.state.findGroupTile(id);
  if (g != null && g.containsGraphs()) {
    GroupConversation c = store.state.findGroupTile(id).toConversation();
    c.loadedFromStore = true;
    return Future<GroupConversation>.value(c);
  }
  return GroupDB().loadGroupConversation(id);
}

Future<List<GroupTile>> _loadFromDB() async {
  Util(StackTrace.current).out('groupMiddleware loadFromDB');
  List<GroupEntity> list = await GroupDB().loadGroups();
  return list.map((g) => GroupTile.entity(g)).toList();
}

void _saveGroupToDB(GroupTile group) async {
  Util(StackTrace.current).out('groupMiddleware saveToDB');
  GroupDB().saveGroup(group.toEntity());
}

void _saveGraphToDB(Store<AppState> store, GraphTile graph) async {
  Util(StackTrace.current).out('saveToDB graph');
  GraphEntity g = await GraphDB().saveGraph(graph.toEntity());

  //Add back to store
  GroupTile gt = store.state.findGroupTile(graph.id_group);
  if (gt == null) return;

  gt.graphs.add(GraphTile.entity(g));
  store.state.groups = store.state.groups.map((e) {
    if (e.id == graph.id_group) return gt;
    return e;
  }).toList();
}

void _removeGroupFromDB(GroupTile group) async {
  Util(StackTrace.current).out('removeGroupFromDB');
  GroupDB().removeGroup(group.toEntity());
}

Future<bool> _removeGraphFromDB(Store<AppState> store, GraphTile graph) async {
  Util(StackTrace.current).out('removeGraphFromDB');

  await GraphDB().removeGraph(graph.id);

  //remove from store
  GroupTile gt = store.state.findGroupTile(graph.id_group);
  if (gt == null) return true;

  gt.graphs.removeWhere((g) => g.id == graph.id);
  store.state.groups = store.state.groups.map((e) {
    if (e.id == graph.id_group) return gt;
    return e;
  }).toList();

  return true;
}

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  Util(StackTrace.current)
      .out('groupMiddleware action=' + action.runtimeType.toString());

  switch (action.runtimeType) {
    case GetGroupsAction:
      await _loadFromDB()
          .then((state) => store.dispatch(LoadGroupsAction(state)));
      break;
    case AddGroupAction:
      _saveGroupToDB(action.group);
      break;
    case RemoveGroupAction:
      _removeGroupFromDB(action.group);
      break;
    case AddGraphAction:
      _saveGraphToDB(store, action.graph);
      break;
    case DeleteGraphAction:
      _removeGraphFromDB(store, action.graph).catchError((e) {
        Navigator.pushNamed(context, ROUTE_GROUP_PAGE, arguments: group);
      });
      break;
  }
}
