import 'package:flutter/material.dart';


class Language  {
  String _code;
  Map <String, String> _map;

  Language (String code) {
    _code = code;
    if (code == 'mi') _map = _listToMap(_mi);
    else if (code == 'de') _map = _listToMap(_de);
    else _map = _listToMap(_en);

    //English is default
    if (code != 'en'){
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
    return '[' + key + ']:' + _code.toString();
  }

}

class Lang {
  final String key;
  final String label;
  Lang(this.key, this.label);
}

List<Lang> _en = [
  Lang('Lang', 'Language'),
  Lang('AddGroup', 'Add Group'),
  Lang('DelGroups', 'Delete Groups'),
];

List<Lang> _mi = [
  Lang('AddGroup', 'Add Group Maori'),
  Lang('DelGroups', 'Delete Groups Maori'),
];

List<Lang> _de = [
  Lang('Lang', 'Sprache'),
  Lang('AddGroup', 'Add Group Deutsch'),
  Lang('DelGroups', 'Loschen Gruppen Deutsch'),
];
