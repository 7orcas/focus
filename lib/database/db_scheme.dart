

// Focus client database setup

const String DB_USER = 'user';
const String DB_NUMBERS = 'numbers';
const String DB_GROUP = 'fgroup';
const String DB_USER_GROUP = 'user_fgroup';
const String DB_GRAPH = 'graph';
const String DB_COMMENT = 'comment';

const List<String> _tables = [
 'DB_USER',        DB_USER,
 'DB_NUMBERS',     DB_NUMBERS,
 'DB_GROUP',       DB_GROUP,
 'DBJ_USER_GROUP', DB_USER_GROUP,
 'DB_GRAPH',       DB_GRAPH,
 'DB_COMMENT',     DB_COMMENT,
];

const List<String> _instructions = [
  '''
  CREATE TABLE DB_USER (
    id INTEGER NOT NULL PRIMARY KEY,
    email TEXT,
    adgj TEXT, 
    lang TEXT
    )''',

  '''
  CREATE TABLE DB_NUMBERS (
    id INTEGER NOT NULL PRIMARY KEY,
    id_DB_USER INTEGER,
    number INTEGER,
    FOREIGN KEY(id_DB_USER) REFERENCES DB_USER(id)
    )''',

  '''
  CREATE TABLE DB_GROUP (
    id INTEGER PRIMARY KEY,
    name TEXT
    )''',

  '''
  CREATE TABLE DBJ_USER_GROUP (
    id INTEGER PRIMARY KEY,
    id_DB_USER INTEGER,
    id_DB_GROUP INTEGER,
    admin INTEGER,
    FOREIGN KEY(id_DB_USER) REFERENCES DB_USER(id),
    FOREIGN KEY(id_DB_GROUP) REFERENCES DB_GROUP(id)
    )''',


  '''
  CREATE TABLE DB_GRAPH (
    id INTEGER PRIMARY KEY,
    id_DB_GROUP INTEGER,
    graph TEXT, 
    FOREIGN KEY(id_DB_GROUP) REFERENCES DB_GROUP(id)
    )''',

  '''
  CREATE TABLE DB_COMMENT (
    id INTEGER PRIMARY KEY,
    id_DB_GROUP INTEGER,
    id_DB_GRAPH INTEGER,
    id_DB_USER INTEGER,
    comment TEXT, 
    FOREIGN KEY(id_DB_GROUP) REFERENCES DB_GROUP(id),
    FOREIGN KEY(id_DB_GRAPH) REFERENCES DB_GRAPH(id),
    FOREIGN KEY(id_DB_USER) REFERENCES DB_USER(id)
    )''',

];


class DatabaseScheme {

  List<String> scheme () {
    List<String> x = [];

    for (String sql in _instructions){
      for (int x = 0; x < _tables.length; x += 2) {
        String code = _tables[x];
        String name = _tables[x+1];
        sql = sql.replaceAll(code, name);
      }
      x.add(sql);
    }

    return x;
  }

}
