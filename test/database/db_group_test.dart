import 'package:focus/model/group/group_entity.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:test/test.dart';
import 'package:sqflite/sqflite.dart';
import './base.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/database/_mock_data.dart';
import 'package:focus/database/db_group.dart';

/*
  Unit testing of database functions
  Based on https://pub.dev/packages/sqflite_common_ffi
 */

void main() {
  DB_TEST dbx = DB_TEST();
  GroupDB gdb;

  Future<GroupDB> setup() async {
    return await dbx.setup(GroupDB());
  }

  test('Load group tiles', () async {
    gdb ??= await setup();
    GroupEntity c = await gdb.loadGroupConversation(1);
    expect(await c.graphs.length, mock_insertGroup.length);
  });

  test('Load first group conversation', () async {
    gdb ??= await setup();
    var count = Sqflite.firstIntValue(await dbx.db.rawQuery(
        'SELECT COUNT (*) AS x FROM ' +
            DB_GRAPH +
            ' WHERE ' +
            DBK_GROUP +
            ' = 1'));
    GroupEntity t = await gdb.loadGroupConversation(1);
    expect(await t.graphs.length, count);
  });
}
