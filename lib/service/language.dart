
const String LANG_ENGLISH = 'en';
const String LANG_MAORI = 'mi';
const String LANG_GERMAN = 'de';

const String LANG_DEFAULT = LANG_ENGLISH;

class Language  {
  final String _langCode;
  Map <String, String> _map;

  Language (this._langCode) {

    switch(_langCode){
      case LANG_MAORI :
        Map <String, String> mapX = Map.fromIterable(_en, key: (e) => e.key, value: (e) => e.mi);
        _map = _listToMap(_mi, mapX);
        break;
      case LANG_GERMAN :
        Map <String, String> mapX = Map.fromIterable(_en, key: (e) => e.key, value: (e) => e.de);
        _map = _listToMap(_de, mapX);
        break;
      default :
        _map = _listToMap(_en, null);
    }

    //English is default
    if (_langCode != LANG_ENGLISH){
      Map <String, String> d = _listToMap(_en, null);
      d.addAll(_map);
      _map = d;
    }
  }

  Map <String, String> _listToMap (List<LangLabel> l, Map <String, String> mapX){
    Map <String, String> map = Map.fromIterable(l, key: (e) => e.key, value: (e) => e.label);
    if (mapX != null){
      mapX.removeWhere((key, value) => value == null);
      map.addAll(mapX);
    }
    return map;
  }

  String label (String key) {
    if (key == null) return 'NULL KEY';
    if (_map.containsKey(key)) return _map[key];
    return labelNoLanguage(key) + _langCode;
  }

  static labelNoLanguage (String key){
    return '[' + key + ']:';
  }
}

class LangLabel {
  final String key;
  final String label;
  String mi;
  String de;
  //Maori and German are optional
  LangLabel(this.key, this.label , { this.mi, this.de });
}

List<LangLabel> _en = [
  LangLabel('FocusApp', 'Focused Intention'),
  LangLabel('Lang', 'Language'),
  LangLabel('Error', 'Error, damn'),
  LangLabel('Group', 'Group', mi:'Group Maori', de:'Gruppe'),
  LangLabel('AddGroup', 'Add Group', mi:'Add Group Maori', de:'Add Group Deutsch'),
  LangLabel('AddComment', 'Add a comment'),
  LangLabel('DelGroups', 'Delete Groups'),
  LangLabel('Loading', 'Please wait its loading...'),
  LangLabel('InvalidGraph', 'Invalid Graph!'),
  LangLabel('Time', 'Time'),
  LangLabel('Trials', 'Trials'),
  LangLabel('Count', 'Number of Trails'),
  LangLabel('GraphTitle', 'Random Number Generator'),
  LangLabel('GraphX', 'Trials'),
  LangLabel('GraphY', 'Avg RN (200 trials)'),
  LangLabel('Confirm', 'Confirm'),
  LangLabel('Yes', 'Yes'),
  LangLabel('No', 'No'),
  LangLabel('Start','Start'),
  LangLabel('Pause','Pause'),
  LangLabel('Stop','Stop'),
  LangLabel('Save','Save'),
  LangLabel('Graphs', 'RNG Graphs'),
  LangLabel('NewGraph', 'New RNG Graph'),
  LangLabel('DelGraph', 'Delete Graph'),
  LangLabel('DelGraphQ', 'Are you sure you want to delete the graph?'),
  LangLabel('DelComment', 'Delete Comment'),
  LangLabel('DelCommentQ', 'Are you sure you want to delete the Comment?'),

  //Unit test code
  LangLabel('UTCode1', 'Unit Test Code 1'),
  LangLabel('UTCode2', 'Unit Test Code 2'),
];

List<LangLabel> _mi = [
  LangLabel('DelGroups', 'Delete Groups Maori'),

  //Unit test code
  LangLabel('UTCode1', 'Unit Test Code 1 Maori'),
];

List<LangLabel> _de = [
  LangLabel('Lang', 'Sprache'),
  LangLabel('DelGroups', 'Loschen Gruppen Deutsch'),
];
