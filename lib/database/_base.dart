import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/model/data/db_scheme.dart';
import 'package:focus/model/data/db_mock_data.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo


class FocusDB {
  Database _database = null;
  String _databasesPath = null;

  _FocusDB (){}

  Database get database => _database;

  void connectDatabase () async {
    _databasesPath ??= await getDatabasesPath();

    Util(StackTrace.current).out('_openDatabase  _databasesPath=' +
        (_databasesPath != null ? _databasesPath.toString() : 'null'));

    _database ??= await openDatabase(
      join(_databasesPath, 'focus.db'),
      onCreate: (db, version) {
        Util(StackTrace.current).out("creating database...");

        for (String q in DatabaseScheme().scheme()){
          db.execute(q);
        }

        for (String q in DatabaseMockData.data()){
          db.execute(q);
        }

      },
      version: 1,
    );
  }

}
