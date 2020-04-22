import 'package:flutter/foundation.dart';

class Session {
  final String language;

  Session({
    @required this.language,
  });

  Session.initialState() : language = 'en';

  Session copyWith({String language}) {
    return Session(
      language: language ?? this.language,
    );
  }

  Session.fromJson(Map json)
    : language = json['lang'];

  Map toJson() => {
    'lang' : language,
  };

  @override
  String toString(){
    return toJson().toString();
  }

}
