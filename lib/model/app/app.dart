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
  GraphBuild _graph;
  Map<String, bool> expansionKeys = {};

  AppState({
    @required this.session,
    @required this.groups,
  });

  AppState.initialState(){
    Util(StackTrace.current).out('AppState initialState constructor');
    session = Session(langCode: 'en');
    groups = List.unmodifiable(<GroupTile>[]);
  }

  GraphBuild get graph => this._graph;
  bool isGraphBlocRunning () {
    return this._graph != null && this._graph.isActive;
  }

  set graph (GraphBuild b){
    this._graph = b;
  }


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

  void setGroupTile(GroupTile tile){
    groups = groups.map((e) => e).where((t) => t.id != tile.id).toList();
    groups.add(tile);
  }

  void setExpansionKey(String k, bool v) {
    expansionKeys[k] = v;
  }
  bool isExpansionKey(String k) {
    return expansionKeys.containsKey(k)? expansionKeys[k] : false;
  }


}
