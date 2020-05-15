import 'package:redux/redux.dart';
import 'package:focus/service/error.dart';
import 'package:focus/service/util.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/database/db_graph.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/base_entity.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_actions.dart';

///Database actions

void groupStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {

  switch (action.runtimeType) {
    case LoadGroupsAction:
      await _loadGroupsFromDB()
          .then((result) => store.dispatch(LoadGroupsStoreAction(result)));
      break;

    case AddGroupAction:
      await _saveGroupToDB(action.group)
          .then((result) => store.dispatch(AddGroupStoreAction(GroupTile.entity(result))));
      break;

    case RemoveGroupAction:
      await _removeGroupFromDB(action.group)
          .then((result) => store.dispatch(LoadGroupsAction()));
      break;

    case SaveGraphAction:
      _saveGraphToDB(store, action.id_group, action.graph).catchError((e) {
        action.error(FocusError(message: 'Cant add graph', error: e));
      });
      break;

    case AddGraphCommentAction:
      _saveGraphCommentToDB(
              store, action.graph, action.id_comment, action.comment)
          .then((entity) => _storeGraphComment(store, action.graph, entity))
          .catchError((e) {
        action.error(FocusError(message: 'Cant add graph comment', error: e));
      });
      action.graph.editClear();
      break;

    case RemoveGraphCommentAction:
      _removeGraphCommentFromDB(store, action.comment);
      break;

    case DeleteGraphAction:
      _removeGraphFromDB(store, action.graph).catchError((e) {
        action.error(FocusError(message: 'Cant delete graph', error: e));
      });
      break;
  }

  if (next != null) next(action);
}

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

///Load all groups from the database
Future<List<GroupTile>> _loadGroupsFromDB() async {
  List<GroupEntity> list = await GroupDB().loadGroups();
  return list.map((g) => GroupTile.entity(g)).toList();
}

Future<GroupEntity> _saveGroupToDB(GroupTile group) async {
  Util(StackTrace.current).out('groupMiddleware saveToDB');
  return GroupDB().saveGroup(group.toEntity());
}

Future<bool> _saveGraphToDB(
    Store<AppState> store, int id_group, GraphBuild graph) async {
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

Future<CommentEntity> _saveGraphCommentToDB(
    Store<AppState> store, GraphTile graph, int id, String comment) async {
  Util(StackTrace.current).out('saveToDB graph comment');

  //Save to DB
  var entity = CommentEntity(id, graph.id_group, graph.id, ID_USER_ME, comment,
      BaseEntity.fromBoolean(true));
  entity = await GraphDB().saveGraphComment(entity);

  //Add back to store ToDo move to reducer
//  var e1 = store.state.findGroupTile(graph.id_group);
//  if (e1 == null) return false;
//  var e2 = e1.findGraphTile(graph.id);
//  e2.comments.add(CommentTile.entity(entity));
//
//  store.state.groups = store.state.groups.map((e) {
//    if (e.id == graph.id_group) return e1;
//    return e;
//  }).toList();

  return entity;
}

Future<bool> _removeGroupFromDB(GroupTile group) async {
  Util(StackTrace.current).out('removeGroupFromDB');
  GroupDB().removeGroup(group.toEntity());
  return true;
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

Future<bool> _removeGraphCommentFromDB(
    Store<AppState> store, CommentTile comment) async {
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

void _storeGraphComment(
    Store<AppState> store, GraphTile graph, CommentEntity entity) {
  Util(StackTrace.current).out('store graph comment');

  var e1 = store.state.findGroupTile(graph.id_group);
  if (e1 == null) return;

  bool found = false;

  for (int i = 0; i < graph.comments.length; i++) {
    CommentTile c = graph.comments[i];
    if (c.id == entity.id) {
      found = true;
      graph.comments[i] = CommentTile.entity(entity);
      break;
    }
  }
  if (!found) {
    graph.comments.add(CommentTile.entity(entity));
  }

  store.state.groups = store.state.groups.map((e) {
    if (e.id == graph.id_group) return e1;
    return e;
  }).toList();
}
