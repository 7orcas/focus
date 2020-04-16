import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/entity/user.dart';

class FocusDB {
  Database _database = null;
  String _databasesPath = null;

//  Future<bool> _loadDatabasesPath() async {
//    _databasesPath = await getDatabasesPath();
//    return true;
//  }
//
//  Future<Database> _openAndInitDatabase() async {
//    _database = await openDatabase(
//      join(_databasesPath, 'focus.db'),
//      onCreate: (db, version) {
//        debugPrint("creating database...");
//        db.execute("CREATE TABLE user(id INTEGER PRIMARY KEY, lang TEXT)");
//        db.execute("INSERT INTO user(id, lang) VALUES (1, 'en')");
//        debugPrint("done");
//      },
//      version: 1,
//    ).then((value) { return _database;});
//
//  }

  Future<User> loadUser() async {
    debugPrint('*** load');
    _databasesPath = await getDatabasesPath();
    debugPrint('*** _databasesPath=' + _databasesPath.toString());
    _database = await openDatabase(
      join(_databasesPath, 'focus.db'),
      onCreate: (db, version) {
        debugPrint("creating database...");
        db.execute("CREATE TABLE user(id INTEGER PRIMARY KEY, lang TEXT)");
        db.execute("INSERT INTO user(id, lang) VALUES (1, 'en')");
        debugPrint("done");
      },
      version: 1,
    );
    debugPrint('*** _database=' + _database.toString());

    final List<Map<String, dynamic>> users = await _database.query('user');
    debugPrint('*** users=' + users.toString());

    final List<User> list = List.generate(users.length, (i) {
      return User(users[i]['id'], users[i]['lang']);
    });

    return list[0];
  }


}