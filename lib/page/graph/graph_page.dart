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
import 'package:focus/page/util/utilities.dart';

class GraphPage extends StatelessWidget {
  const GraphPage(this._graph);

  final GraphTile _graph;

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) =>
            _ViewModel.create(context, store, _graph.id, _graph.id_group),
        builder: (BuildContext context, _ViewModel model) {
          GraphTile _graph = model.getGraph();
          List<Widget> list = _widgetList(_graph, model);

          return Scaffold(
            appBar: new AppBar(
              title: new Text(_graph.createdFormat()),
            ),
            resizeToAvoidBottomPadding: true,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.indigo,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    tileMode: TileMode.clamp)),
              child: ListView(
                children: list,
              ),
            ),
          );
        });
  }

  // List of objects within graph
  List<Widget> _widgetList(GraphTile _graph, _ViewModel model) {
    //Widgets
    var infoStyle = TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[800]);

    //Add graph
    List<Widget> comments = [];

    //Add details
    comments.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(model.label('Time') + ':' + Util.timeFormat(_graph.time),
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
  final _ViewModel _model;

  @override
  Widget build(BuildContext context) {
    Color _grey = Colors.grey;

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
                            style: TextStyle(fontSize: 12, color: _grey)),
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

class AddCommentWidget extends StatefulWidget {
  AddCommentWidget(this.commentTile, this.model);

  final _ViewModel model;
  final CommentTile commentTile;

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddCommentWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Util(StackTrace.current).out('Comment Widget widget.commentTile=' +
        (widget.commentTile != null ? 'ok' : 'null'));

    controller.text =
        widget.commentTile != null ? widget.commentTile.comment : null;

    FocusNode _focus = new FocusNode();
    void _onFocusChange() {
      if (widget.model.store.state.isCommentFieldActive) return;
      debugPrint('*****Focus: ' + _focus.hasFocus.toString());
      widget.model.store.state.setCommentFieldActive();
      widget.model.store.dispatch(ToggleAddGraphButtonAction());
    }

    _focus.addListener(_onFocusChange);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 10, 0, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 6,
            child: TextField(
              autofocus: widget.model.store.state.isCommentFieldActive,
              key: PageStorageKey('mytextfield'),
              keyboardType: TextInputType.multiline,
              onEditingComplete: () {
//                print('***** onEditingComplete');
              },
              focusNode: _focus,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              controller: controller,
              decoration: InputDecoration(
                hintText: widget.model.label('AddComment'),
                border: OutlineInputBorder(),
                suffixIcon: widget.commentTile == null
                    ? null
                    : IconButton(
                        onPressed: () => widget.commentTile.editCancel(),
                        icon: Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          Flexible(
            child: Visibility(
              visible: widget.model.store.state.isCommentFieldActive,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      widget.model.store.state.clearCommentFieldActive();
                      widget.model.onAddComment(
                          widget.commentTile == null
                              ? null
                              : widget.commentTile.id,
                          controller.text);
                      controller.clear();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      widget.model.store.state.clearCommentFieldActive();
                      controller.clear();
                      FocusScope.of(context).unfocus();
                      widget.model.store.dispatch(ToggleAddGraphButtonAction());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel extends BaseViewModel {
  GraphTile graph;
  final Function() getGraph;
  final Function(int, String) onAddComment;
  final Function(int) onEditComment;
  final Function(CommentTile) onRemoveComment;

  _ViewModel({
    store,
    this.graph,
    this.getGraph,
    this.onAddComment,
    this.onEditComment,
    this.onRemoveComment,
  }) : super(store);

  factory _ViewModel.create(
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

    return _ViewModel(
      store: store,
      graph: graph,
      getGraph: _getGraph,
      onAddComment: _onAddComment,
      onEditComment: _onEditComment,
      onRemoveComment: _onRemoveComment,
    );
  }
}
