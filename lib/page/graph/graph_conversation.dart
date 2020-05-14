import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:focus/service/util.dart';
import 'package:focus/model/app/app.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/model/group/graph/graph_build.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/page/base_view_model.dart';
import 'package:focus/page/graph/graph_chart.dart';

class GraphItem extends StatelessWidget {
  const GraphItem(
      this._id_graph, this._id_group, this._onDeleteGraph, this._lang);

  final int _id_group;
  final int _id_graph;
  final Function _onDeleteGraph;
  final Function _lang;

  Widget _buildTiles() {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) =>
            _ViewModel.create(store, _id_graph, _id_group),
        builder: (BuildContext context, _ViewModel model) {
          GraphTile _graph = model.getGraph();
          var _key = 'graph' + _graph.id.toString();

          List<Widget> comments = [Graph(_graph.graph, _lang)];
          comments.addAll(_graph.comments.map((c) => CommentWidget(_graph, c, model)).toList());
          comments.add(AddCommentWidget(_graph.getEditComment(), model));

          Util(StackTrace.current).out('_GraphItemState Comment key=' +
              _key +
              ' value=' +
              model.store.state.isExpansionKey(_key).toString());

          return ExpansionTile(
            key: PageStorageKey<String>(_key),
            initiallyExpanded: model.store.state.isExpansionKey(_key),
            onExpansionChanged: (v) =>
                model.store.state.setExpansionKey(_key, v),
            title: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 100,
                child: Row(
                  children: <Widget>[
                    Text(_graph.graph.substring(0, 7)), //ToDo delete
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _onDeleteGraph(_graph),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => print('ZZZZZZ'),
                    ),
                  ],
                ),
              ),
            ),
            children: comments,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles();
  }
}

//abstract class Item extends StatelessWidget {}

class Graph extends StatelessWidget {
  Graph(this._graph, this._lang);

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
    return SizedBox(width: 200.0, height: 200.0, child: chart);
  }
}

class CommentWidget extends StatelessWidget {
  final GraphTile _graph;
  final CommentTile _comment;
  final _ViewModel model;
  CommentWidget(this._graph, this._comment, this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => model.onRemoveComment(_comment),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _graph.editComment(_comment.id),
              ),
              Expanded(child: Text(_comment.comment)),
            ],
          ),
        ),

      ],
    );
  }
}

class AddCommentWidget extends StatefulWidget {
  final _ViewModel model;
  final CommentTile commentTile;
  AddCommentWidget(this.commentTile, this.model);
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddCommentWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Util(StackTrace.current).out('Comment Widget widget.commentTile=' + (widget.commentTile!=null?'ok':'null'));

    controller.text = widget.commentTile != null? widget.commentTile.comment : null;

    return TextField(
      key: PageStorageKey('mytextfield'),
      controller: controller,
      decoration: InputDecoration(
        hintText: widget.model.label('AddComment'),
        suffixIcon: widget.commentTile == null? null : IconButton(
          onPressed: () => widget.commentTile.editCancel(),
          icon: Icon(Icons.clear),
        ),
      ),
      onSubmitted: (String comment) {
        controller.clear();
        widget.model.onAddComment(widget.commentTile == null? null : widget.commentTile.id, comment);
      },
    );
  }
}

class _ViewModel extends BaseViewModel {
  GraphTile graph;
  final Function() getGraph;
  final Function(int, String) onAddComment;
  final Function(CommentTile) onRemoveComment;

  _ViewModel({
    store,
    this.graph,
    this.getGraph,
    this.onAddComment,
    this.onRemoveComment,
  }) : super(store);

  factory _ViewModel.create(Store<AppState> store, int id_graph, int id_group) {
    GroupTile _group = store.state.findGroupTile(id_group);
    GraphTile graph = _group.findGraphTile(id_graph);

    _getGraph() {
      return graph;
    }

    _onEditComment() {
      store.dispatch(AddGraphCommentAction(graph, id_comment, comment));
    }

    _onAddComment(int id_comment, String comment) {
      Util(StackTrace.current).out('_onAddComment');
      store.dispatch(AddGraphCommentAction(graph, id_comment, comment));
    }

    _onRemoveComment(CommentTile comment) {
      Util(StackTrace.current).out('_onRemoveComment');
      store.dispatch(RemoveGraphCommentAction(comment));
    }

    return _ViewModel(
      store: store,
      graph: graph,
      getGraph: _getGraph,
      onAddComment: _onAddComment,
      onRemoveComment: _onRemoveComment,
    );
  }
}
