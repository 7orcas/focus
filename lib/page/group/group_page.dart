import 'package:flutter/material.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/model/group/group_tile.dart';

class GroupPage extends StatelessWidget {
  final GroupTile _group;
  GroupPage(this._group);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GroupConversation>(
        future: GroupDB().loadGroupConversation(_group.id),
        builder:
            (BuildContext context, AsyncSnapshot<GroupConversation> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            GroupConversation c = snapshot.data;

            return new Scaffold(
              appBar: new AppBar(
                title: new Text("GroupPage"),
              ),
              body: SizedBox(
                width: 1000,
                child: ListView(
                    children: c.graphs
                        .map((g) => ListTile(
                            title: Text(g.graph),
                            leading: SizedBox(
                              width: 150,
                              child: ListView(
                                children: g.comments
                                    .map((c) => SizedBox(
                                      width: 300,
                                      child: ListTile(
                                            leading: Text(c.comment),
                                          ),
                                    ))
                                    .toList(),
                              ),
                            )))
                        .toList()),
              ),
            );
          }
        });
  }
}
