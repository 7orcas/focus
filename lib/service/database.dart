import 'package:flutter/material.dart';
import 'package:focus/bloc/session_bloc.dart';
import 'package:focus/bloc/session_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/entity/user.dart';

// Database Methods
// ToDo

class FocusDB {
  Database _database = null;
  String _databasesPath = null;
  SessionBloc _bloc;

  FocusDB (BuildContext context){
    _bloc = SessionProvider.of(context);
  }

  Future<User> loadUser() async {
    debugPrint('*** load user, _databasesPath=' +
        (_databasesPath != null ? _databasesPath.toString() : 'null'));
    _databasesPath ??= await getDatabasesPath();
    _database ??= await openDatabase(
      join(_databasesPath, 'focus.db'),
      onCreate: (db, version) {
        debugPrint("creating database...");
        db.execute("CREATE TABLE user(id INTEGER PRIMARY KEY, lang TEXT)");
        db.execute("INSERT INTO user(id, lang) VALUES (1, 'en')");
        debugPrint("done");
      },
      version: 1,
    );

    final List<Map<String, dynamic>> users = await _database.query('user');
    final List<User> list = List.generate(users.length, (i) {
      return User(users[i]['id'], users[i]['lang']);
    });

    _bloc.initialise(list[0]);

    return list[0];
  }
}
