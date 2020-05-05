import 'package:flutter/foundation.dart';
import 'package:focus/service/language.dart';

class Session {
  String _langCode;
  Language _language;

  _initialise (String code){
    _langCode = code;
    _language = Language(langCode);
  }

  Session({@required String langCode}) {
    _initialise(langCode);
  }

  Session.initialState() {
    _initialise(LANG_DEFAULT);
  }

  Session.fromJson(Map json){
    _initialise(json['lang']);
  }

  Map toJson() => {
        'lang': _langCode,
      };

  Session copyWith({String langCode}) {
    return Session(
      langCode: langCode ?? this._langCode,
    );
  }

  String get langCode => _langCode;
  Language get language => _language;

  //Convenience method
  String label(String key) {
    if (_language == null) return Language.labelNoLanguage(key);
    return _language.label(key);
  }

  @override
  String toString() {
    return toJson().toString();
  }

}
