import 'package:flutter/material.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/comment/comment_tile.dart';

class GraphItem extends StatelessWidget {
  const GraphItem(this._entry, this._onDeleteGraph);

  final GraphTile _entry;
  final Function _onDeleteGraph;

  Widget _buildTiles(GraphTile graph) {

    List<StatelessWidget> comments = [Graph('model of graph')];
    comments.addAll(_entry.comments.map((c) => Comment(c)).toList());

    return ExpansionTile(
      key: PageStorageKey<GraphTile>(graph),
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              Text(graph.graph),
              IconButton(icon: Icon(Icons.delete), onPressed: ()=>
                  _onDeleteGraph (graph),),
              Spacer(),
              IconButton(icon: Icon(Icons.add), onPressed: ()=>print ('ZZZZZZ'),),
            ],
          ),
        ),
      ),

      children: comments,

    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(_entry);
  }
}

//abstract class Item extends StatelessWidget {}

class Graph extends StatelessWidget {
  final String _graph;
  Graph(this._graph);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        _graph,
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final CommentTile _comment;
  Comment(this._comment);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(_comment.comment),
        ),
      ],
    );
  }
}