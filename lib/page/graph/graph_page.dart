import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app_state.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/graph/graph_chart.dart';
import 'package:focus/page/graph/add_comment_widget.dart';
import 'package:focus/page/util/utilities.dart';

class GraphPage extends StatelessWidget {
  const GraphPage(this._graph);

  final GraphTile _graph;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GraphViewModel>(
        converter: (Store<AppState> store) =>
            GraphViewModel.create(context, store, _graph.id, _graph.id_group),
        builder: (BuildContext context, GraphViewModel model) {
          GraphTile _graph = model.getGraph();
          List<Widget> list = _widgetList(_graph, model);

          return SafeArea(
            child: Scaffold(
              appBar: new AppBar(
                title: new Text(_graph.createdFormat()),
              ),
              resizeToAvoidBottomPadding: true,
              body: Container(
                decoration: BoxDecoration(gradient: chakraColors),
                child: ListView(
                  children: list,
                ),
              ),
            ),
          );
        });
  }

  // List of objects within graph
  List<Widget> _widgetList(GraphTile _graph, GraphViewModel model) {
    //Widgets
    var infoStyle = TextStyle(fontSize: 14, color: Colors.white);

    //Add graph
    List<Widget> comments = [];

    //Add details
    comments.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(model.label('Time') + ':' + Util.timeFormat(_graph.seconds),
              style: infoStyle),
          SizedBox(width: 20),
          Text(model.label('Count') + ':' + _graph.count.toString(),
              style: infoStyle),
        ],
      ),
    ));

    //Add graph
    comments.add(Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GraphWidget(_graph.graph, model.label),
      ]),
    ));

    //Add comments
    comments.addAll(
        _graph.comments.map((c) => CommentWidget(_graph, c, model)).toList());

    //Add form entry
    comments.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 2, 0),
      child: AddCommentWidget(_graph.getEditComment(), model),
    ));

    return comments;
  }
}

class GraphWidget extends StatelessWidget {
  GraphWidget(this._graph, this._lang);

  final String _graph;
  final Function _lang;

  @override
  Widget build(BuildContext context) {
    Widget chart;
    try {
      List<double> l = GraphBuild.fromList(_graph);
      chart = FocusChart(GraphBuild.getChartData(l));
    } on Exception catch (e) {
      chart = Text(_lang('InvalidGraph'));
    }
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.white54, spreadRadius: 1),
          ],
          gradient: LinearGradient(
              colors: [
                Colors.purple[400],
                Colors.purple[100],
                Colors.purple[400]
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
//              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: SizedBox(width: 330.0, height: 200.0, child: chart));
  }
}

class CommentWidget extends StatelessWidget {
  CommentWidget(this._graph, this._comment, this._model);

  final GraphTile _graph;
  final CommentTile _comment;
  final GraphViewModel _model;

  @override
  Widget build(BuildContext context) {
    Color _grey = Colors.white;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit, color: _grey, size: 20),
                      onPressed: () => _model.onEditComment(_comment.id),
                    ),
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: SizedBox(
                            width: 400,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: Text(_comment.comment,
                                  style: TextStyle(color: Colors.black)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white54, spreadRadius: 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(_comment.createdFormat(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[300])),
                      ],
                    )),
                    IconButton(
                      icon: Icon(Icons.delete, color: _grey, size: 20),
                      onPressed: () => _model.onRemoveComment(_comment),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class GraphViewModel extends BaseViewModel {
  GraphTile graph;
  final Function() getGraph;
  final Function(int, String) onAddComment;
  final Function(int) onEditComment;
  final Function(CommentTile) onRemoveComment;

  GraphViewModel({
    store,
    this.graph,
    this.getGraph,
    this.onAddComment,
    this.onEditComment,
    this.onRemoveComment,
  }) : super(store);

  factory GraphViewModel.create(
      BuildContext context, Store<AppState> store, int id_graph, int id_group) {
    GroupTile _group = store.state.findGroupTile(id_group);
    GraphTile graph = _group.findGraphTile(id_graph);

    _getGraph() {
      return graph;
    }

    _onEditComment(int id_comment) {
      store.dispatch(EditGraphCommentAction(graph, id_comment));
    }

    _onAddComment(int id_comment, String comment) {
      store.dispatch(SaveGraphCommentAction(graph, id_comment, comment));
    }

    _onRemoveComment(CommentTile comment) {
      showConfirmDialog(
              'DelComment', 'DelCommentQ', store.state.session.label, context)
          .then((value) {
        if (value != null && value)
          store.dispatch(DeleteGraphCommentAction(comment));
      });
    }

    return GraphViewModel(
      store: store,
      graph: graph,
      getGraph: _getGraph,
      onAddComment: _onAddComment,
      onEditComment: _onEditComment,
      onRemoveComment: _onRemoveComment,
    );
  }
}
