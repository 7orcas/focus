import 'package:focus/model/app/app.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/model/session/session.dart';
import 'file:///C:/Projects/focus/lib/page/graph/graph_conversation.dart';
import 'package:focus/route.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/database/db_graph.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/service/error.dart';
import 'package:focus/service/util.dart';
import 'package:redux/redux.dart';

Future<GroupTile> getGroupConversation(Store<AppState> store, int id) async {
  GroupTile g = store.state.findGroupTile(id);

  //Already loaded
  if (g != null && g.containsGraphs()) {
    return Future<GroupTile>.value(g);
  }
  //Get from DB
  g = await GroupDB().loadGroupConversation(id);
  store.state.setGroupTile(g);

  return g;
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

Future<bool> _saveGraphToDB(Store<AppState> store, int id_group, GraphBuild graph) async {
  Util(StackTrace.current).out('saveToDB graph');

  //Save to DB
  var entity = GraphEntity.build(id_group, graph.toList());
  entity = await GraphDB().saveGraph(entity);

  //Add back to store
  GroupTile gt = store.state.findGroupTile(id_group);
  if (gt == null) return false;
  var tile = GraphTile.entity(entity);
  gt.graphs.add(tile);

  store.state.groups = store.state.groups.map((e) {
    if (e.id == id_group) return gt;
    return e;
  }).toList();

  return true;
}

Future<bool> _saveGraphCommentToDB(Store<AppState> store, GraphTile graph, String comment) async {
  Util(StackTrace.current).out('saveToDB graph comment');

  //Save to DB
  var entity = CommentEntity(null, graph.id_group, graph.id, ID_USER_ME, comment, BaseEntity.fromBoolean(true));
  entity = await GraphDB().saveGraphComment(entity);

  //Add back to store
  var e1 = store.state.findGroupTile(graph.id_group);
  if (e1 == null) return false;
  var e2 = e1.findGraphTile(graph.id);
  e2.comments.add(CommentTile.entity(entity));

  store.state.groups = store.state.groups.map((e) {
    if (e.id == graph.id_group) return e1;
    return e;
  }).toList();

  return true;
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

Future<bool> _removeGraphCommentFromDB(Store<AppState> store, CommentTile comment) async {
  Util(StackTrace.current).out('_removeGraphCommentFromDB');

  await GraphDB().removeGraphComment(comment.id);

  //remove from store
  GroupTile e1 = store.state.findGroupTile(comment.id_group);
  if (e1 == null) return true;
  GraphTile e2 = e1.findGraphTile(comment.id_graph);

  e2.comments.removeWhere((g) => g.id == comment.id);
  store.state.groups = store.state.groups.map((e) {
    if (e.id == comment.id_group) return e1;
    return e;
  }).toList();

  return true;
}

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {

  if (next != null) next(action);

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
      _saveGraphToDB(store, action.id_group, action.graph).catchError((e) {
        action.error(FocusError(message: 'Cant add graph', error : e));
      });
      break;

    case AddGraphCommentAction:
      _saveGraphCommentToDB(store, action.graph, action.comment).catchError((e) {
        action.error(FocusError(message: 'Cant add graph comment', error : e));
      });
      break;

    case RemoveGraphCommentAction:
      _removeGraphCommentFromDB(store, action.comment);
      break;

    case DeleteGraphAction:
      _removeGraphFromDB(store, action.graph).catchError((e) {
        action.error(FocusError(message: 'Cant delete graph', error : e));
      });
      break;
  }
}
