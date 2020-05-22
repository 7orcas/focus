import 'package:focus/model/app/system_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/database/_mock_data.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

class FocusDB {
  Database _database = null;
  String _databasesPath = null;
  static SystemEntity _system = null;

  Database get database => _database;
  SystemEntity get system => _system;

  // for unit testing
  void setMemoryDatabase(var db) {
    _databasesPath = '';
    _database = db;
  }

  void connectDatabase() async {
    _databasesPath ??= await getDatabasesPath();

    Util(StackTrace.current).out('_openDatabase  _databasesPath=' +
        (_databasesPath != null ? _databasesPath.toString() : 'null'));

    _database ??= await openDatabase(
      join(_databasesPath, 'focus.db'),
      onCreate: (db, version) {
        Util(StackTrace.current).out("creating database...");

        for (String q in DatabaseScheme.scheme()) {
          db.execute(q);
        }
        for (String q in DatabaseScheme.data()) {
          db.execute(q);
        }
        for (String q in DatabaseMockData.data()) {
          db.execute(q);
        }
      },
      version: 1,
    );

    //Get system
    if (_system == null) {
      var result = await _database
          .rawQuery('SELECT * FROM ' + DB_SYSTEM + ' WHERE id = 1');
      List<Map<String, dynamic>> list = result.toList();
      List<SystemEntity> e = List.generate(list.length, (i) {
        return SystemEntity(
            list[i]['id'], list[i]['version'], list[i]['public_key']);
      });
      _system = e[0];

      //Patch example
//      if (_system.version < 2) {
//        _system.version = 2;
//        await _database.execute('ALTER TABLE ' + DB_SYSTEM + ' ADD COLUMN lang TEXT DEFAULT \'en\'');
//        await _database.execute('UPDATE ' + DB_SYSTEM + ' SET version = 2 WHERE id = 1');
//      }

    }

    Util(StackTrace.current)
        .out('Database  system.version=' + _system.version.toString());

    _database.execute("PRAGMA foreign_keys=ON");
  }

  DateTime dateTime(int ms) {
    if (ms == null) ms = 0;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }


}
