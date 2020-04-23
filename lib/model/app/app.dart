import 'package:flutter/foundation.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/group.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app_actions.dart';

final util = Util(StackTrace.current);


class AppState {
  Session session;
  List<Group> groups;

  AppState({
    @required this.session,
    @required this.groups,
  });

  AppState.initialState(){
    util.out('AppState initialState constructor');
    session = Session(language: 'en');
    groups = List.unmodifiable(<Group>[]);
  }

  static LoadAppAction getLoadAppAction() {
    return LoadAppAction();
  }

  @override
  String toString(){
    return session.toJson().toString();
  }

}