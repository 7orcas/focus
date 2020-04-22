import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/entity/user.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

final util = Util(StackTrace.current);

class FocusDB {
  Database _database = null;
  String _databasesPath = null;

  FocusDB (){
//    _openDatabase ();
  }

  void _openDatabase () async {
    _databasesPath ??= await getDatabasesPath();

    util.out('_openDatabase  _databasesPath=' +
        (_databasesPath != null ? _databasesPath.toString() : 'null'));

    _database ??= await openDatabase(
      join(_databasesPath, 'focus.db'),
      onCreate: (db, version) {
        util.out("creating database...");
        db.execute("CREATE TABLE user(id INTEGER PRIMARY KEY, lang TEXT)");
        db.execute("INSERT INTO user(id, lang) VALUES (1, 'en')");

        db.execute("CREATE TABLE fgroup(id INTEGER PRIMARY KEY, name TEXT, admin INTEGER)");
        db.execute("INSERT INTO fgroup(id, name, admin) VALUES (1, 'group1', 0)");
        db.execute("INSERT INTO fgroup(id, name, admin) VALUES (2, 'group2', 1)");
        db.execute("INSERT INTO fgroup(id, name, admin) VALUES (3, 'group3', 0)");

        util.out("done");
      },
      version: 1,
    );
  }


  Future<User> loadUser() async {
    util.out('loadUser');
//    _databasesPath ??= await getDatabasesPath();
//    _openDatabase();

    final List<Map<String, dynamic>> users = await _database.query('user');
    final List<User> list = List.generate(users.length, (i) {
      return User(users[i]['id'], users[i]['lang']);
    });

    return list[0];
  }

  Future<List<Group>> loadGroups() async {
    util.out('loadGroups');
//    _databasesPath ??= await getDatabasesPath();
    await _openDatabase();

    final List<Map<String, dynamic>> list = await _database.query('fgroup');
    final List<Group> listX = List.generate(list.length, (i) {
      return Group.db(list[i]['id'], list[i]['name'], list[i]['admin'] == 1);
    });

    util.out('loadGroups size=' + listX.length.toString());
    return listX;
  }

}
