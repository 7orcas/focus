import 'package:flutter/foundation.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app_actions.dart';

final util = Util(StackTrace.current);


class AppState {
  Session session;
  List<GroupTile> groups;

  AppState({
    @required this.session,
    @required this.groups,
  });

  AppState.initialState(){
    util.out('AppState initialState constructor');
    session = Session(langCode: 'en');
    groups = List.unmodifiable(<GroupTile>[]);
  }

//  Session get session => session;

  static LoadAppAction getLoadAppAction() {
    return LoadAppAction();
  }

  @override
  String toString(){
    return session.toJson().toString();
  }

  GroupTile findGroupTile(int id){
    for (GroupTile t in groups){
      if (t.id == id) return t;
    }
    return null;
  }

}
