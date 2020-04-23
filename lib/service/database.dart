import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:focus/model/data/user_entity.dart';
import 'package:focus/model/data/group_entity.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/model/data/db_scheme.dart';
import 'package:focus/model/data/db_mock_data.dart';
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


  Future<User> loadUser() async {
    util.out('loadUser');
    await _openDatabase();

    final List<Map<String, dynamic>> users = await _database.query('user');
    final List<User> list = List.generate(users.length, (i) {
      return User(users[i]['id'], users[i]['lang']);
    });

    return list[0];
  }

  Future<List<Group>> loadGroups() async {
    util.out('loadGroups');
    await _openDatabase();

    final List<Map<String, dynamic>> list = await _database.query('fgroup');
    final List<Group> listX = List.generate(list.length, (i) {
      return Group.db(list[i]['id'], list[i]['name'], list[i]['admin'] == 1);
    });

    util.out('loadGroups size=' + listX.length.toString());
    return listX;
  }

}
