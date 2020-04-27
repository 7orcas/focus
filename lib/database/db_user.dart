import 'package:focus/database/_base.dart';
import 'package:focus/model/user/user_entity.dart';
import 'package:focus/service/util.dart';

// Database Methods
// ToDo

class UserDB extends FocusDB {


  Future<User> loadUser() async {
    Util(StackTrace.current).out('loadUser');
    await connectDatabase();

    final List<Map<String, dynamic>> users = await database.query('user');
    final List<User> list = List.generate(users.length, (i) {
      return User(users[i]['id'], users[i]['lang']);
    });

    return list[0];
  }

}