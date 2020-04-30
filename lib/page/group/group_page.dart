import 'package:flutter/material.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph_entity.dart';
import 'package:focus/model/group/comment_entity.dart';

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
            return Center(child: Text('....Please wait its loading...'));
          } else if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            GroupConversation c = snapshot.data;
            return MaterialApp(
              home: Scaffold(
                appBar: new AppBar(
                  title: new Text("GroupPage"),
                ),
                body: ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      GraphItem(c.graphs[index]),
                  itemCount: c.graphs.length,
                ),
              ),
            );
          }
        });
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class GraphItem extends StatelessWidget {
  const GraphItem(this.entry);

  final GraphEntity entry;


  Widget _buildTiles(GraphEntity root) {
    List<StatelessWidget> comments = [GraphX('model of graph')];
    comments.addAll(entry.comments.map((c) => ItemX(c)).toList());

    return ExpansionTile(
      key: PageStorageKey<GraphEntity>(root),
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(root.graph + '  x'),
      ),
      children: comments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

abstract class Base extends StatelessWidget {
}

class GraphX extends Base {
  final String graph;
  GraphX (this.graph);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(graph,
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ItemX extends Base {
  final CommentEntity comment;
  ItemX (this.comment);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(comment.comment),
        ),
      ],
    );
  }

}
