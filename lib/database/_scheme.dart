
// Focus client database setup

const String DB_SYSTEM = 'focus';
const String DB_USER = 'user';
const String DBK_USER = 'id_user';
const String DB_GROUP = 'fgroup';
const String DBK_GROUP = 'id_fgroup';
const String DBJ_USER_GROUP = 'user_fgroup';
const String DB_GRAPH = 'graph';
const String DBK_GRAPH = 'id_graph';
const String DB_COMMENT = 'comment';

const List<String> tables = [
  'DB_SYSTEM',      DB_SYSTEM,
  'DB_USER',        DB_USER,
  'DB_GROUP',       DB_GROUP,
  'DBJ_USER_GROUP', DBJ_USER_GROUP,
  'DB_GRAPH',       DB_GRAPH,
  'DB_COMMENT',     DB_COMMENT,
];

//ToDo add spread
const List<String> _keys = [
  'DBK_USER',       DBK_USER,
  'DBK_GROUP',      DBK_GROUP,
  'DBK_GRAPH',      DBK_GRAPH,
];


const List<String> _instructions = [
  '''
  CREATE TABLE IF NOT EXISTS DB_SYSTEM (
    id INTEGER NOT NULL PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    version INTEGER DEFAULT 1,
    public_key TEXT,
    lang TEXT DEFAULT 'en'
    )''',

  '''
  CREATE TABLE IF NOT EXISTS DB_USER (
    id INTEGER NOT NULL PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    number INTEGER,
    email TEXT,
    adgj TEXT, 
    lang TEXT
    )''',

  '''
  CREATE TABLE IF NOT EXISTS DB_GROUP (
    id INTEGER PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    name TEXT,
    public_key TEXT,
    private_key TEXT
    )''',

  '''
  CREATE TABLE IF NOT EXISTS DBJ_USER_GROUP (
    id INTEGER PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    DBK_USER INTEGER,
    DBK_GROUP INTEGER,
    admin INTEGER,
    
    CONSTRAINT fk_DB_GROUP
    FOREIGN KEY (DBK_GROUP)
    REFERENCES DB_GROUP (id),
    
    CONSTRAINT fk_DB_USER
    FOREIGN KEY (DBK_USER)
    REFERENCES DB_USER (id)
    )''',


  '''
  CREATE TABLE IF NOT EXISTS DB_GRAPH (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    DBK_GROUP INTEGER,
    graph TEXT, 
    
    CONSTRAINT fk_DB_GROUP
    FOREIGN KEY (DBK_GROUP)
    REFERENCES DB_GROUP (id)
    )''',

  '''
  CREATE TABLE IF NOT EXISTS DB_COMMENT (
    id INTEGER PRIMARY KEY,
    created DATETIME DEFAULT CURRENT_TIMESTAMP,
    encoded TEXT,
    DBK_GROUP INTEGER,
    DBK_GRAPH INTEGER,
    DBK_USER INTEGER,
    comment TEXT, 
    comment_read INTEGER DEFAULT 0,

    CONSTRAINT fk_DB_GROUP
    FOREIGN KEY (DBK_GROUP)
    REFERENCES DB_GROUP (id),

    CONSTRAINT fk_DB_GRAPH
    FOREIGN KEY (DBK_GRAPH)
    REFERENCES DB_GRAPH (id),

    CONSTRAINT fk_DB_USER
    FOREIGN KEY (DBK_USER)
    REFERENCES DB_USER (id)
    )''',

];


const String _system = "INSERT INTO " + DB_SYSTEM + "(id, version, public_key) VALUES ";
const List<String> _insertSystem = [
  "1, 1, 'xyz'",
];
const _data = [_system, _insertSystem];


class DatabaseScheme {

  static List<String> scheme () {
    List<String> x = [];

    for (String sql in _instructions){
      for (int x = 0; x < tables.length; x += 2) {
        String code = tables[x];
        String name = tables[x+1];
        sql = sql.replaceAll(code, name);
      }

      for (int x = 0; x < _keys.length; x += 2) {
        String code = _keys[x];
        String name = _keys[x+1];
        sql = sql.replaceAll(code, name);
      }
      x.add(sql);
    }

    return x;
  }

  static List<String> data () {
    List<String> d = [];

    for (int x = 0; x < _data.length; x += 2){
      String sql = _data[x];
      List<String> data = _data[x+1];

      for (int i = 0; i< data.length; i++){
        d.add(sql + "(" + data[i] + ")");
      }
    }
    return d;
  }

}
