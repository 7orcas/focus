

// Focus client database setup

final List<String> _instructions = [
  '''CREATE TABLE user (
       id INTEGER PRIMARY KEY,
       lang TEXT)''',

  '''CREATE TABLE fgroup (
       id INTEGER PRIMARY KEY,
       name TEXT, 
       admin INTEGER)''',
];


class DatabaseScheme {

  List<String> scheme () {
    return _instructions;
  }

}
