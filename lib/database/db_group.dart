import 'dart:async';
import 'dart:io';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/database/_base.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo refactor

class GroupDB extends FocusDB {

  Future<List<GroupTile>> loadGroups() async {
    await connectDatabase();

    //Load groups
    String sql = 'SELECT g.id, g.created_ms, g.name, g.public_key, g.private_key FROM ' +
        DB_GROUP + ' g';

    var result = await database.rawQuery(sql);
    List<Map<String, dynamic>> list = result.toList();
    final List<GroupTile> groups = List.generate(list.length, (i) {
      return GroupTile(
          id: list[i]['id'],
          created: dateTime(list[i]['created_ms']),
          name: list[i]['name'],
          publicKey: list[i]['public_key'],
          privateKey: list[i]['private_key'],
          graphs: null,
          unreadComments: 0);
    });

    //Load last graph
    sql = 'SELECT t.' + DBK_GROUP + ' AS id, t.created_ms AS created ' +
        'FROM ' + DB_GRAPH + ' t ' +
        'INNER JOIN (' +
            'SELECT ' + DBK_GROUP + ', MAX(created_ms) AS max_date ' +
            'FROM ' + DB_GRAPH + ' ' +
            'GROUP BY ' + DBK_GROUP + ' ' +
        ') tm on t.' + DBK_GROUP + ' = tm.' + DBK_GROUP + ' ' +
        'AND t.created_ms = tm.max_date';

    result = await database.rawQuery(sql);
    list = result.toList();
    list.forEach((row) {
      for (GroupTile g in groups){
        if (g.id == row['id']) g.lastGraph = dateTime(row['created']);
      }
    });

    //Load comments
    sql = 'SELECT c.' + DBK_GROUP + ' AS id, COUNT(c.id) AS count FROM ' +
        DB_COMMENT + ' c WHERE comment_read = 1 ' +
        'GROUP BY c.' + DBK_GROUP;

    result = await database.rawQuery(sql);
    list = result.toList();
    list.forEach((row) {
      for (GroupTile g in groups){
        if (g.id == row['id']) g.unreadComments = row['count'] ?? 0;
      }
    });

    return groups;
  }

  Future<GroupTile> loadGroupConversation(int id) async {
//    final stopwatch = Stopwatch()..start();
    Util(StackTrace.current).out('loadGroupConversation start SLEEP(3)');

    await connectDatabase();

    //Load comments
    String sql = 'SELECT * FROM ' +
        DB_COMMENT +
        " WHERE " +
        DBK_GROUP +
        " = " +
        id.toString();
    var result = await database.rawQuery(sql);
    List<Map<String, dynamic>> list = result.toList();
    List<CommentEntity> comments = List.generate(list.length, (i) {
      return CommentEntity(
          list[i]['id'],
          dateTime(list[i]['created_ms']),
          list[i][DBK_GROUP],
          list[i][DBK_GRAPH],
          list[i][DBK_USER],
          list[i]['comment'],
          list[i]['comment_read']);
    });

    Util(StackTrace.current).out('loadGroupConversation ' +
        sql +
        ' count=' +
        comments.length.toString());

    //Load graphs
    sql = 'SELECT * FROM ' +
        DB_GRAPH +
        " WHERE " +
        DBK_GROUP +
        " = " +
        id.toString();
    result = await database.rawQuery(sql);
    list = result.toList();

    List<GraphTile> graphs = List.generate(list.length, (i) {
      int id_graph = list[i]['id'];
      List<CommentEntity> commentsE =
          comments.where((c) => c.id_graph == id_graph).toList();
      List<CommentTile> commentsT =
          commentsE.map((e) => CommentTile.entity(e)).toList();

      return GraphTile(
          id_graph, dateTime(list[i]['created_ms']), list[i][DBK_GROUP], list[i]['graph'], commentsT);
    });

    //Load group
    sql = 'SELECT id, name, public_key, private_key FROM ' +
        DB_GROUP +
        " WHERE id = " +
        id.toString();
    result = await database.rawQuery(sql);
    list = result.toList();
    List<GroupTile> groups = List.generate(list.length, (i) {
      return GroupTile(
          id: list[i]['id'],
          name: list[i]['name'],
          publicKey: list[i]['public_key'],
          privateKey: list[i]['private_key'],
          graphs: graphs);
    });
    Util(StackTrace.current).out('loadGroupConversation ' + sql);

    sleep(Duration(seconds: 3));

    return groups[0];
  }

  Future<GroupEntity> saveGroup(GroupEntity group) async {
    Util(StackTrace.current).out('saveGroup name=' + group.name);
    await connectDatabase();

    // The `conflictAlgorithm` in case the same entity is inserted twice.
    // In this case, replace any previous data.
    group.setCreated();
    int id = await database.insert(
      DB_GROUP,
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current)
        .out('saveGroup name=' + group.name + ' id=' + id.toString());
    return GroupEntity(id, group.created, group.name);
  }

  void removeGroup(GroupEntity group) async {
    Util(StackTrace.current).out('removeGroup name=' + group.name);
    await connectDatabase();

    int id = await database.delete(
      DB_GROUP,
      where: "id = ?",
      whereArgs: [group.id],
    );

    Util(StackTrace.current)
        .out('removeGroup name=' + group.name + ' id=' + id.toString());
  }
}
