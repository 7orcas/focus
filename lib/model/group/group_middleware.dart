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
      await _saveGroupToDB(action.group).then((result) =>
          store.dispatch(AddGroupStoreAction(GroupTile.entity(result))));
      break;

    case DeleteGroupAction:
      await _deleteGroupFromDB(action.group)
          .then((result) => store.dispatch(LoadGroupsAction()));
      break;

    case SaveGraphAction:
      _saveGraphToDB(store, action.id_group, action.graph)
          .then((result) =>
              store.dispatch(SaveGraphStoreAction(GraphTile.entity(result))))
          .catchError((e) {
        action.error(FocusError(message: 'Cant add graph', error: e));
      });
      break;

    case ToggleHighlightAction:
      _updateGraphToDB(store, action.graph);
      break;

    case SaveGraphCommentAction:
      _saveGraphCommentToDB(
              store, action.graph, action.id_comment, action.comment)
          .then((result) => store.dispatch(
              SaveGraphCommentStoreAction(CommentTile.entity(result))))
          .catchError((e) {
        action.error(FocusError(message: 'Cant add graph comment', error: e));
      });
      break;

    case DeleteGraphCommentAction:
      _deleteGraphCommentFromDB(store, action.comment)
          .then(
              (result) => store.dispatch(RemoveGraphCommentStoreAction(result)))
          .catchError((e) {
        action
            .error(FocusError(message: 'Cant delete graph comment', error: e));
      });
      break;

    case DeleteGraphAction:
      _deleteGraphFromDB(store, action.graph)
          .then((result) => store.dispatch(DeleteGraphStoreAction(result)))
          .catchError((e) {
        action.error(FocusError(message: 'Cant delete graph', error: e));
      });
      break;
  }

  if (next != null) next(action);
}

///Load all groups from the database
Future<List<GroupTile>> _loadGroupsFromDB() async {
  return await GroupDB().loadGroups();
}

Future<GroupEntity> _saveGroupToDB(GroupTile group) async {
  Util(StackTrace.current).out('groupMiddleware saveToDB');
  return GroupDB().saveGroup(group.toEntity());
}

Future<GraphEntity> _saveGraphToDB(
    Store<AppState> store, int id_group, GraphBuild graph) async {
  var entity = GraphEntity.build(graph.created, id_group, graph.toEncodedList())
    ..addEncoded(PARAM_KEY_TIME, graph.timer)
    ..addEncoded(PARAM_KEY_COUNT, graph.count);
  return await GraphDB().saveGraph(entity);
}

Future<GraphEntity> _updateGraphToDB(
    Store<AppState> store, GraphTile graph) async {
  return await GraphDB().saveGraph(graph.toEntity());
}

/// Save graph comment to database and return new entity
Future<CommentEntity> _saveGraphCommentToDB(
    Store<AppState> store, GraphTile graph, int id, String comment) async {
  var entity = CommentEntity.add(id, graph.id_group, graph.id, ID_USER_ME,
      BaseEntity.fromBoolean(true), comment)
    ..setCreated();
  return await GraphDB().saveGraphComment(entity);
}

Future<bool> _deleteGroupFromDB(GroupTile group) async {
  Util(StackTrace.current).out('removeGroupFromDB');
  GroupDB().removeGroup(group.toEntity());
  return true;
}

Future<GraphTile> _deleteGraphFromDB(
    Store<AppState> store, GraphTile graph) async {
  Util(StackTrace.current).out('removeGraphFromDB');
  await GraphDB().removeGraph(graph.id);
  return graph;
}

Future<CommentTile> _deleteGraphCommentFromDB(
    Store<AppState> store, CommentTile comment) async {
  Util(StackTrace.current).out('_removeGraphCommentFromDB');
  await GraphDB().removeGraphComment(comment.id);
  return comment;
}
