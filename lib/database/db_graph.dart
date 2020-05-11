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
    int id = await database.insert(
      DB_GRAPH,
      graph.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current).out('saveGraph saved id=' + id.toString());
    return graph.copyWith(id);
  }

  void removeGraph(int id_graph) async {
    Util(StackTrace.current).out('removeGraph id=' + id_graph.toString());

    List<String> sql = [
      'DELETE FROM ' + DB_COMMENT + ' WHERE ' + DBK_GRAPH + ' = ' + id_graph.toString(),
      'DELETE FROM ' + DB_GRAPH + ' WHERE id = ' + id_graph.toString()];

    await connectDatabase();
    for (String s in sql){
      await database.execute(s).catchError((e) {
        Util(StackTrace.current).out('removeGraph ERROR:' + e.toString());
        throw e;
      });
    }
  }
}
