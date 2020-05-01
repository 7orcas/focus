import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:focus/database/_base.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/model/group/comment_entity.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

class GroupDB extends FocusDB {

  Future<List<GroupTile>> loadGroupTiles() async {
    await connectDatabase();
    final List<Map<String, dynamic>> list = await database.query(DB_GROUP);
    final List<GroupTile> listX = List.generate(list.length, (i) {
      return GroupTile.db(list[i]['id'], list[i]['name']);
    });
    return listX;
  }

  Future<GroupConversation> loadGroupConversation(int id) async {
    await connectDatabase();

    //Load comments
    String sql = 'SELECT * FROM ' + DB_COMMENT + " WHERE " + DBK_GROUP + " = " + id.toString();
    var result = await database.rawQuery(sql);
    List<Map<String, dynamic>> list = result.toList();
    List<CommentEntity> comments = List.generate(list.length, (i) {
      return CommentEntity.db(list[i]['id'], list[i][DBK_GROUP], list[i][DBK_GRAPH], list[i][DBK_USER], list[i]['comment']);
    });
    Util(StackTrace.current).out('loadGroupConversation ' + sql + ' count=' + comments.length.toString());

    //Load graphs
    sql = 'SELECT * FROM ' + DB_GRAPH + " WHERE " + DBK_GROUP + " = " + id.toString();
    result = await database.rawQuery(sql);
    list = result.toList();
    List<GraphEntity> graphs = List.generate(list.length, (i) {
      int id_graph = list[i]['id'];
      return GraphEntity.db(id_graph, list[i][DBK_GROUP], list[i]['graph'], comments.where((c) => c.id_graph == id_graph).toList());
    });
    Util(StackTrace.current).out('loadGroupConversation ' + sql + ' count=' + graphs.length.toString() + ' 0 comm=' +  graphs[0].comments.length.toString());

    //Load group
    sql = 'SELECT id, name, public_key, private_key FROM ' + DB_GROUP + " WHERE id = " + id.toString();
    result = await database.rawQuery(sql);
    list = result.toList();
    List<GroupConversation> groups = List.generate(list.length, (i) {
      return GroupConversation.db(list[i]['id'], list[i]['name'], list[i]['public_key'], list[i]['private_key'], graphs);
    });
    Util(StackTrace.current).out('loadGroupConversation ' + sql);



    sleep(Duration(seconds: 3));

    return groups[0];
  }

  void saveGroup(GroupEntity group) async {
    Util(StackTrace.current).out('saveGroup name=' + group.name);
    await connectDatabase();

    // The `conflictAlgorithm` in case the same entity is inserted twice.
    // In this case, replace any previous data.
    int id = await database.insert(
      DB_GROUP,
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current).out('saveGroup name=' + group.name + ' id=' + id.toString());
  }

  void removeGroup(GroupEntity group) async {
    Util(StackTrace.current).out('removeGroup name=' + group.name);
    await connectDatabase();

    int id = await database.delete(
      DB_GROUP,
      where: "id = ?",
      whereArgs: [group.id],
    );

    Util(StackTrace.current).out('removeGroup name=' + group.name + ' id=' + id.toString());
  }

}
