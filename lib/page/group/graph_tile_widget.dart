import 'package:flutter/material.dart';
import 'package:focus/model/group/graph/graph_tile.dart';

class GraphTileWidget extends StatelessWidget {
  const GraphTileWidget(this._graph, this._onDeleteGraph, this._lang);

  final GraphTile _graph;
  final Function _onDeleteGraph;
  final Function _lang;


  Widget _buildTiles() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.purple, Colors.purple[100]],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 100,
          child: Row(
            children: <Widget>[
              Text(_graph.createdFormatShort(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 10),
              Container(
                  width: 280,
                  child: Text(_graph.firstCommentFormat(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, foreground: Paint()..shader =
                      LinearGradient(
                        colors: <Color>[Colors.white, Colors.deepPurple],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 600.0, 100.0))
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles();
  }
}
