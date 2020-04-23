
// Focus client database setup

final String _insertUser = "INSERT INTO user(id, lang) VALUES (1, 'en')";

final String _insertGroup = "INSERT INTO fgroup(id, name, admin) VALUES ";
final List<String> _insertIntoGroup = [
  "ID, 'Group A', 0",
  "ID, 'Group B', 1",
  "ID, 'Group C', 0",
];

class DatabaseMockData {
  static List<String> data () {
    List<String> d = [];
    d.add(_insertUser);

    for (int i = 0; i< _insertIntoGroup.length; i++){
      d.add(_insertGroup + "(" + _insertIntoGroup[i].replaceAll("ID", (i+1).toString()) + ")");
    }

    return d;
  }
}