import 'package:focus/database/db_scheme.dart';

// Focus client database setup

const String _user = "INSERT INTO " + DB_USER + "(id, email, adgj, lang) VALUES ";
const List<String> _insertUser = [
  "1, '123@abc.com', '123asd', 'en'",
];

const String _numbers = "INSERT INTO " + DB_NUMBERS + "(id, id_" + DB_USER + ", number) VALUES ";
const List<String> _insertNumbers = [
  "1, 1, '123456'",
  "2, 1, '456789'",
];

const String _group = "INSERT INTO " + DB_GROUP + "(id, name) VALUES ";
const List<String> _insertGroup = [
  "1, 'Me'",
  "2, 'Group 1'",
  "3, 'Group 2'",
  "4, 'Group 3'",
];

const String _userGroup = "INSERT INTO " + DB_USER_GROUP + "(id, id_" + DB_USER + ", id_" + DB_GROUP + ", admin) VALUES ";
const List<String> _insertUserGroup = [
  "1, 1, 1, 1",
  "2, 1, 2, 0",
];

const String _graph = "INSERT INTO " + DB_GRAPH + "(id, id_" + DB_GROUP + ", graph) VALUES ";
const List<String> _insertGraph = [
  "1, 1, 'Graph 1'",
  "2, 1, 'Graph 2'",
  "3, 2, 'Graph 1'",
];

const String _comment = "INSERT INTO " + DB_COMMENT + "(id, id_" + DB_GROUP + ", id_" + DB_GRAPH + ", id_" + DB_USER + ", comment) VALUES ";
const List<String> _insertComment = [
  "1, 1, 1, 1, 'Comment 1-1'",
  "2, 1, 1, 1, 'Comment 1-2'",
  "3, 1, 2, 1, 'Comment 2-1'",
];


const _instructions = [
  _user, _insertUser,
  _numbers, _insertNumbers,
  _group, _insertGroup,
  _userGroup, _insertUserGroup,
  _graph, _insertGraph,
  _comment, _insertComment,
];


class DatabaseMockData {
  static List<String> data () {
    List<String> d = [];

    for (int x = 0; x < _instructions.length; x += 2){
      String sql = _instructions[x];
      List<String> data = _instructions[x+1];

      for (int i = 0; i< data.length; i++){
        d.add(sql + "(" + data[i] + ")");
      }
    }

    return d;
  }
}