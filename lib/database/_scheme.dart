

// Focus client database setup

const String DB_USER = 'user';
const String DBK_USER = 'id_user';
const String DB_NUMBERS = 'numbers';
const String DB_GROUP = 'fgroup';
const String DBK_GROUP = 'id_fgroup';
const String DBJ_USER_GROUP = 'user_fgroup';
const String DB_GRAPH = 'graph';
const String DBK_GRAPH = 'id_graph';
const String DB_COMMENT = 'comment';

const List<String> _encoding = [
  'DB_USER',        DB_USER,
  'DBK_USER',       DBK_USER,
  'DB_NUMBERS',     DB_NUMBERS,
  'DB_GROUP',       DB_GROUP,
  'DBK_GROUP',      DBK_GROUP,
  'DBJ_USER_GROUP', DBJ_USER_GROUP,
  'DB_GRAPH',       DB_GRAPH,
  'DBK_GRAPH',      DBK_GRAPH,
  'DB_COMMENT',     DB_COMMENT,
];

const List<String> _instructions = [
  '''
  CREATE TABLE DB_USER (
    id INTEGER NOT NULL PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    number INTEGER,
    email TEXT,
    adgj TEXT, 
    lang TEXT
    )''',

  '''
  CREATE TABLE DB_GROUP (
    id INTEGER PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    name TEXT,
    public_key TEXT,
    private_key TEXT
    )''',

  '''
  CREATE TABLE DBJ_USER_GROUP (
    id INTEGER PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    DBK_USER INTEGER,
    DBK_GROUP INTEGER,
    admin INTEGER,
    FOREIGN KEY(DBK_USER) REFERENCES DB_USER(id),
    FOREIGN KEY(DBK_GROUP) REFERENCES DB_GROUP(id)
    )''',


  '''
  CREATE TABLE DB_GRAPH (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    DBK_GROUP INTEGER,
    graph TEXT, 
    FOREIGN KEY(DBK_GROUP) REFERENCES DB_GROUP(id)
    )''',

  '''
  CREATE TABLE DB_COMMENT (
    id INTEGER PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    DBK_GROUP INTEGER,
    DBK_GRAPH INTEGER,
    DBK_USER INTEGER,
    comment TEXT, 
    FOREIGN KEY(DBK_GROUP) REFERENCES DB_GROUP(id),
    FOREIGN KEY(DBK_GRAPH) REFERENCES DB_GRAPH(id),
    FOREIGN KEY(DBK_USER) REFERENCES DB_USER(id)
    )''',

];


class DatabaseScheme {

  List<String> scheme () {
    List<String> x = [];

    for (String sql in _instructions){
      for (int x = 0; x < _encoding.length; x += 2) {
        String code = _encoding[x];
        String name = _encoding[x+1];
        sql = sql.replaceAll(code, name);
      }
      x.add(sql);
    }

    return x;
  }

}
