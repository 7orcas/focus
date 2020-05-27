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
            colors: [Colors.purple[500], Colors.purple[300], Colors.purple],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(_graph.createdFormatShort(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(width: 10),
              Container(
                  width: 250,
                  child: Text(_graph.firstCommentFormat(),
                      style: TextStyle(fontSize: 13, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false)),
              SizedBox(width: 25),
              SizedBox(
                height: 25.0,
                width: 20.0,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey[400], size: 20),
                  onPressed: () => _onDeleteGraph(_graph),
                ),
              )
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
