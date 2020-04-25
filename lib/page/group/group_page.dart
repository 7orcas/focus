import 'package:flutter/material.dart';
import 'package:focus/model/group/group.dart';

class GroupPage extends StatelessWidget {
  Group _group;
  GroupPage(this._group);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("GroupPage"),
        ),
        body: new Center(
          child: Text(_group.name),
        ));
  }
}