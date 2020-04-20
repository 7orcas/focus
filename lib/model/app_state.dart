import 'package:flutter/foundation.dart';
import 'package:focus/model/session.dart';
import 'package:focus/model/group.dart';

class AppState {
  final Session session;
  final List<Group> groups;

  AppState({
    @required this.session,
    @required this.groups,
  });

  AppState.initialState()
      : session = Session(language: 'en'),
        groups = List.unmodifiable(<Group>[]);
}
