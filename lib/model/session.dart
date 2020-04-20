import 'package:flutter/foundation.dart';

class Session {
  final String language;

  Session({
    @required this.language,
  });

  Session copyWith({String language}) {
    return Session(
      language: language ?? this.language,
    );
  }
}
