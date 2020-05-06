import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:focus/database/_scheme.dart';
import 'package:focus/database/_mock_data.dart';


class DB_TEST {
  var db;

  Future<T> setup<T>(dbx) async {
    sqfliteFfiInit();

    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    for (String q in DatabaseScheme().scheme()) {
      db.execute(q);
    }
    for (String q in DatabaseMockData.data()) {
      db.execute(q);
    }

    dbx.setMemoryDatabase(db);
    return dbx;
  }

}
