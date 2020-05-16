import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/session/session.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/app/app_actions.dart';


class AppState {
  Session session;
  List<GroupTile> groups;
  GraphBuild _graphBuild;
  Map<int, bool> _graphExpansionKeys = {};

  AppState._({
    @required this.session,
    @required this.groups,
  });

  AppState copyWith(session, groups) {
    var app = AppState._(
      session: session ?? this.session,
      groups: groups ?? this.groups,
    );
    app._graphBuild = this._graphBuild;
    app._graphExpansionKeys = this._graphExpansionKeys;
    return app;
  }

  AppState.initialState(){
    Util(StackTrace.current).out('AppState initialState constructor');
    session = Session(langCode: 'en');
    groups = List.unmodifiable(<GroupTile>[]);
  }

  GraphBuild get graph => this._graphBuild;
  bool isGraphBlocRunning () {
    return this._graphBuild != null && this._graphBuild.isActive;
  }

  set graph (GraphBuild b){
    this._graphBuild = b;
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

  void addGroupTile(GroupTile tile){
    groups = groups.map((e) => e).where((t) => t.id != tile.id).toList();
    groups.add(tile);
  }

  void clearGraphExpansionKey() {
    _graphExpansionKeys = {};
  }
  void setGraphExpansionKey(int id, bool v) {
    _graphExpansionKeys[id] = v;
  }
  bool isGraphExpansionKey(int id) {
    return _graphExpansionKeys.containsKey(id)? _graphExpansionKeys[id] : false;
  }


}
