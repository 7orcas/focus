import 'package:focus/model/group/comment/comment_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/database/_base.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

class GraphDB extends FocusDB {
  Future<GraphEntity> saveGraph(GraphEntity graph) async {
    Util(StackTrace.current).out('saveGraph id=' + graph.id.toString());
    await connectDatabase();

    // The `conflictAlgorithm` in case the same entity is inserted twice.
    // In this case, replace any previous data.
    if (graph.id != null){
      graph.setCreated();
    }

    int id = await database.insert(
      DB_GRAPH,
      graph.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current).out('saveGraph saved id=' + id.toString());
    return graph.copyWith(id, graph.created);
  }

  Future<CommentEntity> saveGraphComment(CommentEntity comment) async {
    Util(StackTrace.current).out('saveGraphComment id=' + Util.id(comment.id));
    await connectDatabase();

    // The `conflictAlgorithm` in case the same entity is inserted twice.
    // In this case, replace any previous data.
    comment.setCreated();
    int id = await database.insert(
      DB_COMMENT,
      comment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current).out('saveGraphComment saved id=' + id.toString());
    return comment.copyWith(id, comment.created);
  }

  void removeGraph(int id_graph) async {
    Util(StackTrace.current).out('removeGraph id=' + id_graph.toString());

    List<String> sql = [
      'DELETE FROM ' +
          DB_COMMENT +
          ' WHERE ' +
          DBK_GRAPH +
          ' = ' +
          id_graph.toString(),
      'DELETE FROM ' + DB_GRAPH + ' WHERE id = ' + id_graph.toString()
    ];

    await connectDatabase();
    for (String s in sql) {
      await database.execute(s).catchError((e) {
        Util(StackTrace.current).out('removeGraph ERROR:' + e.toString());
        throw e;
      });
    }
  }

  void removeGraphComment(int id_comment) async {
    Util(StackTrace.current)
        .out('removeGraphComment id=' + id_comment.toString());

    List<String> sql = [
      'DELETE FROM ' + DB_COMMENT + ' WHERE id = ' + id_comment.toString()
    ];

    await connectDatabase();
    for (String s in sql) {
      await database.execute(s).catchError((e) {
        Util(StackTrace.current)
            .out('removeGraphComment ERROR:' + e.toString());
        throw e;
      });
    }
  }
}
