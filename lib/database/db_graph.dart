import 'package:sqflite/sqflite.dart';
import 'package:focus/database/_base.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/model/group/graph/graph_entity.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

class GraphDB extends FocusDB {

  void saveGraph(GraphEntity graph) async {
    Util(StackTrace.current).out('saveGraph id=' + graph.id.toString());
    await connectDatabase();

    // The `conflictAlgorithm` in case the same entity is inserted twice.
    // In this case, replace any previous data.
    int id = await database.insert(
      DB_GRAPH,
      graph.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current).out('saveGraph id=' + id.toString());
  }


}