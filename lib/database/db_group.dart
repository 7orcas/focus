import 'package:focus/database/_base.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/model/data/group_entity.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

class GroupDB extends FocusDB {

  Future<List<Group>> loadGroups() async {
    Util(StackTrace.current).out('loadGroups');
    await connectDatabase();

    final List<Map<String, dynamic>> list = await database.query('fgroup');
    final List<Group> listX = List.generate(list.length, (i) {
      return Group.db(list[i]['id'], list[i]['name'], list[i]['admin'] == 1);
    });

    Util(StackTrace.current).out('loadGroups size=' + listX.length.toString());
    return listX;
  }

  void saveGroup(GroupEntity group) async {
    Util(StackTrace.current).out('saveGroup name=' + group.name);
    await connectDatabase();

    // The `conflictAlgorithm` in case the same entity is inserted twice.
    // In this case, replace any previous data.
    int id = await database.insert(
      'fgroup',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Util(StackTrace.current).out('saveGroup name=' + group.name + ' id=' + id.toString());
  }

  void removeGroup(GroupEntity group) async {
    Util(StackTrace.current).out('removeGroup name=' + group.name);
    await connectDatabase();

    int id = await database.delete(
      'fgroup',
      where: "id = ?",
      whereArgs: [group.id],
    );

    Util(StackTrace.current).out('removeGroup name=' + group.name + ' id=' + id.toString());
  }

}
