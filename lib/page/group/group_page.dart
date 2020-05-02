import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:focus/model/app/app.dart';
import 'package:flutter/material.dart';
import 'package:focus/database/db_group.dart';
import 'package:focus/model/group/group_conversation.dart';
import 'package:focus/model/group/group_tile.dart';
import 'package:focus/model/group/group_actions.dart';
import 'package:focus/model/group/graph/graph_tile.dart';
import 'package:focus/model/group/graph/graph_actions.dart';
import 'package:focus/model/group/comment/comment_tile.dart';
import 'package:focus/service/util.dart';

class GroupPage extends StatelessWidget {
  final GroupTile _group;
  GroupPage(this._group){
    Util(StackTrace.current).out('GroupPage constructor graphs build constains ' + _group.containsGraphs().toString());
  }

  Future<GroupConversation> getGroupConversation(_ViewModel viewModel){
    GroupConversation c = viewModel.store.state.findGroupTile(_group.id).toConversation();
    return Future<GroupConversation>.value(c);
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {

          //ToDo refactor
          bool load = viewModel.store.state.findGroupTile(_group.id).containsGraphs();
          var xx = load? getGroupConversation(viewModel) : GroupDB().loadGroupConversation(_group.id);

          return FutureBuilder<GroupConversation>(
              future: xx,
//              future: GroupDB().loadGroupConversation(_group.id),
              builder: (BuildContext context,
                  AsyncSnapshot<GroupConversation> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('....Please wait its loading...'));
                } else if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else {
                  GroupConversation c = snapshot.data;
                  if (!load){
                    viewModel.store.dispatch(AddGraphsAction(c.toGroupTile()));
                  }

                  return StoreConnector<AppState, _ViewModel>(
                      converter: (Store<AppState> store) =>
                          _ViewModel.create(store),
                      builder: (BuildContext context, _ViewModel viewModel) {
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
                            floatingActionButton: new FloatingActionButton(
                              onPressed: () {
                                viewModel.onAddGraph(
                                    _group,
                                    GraphTile(null, c.id, 'yyyy',
                                        List<CommentTile>()));
                              },
                              child: new Icon(Icons.add),
                            ),
                          ),
                        );
                      });
                }
              });
        });
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class GraphItem extends StatelessWidget {
  const GraphItem(this.entry);

  final GraphTile entry;

  Widget _buildTiles(GraphTile root) {
    List<StatelessWidget> comments = [GraphX('model of graph')];
    comments.addAll(entry.comments.map((c) => ItemX(c)).toList());

    return ExpansionTile(
      key: PageStorageKey<GraphTile>(root),
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

abstract class Base extends StatelessWidget {}

class GraphX extends Base {
  final String graph;
  GraphX(this.graph);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        graph,
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ItemX extends Base {
  final CommentTile comment;
  ItemX(this.comment);

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

class _ViewModel {
  final Store<AppState> store;
  final List<GroupTile> groups;
  final Function(GroupTile group, GraphTile graph) onAddGraph;

  _ViewModel({
    this.store,
    this.groups,
    this.onAddGraph,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddGraph(GroupTile group, GraphTile graph) {
      Util(StackTrace.current).out('_onAddGraph');
      store.dispatch(AddGraphAction(group, graph));
    }

    return _ViewModel(
      store: store,
      groups: store.state.groups,
      onAddGraph: _onAddGraph,
    );
  }
}
