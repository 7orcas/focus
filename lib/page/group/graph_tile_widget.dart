import 'package:flutter/material.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/page/util/utilities.dart';

class GraphTileWidget extends StatelessWidget {
  const GraphTileWidget(this._graph, this._onDeleteGraph, this._lang);

  final GraphTile _graph;
  final Function _onDeleteGraph;
  final Function _lang;

  @override
  Widget build(BuildContext context) {
    double textWidth = 500;
    if (MediaQuery.of(context).size.width < 500) textWidth = 240;

    Color color = _graph.isHighlight? Colors.grey[700] : Colors.white;

    return Container(
      decoration: BoxDecoration(
        gradient: _graph.isHighlight? graphHighlightColors : graphColors,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(_graph.createdFormatShort(hideSameYear: true),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(width: 15),
              Container(
                  width: textWidth,
                  child: Text(title(),
                      style: TextStyle(
                          fontSize: 13, color: color),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false)),
            ],
          ),
          Positioned(
            top: -10,
            right: 0,
            child: Container(
              child: SizedBox(
                height: 25,
                child: IconButton(
                  icon:
                      const Icon(Icons.delete, color: Color(0xFF9E9E9E), size: 20),
                  onPressed: () => _onDeleteGraph(_graph),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String title() {
    String x = _graph.firstCommentFormat();
    if (!x.isEmpty) return x;
    return _lang('Time') + ' ' + _graph.timeFormat();
  }
}
