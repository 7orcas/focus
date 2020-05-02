import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/database/db_graph.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/service/util.dart';
import 'package:redux/redux.dart';

Future<List<GroupTile>> _loadFromDB() async {
  Util(StackTrace.current).out('groupMiddleware loadFromDB');
  List<GroupEntity> list = await GroupDB().loadGroups();
  return list.map((g) => GroupTile.entity(g)).toList();
}

void _saveToDB(GroupTile group) async {
  Util(StackTrace.current).out('groupMiddleware saveToDB');
  GroupDB().saveGroup(group.toEntity());
}

void _saveGraphToDB(GraphTile graph) async {
  Util(StackTrace.current).out('groupMiddleware saveToDB graph');
  GraphDB().saveGraph(graph.toEntity());
}

void _removeFromDB(GroupTile group) async {
  Util(StackTrace.current).out('groupMiddleware removeFromDB');
  GroupDB().removeGroup(group.toEntity());
}

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  Util(StackTrace.current)
      .out('groupMiddleware action=' + action.runtimeType.toString());

  if (action is GetGroupsAction) {
    await _loadFromDB()
        .then((state) => store.dispatch(LoadGroupsAction(state)));
  }

  if (action is AddGroupAction) {
    _saveToDB(action.group);
  }

  if (action is RemoveGroupAction) {
    _removeFromDB(action.group);
  }

  if (action is AddGraphAction) {
    _saveGraphToDB(action.graph);
  }
}
