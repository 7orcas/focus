import 'package:test/test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/database/_mock_data.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/model/group/group_conversation.dart';

/*
  Unit testing of database functions
  Based on https://pub.dev/packages/sqflite_common_ffi
 */

void main() {
  sqfliteFfiInit();
  var db;
  GroupDB gdb;

  Future<GroupDB> setup() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    for (String q in DatabaseScheme().scheme()) {
      db.execute(q);
    }
    for (String q in DatabaseMockData.data()) {
      db.execute(q);
    }

    gdb = GroupDB();
    gdb.setMemoryDatabase(db);

    return gdb;
  }

  test('Load group tiles', () async {
    gdb ??= await setup();
    GroupConversation c = await gdb.loadGroupConversation(1);
    expect(await c.graphs.length, mock_insertGroup.length);
  });

  test('Load first group conversation', () async {
    gdb ??= await setup();
    var count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT (*) AS x FROM ' +
            DB_GRAPH +
            ' WHERE ' +
            DBK_GROUP +
            ' = 1'));
    GroupConversation l = await gdb.loadGroupConversation(1);
    expect(await l.graphs.length, count);
  });
}
