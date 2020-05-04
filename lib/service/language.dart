
const String LANG_ENGLISH = 'en';
const String LANG_MAORI = 'mi';
const String LANG_GERMAN = 'de';


class Language  {
  final String _code;
  Map <String, String> _map;

  Language (this._code) {

    switch(_code){
      case LANG_MAORI :
        _map = _listToMap(_mi);
        break;
      case LANG_GERMAN :
        _map = _listToMap(_de);
        break;
      default :
        _map = _listToMap(_en);
    }

    //English is default
    if (_code != LANG_ENGLISH){
      Map <String, String> d = _listToMap(_en);
      d.addAll(_map);
      _map = d;
    }
  }

  Map <String, String> _listToMap (List<Lang> l){
    return Map.fromIterable(l, key: (e) => e.key, value: (e) => e.label);
  }

  String label (String key) {
    if (key == null) return 'NUll';
    if (_map.containsKey(key)) return _map[key];
    return '[' + key + ']:' + _code;
  }

}

class Lang {
  final String key;
  final String label;
  String mi;
  String de;
  //Maori and German are optional
  Lang(this.key, this.label , { this.mi, this.de });
}

List<Lang> _en = [
  Lang('Lang', 'Language'),
  Lang('Error', 'Error, damn'),
  Lang('AddGroup', 'Add Group', mi:'Add Group Maori', de:'Add Group Deutsch'),
  Lang('DelGroups', 'Delete Groups'),

  //Unit test code
  Lang('UTCode1', 'Unit Test Code 1'),
  Lang('UTCode2', 'Unit Test Code 2'),
];

List<Lang> _mi = [
  Lang('DelGroups', 'Delete Groups Maori'),

  //Unit test code
  Lang('UTCode1', 'Unit Test Code 1 Maori'),
];

List<Lang> _de = [
  Lang('Lang', 'Sprache'),
  Lang('DelGroups', 'Loschen Gruppen Deutsch'),
];
