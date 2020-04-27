import 'package:focus/database/_scheme.dart';

// Focus client database setup

const String mock_user = "INSERT INTO " + DB_USER + "(id, email, adgj, lang) VALUES ";
const List<String> mock_insertUser = [
  "1, '123@abc.com', '123asd', 'en'",
];

const String mock_numbers = "INSERT INTO " + DB_NUMBERS + "(id, " + DBK_USER + ", number) VALUES ";
const List<String> mock_insertNumbers = [
  "1, 1, '123456'",
  "2, 1, '456789'",
];

const String mock_group = "INSERT INTO " + DB_GROUP + "(id, name) VALUES ";
const List<String> mock_insertGroup = [
  "1, 'Me'",
  "2, 'Group 1'",
  "3, 'Group 2'",
  "4, 'Group 3'",
];

const String mock_userGroup = "INSERT INTO " + DBJ_USER_GROUP + "(id, " + DBK_USER + ", " + DBK_GROUP + ", admin) VALUES ";
const List<String> mock_insertUserGroup = [
  "1, 1, 1, 1",
  "2, 1, 2, 0",
];

const String mock_graph = "INSERT INTO " + DB_GRAPH + "(id, " + DBK_GROUP + ", graph) VALUES ";
const List<String> mock_insertGraph = [
  "1, 1, 'Graph 1'",
  "2, 1, 'Graph 2'",
  "3, 2, 'Graph 1'",
];

const String mock_comment = "INSERT INTO " + DB_COMMENT + "(id, " + DBK_GROUP + ", " + DBK_GRAPH + ", " + DBK_USER + ", comment) VALUES ";
const List<String> mock_insertComment = [
  "1, 1, 1, 1, 'Comment 1-1'",
  "2, 1, 1, 1, 'Comment 1-2'",
  "3, 1, 2, 1, 'Comment 2-1'",
];


const mock_instructions = [
  mock_user, mock_insertUser,
  mock_numbers, mock_insertNumbers,
  mock_group, mock_insertGroup,
  mock_userGroup, mock_insertUserGroup,
  mock_graph, mock_insertGraph,
  mock_comment, mock_insertComment,
];


class DatabaseMockData {
  static List<String> data () {
    List<String> d = [];

    for (int x = 0; x < mock_instructions.length; x += 2){
      String sql = mock_instructions[x];
      List<String> data = mock_instructions[x+1];

      for (int i = 0; i< data.length; i++){
        d.add(sql + "(" + data[i] + ")");
      }
    }

    return d;
  }
}