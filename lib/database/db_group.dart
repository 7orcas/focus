import 'package:focus/database/_base.dart';
import 'package:focus/model/group/comment_entity.dart';
import 'package:focus/model/group/graph_entity.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/database/db_scheme.dart';
import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
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
    var result = await database.rawQuery('SELECT * FROM ' + DB_COMMENT + " WHERE id_fgroup = " + id.toString());
    List<Map<String, dynamic>> list = result.toList();
    List<CommentEntity> comments = List.generate(list.length, (i) {
      return CommentEntity.db(list[i]['id'], list[i]['id_fgroup'], list[i]['id_graph'], list[i]['id_user'], list[i]['comment']);
    });

    //Load graphs
    result = await database.rawQuery('SELECT * FROM ' + DB_GRAPH + " WHERE id_fgroup = " + id.toString());
    list = result.toList();
    List<GraphEntity> graphs = List.generate(list.length, (i) {
      int id_graph = list[i]['id'];
      return GraphEntity.db(id_graph, list[i]['id_fgroup'], list[i]['graph'], comments.where((c) => c.id_graph == id_graph).toList());
    });

    //Load group
    result = await database.rawQuery('SELECT id, name FROM ' + DB_GROUP + " WHERE id = " + id.toString());
    list = result.toList();
    List<GroupConversation> groups = List.generate(list.length, (i) {
      return GroupConversation.db(list[i]['id'], list[i]['name'], graphs);
    });

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
